//
//  HightLightingPriceManager.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//
import UIKit
import Defaults
import SwiftyStoreKit
import StoreKit
import ZKProgressHUD

public class HightLightingPriceManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    public var callBackBlock: ((_ transaction: SKPaymentTransaction) -> Void)?
    public var callBackProductErrorBlock: (() -> Void)?
    
    public static var `default` = HightLightingPriceManager()
    struct IAPProduct: Codable {
         public var iapID: String
         public var price: Double
         public var priceLocale: Locale
         public var localizedPrice: String?
         public var currencyCode: String?
     }
    
    func first() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    break
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    static var localIAPProducts: [IAPProduct]? = Defaults[.localIAPProducts] {
        didSet { Defaults[.localIAPProducts] = localIAPProducts }
    }

    static var localIAPCacheTime: TimeInterval? = Defaults[.localIAPCacheTime] {
        didSet { Defaults[.localIAPCacheTime] = localIAPCacheTime }
    }
    
    func removeAllLocalIAPProducts() {
        HightLightingPriceManager.localIAPProducts = nil
        HightLightingPriceManager.localIAPCacheTime = nil
    }
    
    func retrieveProductsInfo(iapList: [String],
                              completion: @escaping (([IAPProduct]?) -> Void)) {
        let requestList = Set(iapList)
        SwiftyStoreKit.retrieveProductsInfo(requestList) { result in
            if  result.error != nil {
                completion(nil)
                return
            }
          
            let priceList = result.retrievedProducts.compactMap { $0 }
            let localList = priceList.compactMap { HightLightingPriceManager.IAPProduct(
                iapID: $0.productIdentifier,
                price: $0.price.doubleValue,
                priceLocale: $0.priceLocale,
                localizedPrice: $0.localizedPrice,
                currencyCode: $0.priceLocale.currencyCode
                ) }
            
            HightLightingPriceManager.localIAPProducts = localList
            HightLightingPriceManager.localIAPCacheTime = Date().unixTimestamp
            completion(localList)
        }
    }
    
    
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
    func validateIsCanBought(iapID: String) {
        productInfo(iapID: iapID)
    }
    
    func productInfo(iapID: String) {
        let result = SKProductsRequest.init(productIdentifiers: [iapID])
        result.delegate = self
        result.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productsArr = response.products
        
        if productsArr.count == 0 {
            
            DispatchQueue.main.async {
                self.callBackProductErrorBlock?()
            }
            
            return
        }
        
        let payment = SKPayment.init(product: productsArr[0])
        SKPaymentQueue.default().add(payment)
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        DispatchQueue.main.async {
            
            for transaction in transactions {
                self.callBackBlock?(transaction)
            }
        }
    }
}


