//
//  DataEncoding.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//

import UIKit
import Foundation
import CryptoSwift


class DataEncoding {
    static let shared = DataEncoding()
    private init() {
        
    }
    let SHAkey = "HightLigting"
    let key = ("HightLigting".data(using: .utf8)?.bytes)!
    let iv = ("1234567890123456".data(using: .utf8)?.bytes)!
    func aesEncrypted(string:String) -> String? {
        var encryptedBytes:String?
        let ps = (string.data(using: .utf8)?.bytes)!
        do {
            encryptedBytes = try AES(key:  Padding.zeroPadding.add(to: SHAkey.bytes, blockSize: AES.blockSize), blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(ps).toBase64()
        } catch {
            debugPrint(error)
        }

        return encryptedBytes
    }


    func aesDecrypted(string:String?) -> String? {
        guard let rString = string else { return nil }
        let data = Data(base64Encoded: rString)
        guard let encrypted = data?.bytes else { return nil }
        var decryptedString:String?
        do {
            let decrypted = try AES(key:  Padding.zeroPadding.add(to: SHAkey.bytes, blockSize: AES.blockSize), blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)

            let decryptedData = Data(decrypted)

            decryptedString = String(data: decryptedData, encoding: .utf8)
            // block size exceeded
        } catch {
           debugPrint(error)
        }


        return decryptedString
    }


}
