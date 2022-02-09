//
//  UserModel.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//
import UIKit
import SwiftyJSON
import RxRelay
import Defaults
import SwifterSwift

public class HightLigtingUserManager {
    public static var `default` = HightLigtingUserManager()
    
    public let currentlyFireUserRelay: BehaviorRelay<HightLigtingCacheUser?>
    public let fireUserListRelay: BehaviorRelay<[HightLigtingCacheUser]>

    public fileprivate(set) var currentlyFireUser: HightLigtingCacheUser? = Defaults[.currentlyFireUser] {
        didSet {
            Defaults[.currentlyFireUser] = currentlyFireUser
            currentlyFireUserRelay.accept(currentlyFireUser)
            if let user = currentlyFireUser {
                 fireUserList.bringToFront(item: user)
            }
        }
    }
    
    public fileprivate(set) var fireUserList: [HightLigtingCacheUser] = Defaults[.HightLigtingUserList] {
        didSet {
            Defaults[.HightLigtingUserList] = fireUserList
            fireUserListRelay.accept(fireUserList)
        }
    }
    
    
    private init() {
        currentlyFireUserRelay = BehaviorRelay<HightLigtingCacheUser?>(value: currentlyFireUser)
        fireUserListRelay = BehaviorRelay<[HightLigtingCacheUser]>(value: fireUserList)
       
    }
}

extension HightLigtingUserManager {
    
    func postCurrentlyUserDidChange() {
        currentlyFireUserRelay.accept(currentlyFireUser)
    }
}

extension HightLigtingUserManager {
    
    func clearCookies(_ user: HightLigtingCacheUser? = `default`.currentlyFireUser) {
        guard var user = user else { return }
        user.cookie = nil
        fireUserList.replace(item: user)
        currentlyFireUser = user
    }

    
    func addOrReplaseUser(_ user: HightLigtingCacheUser?) {
        guard let user = user else { return }
        fireUserList.replace(item: user)
        currentlyFireUser = user
    }

    
    func removeUser(_ user: HightLigtingCacheUser?) {
        guard let user = user else { return }
        fireUserList.removeAll(where: { $0.userId == user.userId })
        if fireUserList.isEmpty {
            currentlyFireUser = nil
        }
    }
    

    func louUser(_ user: HightLigtingCacheUser?) {
        guard let user = user else { return }
        currentlyFireUser = nil
    }
    
    
    
    func switchUser(_ userID: String?) {
        let fireUser = HightLigtingUserManager.default.fireUser(id: userID)
        HightLigtingUserManager.default.addOrReplaseUser(fireUser)
    }
    

    func fireUser(id: String?) -> HightLigtingCacheUser? {
        return fireUserList.filter { $0.userId == id }.first
    }
    
    func fireUser(userName: String?) -> HightLigtingCacheUser? {
        return fireUserList.filter { $0.nickName == userName }.first
    }
    
}

private extension Array where Element == HightLigtingCacheUser {
    mutating func replace(item: Element) {
        var array = self
        array.removeAll(where: {$0.userId == item.userId})
        array.insert(item, at: 0)
        self = array
    }
}



public struct HightLigtingCacheUser:Codable,Equatable {
    init(item: HightLigting,cookies: String?) {

        userId = (item.userId)?.string ?? ""
        nickName = item.username ?? ""
        fullName = item.fullname ?? ""
        avatar = item.avatar ?? ""
        folCount = item.followerCount ?? 0
        follingCount = item.followingCount ?? 0
        isPrivate = item.isPrivate
        cookie = cookies
    }
    
    var userId: String
    var nickName: String
    var fullName: String
    var avatar: String
    var folCount: Int
    var follingCount: Int
    var isPrivate: Bool?
    var cookie: String?
}

extension Data {
    public func mapModel<T: Codable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: self)
    }
}


public struct HightLigting: Codable, Equatable {

    public var userId: Int?
    public var fullname:String?
    public var username:String?
    public var followerCount:Int?
    public var followingCount:Int?
    public var avatar:String?
    public var isPrivate: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case userId = "pk"
        case username
        case fullname = "full_name"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case avatar = "profile_pic_url"
        case isPrivate = "is_private"
    }
   
}
