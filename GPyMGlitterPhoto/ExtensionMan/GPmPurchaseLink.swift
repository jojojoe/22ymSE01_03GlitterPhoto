//
//  GPmPurchaseLink.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//


import UIKit
import Alamofire
import StoreKit
import ZKProgressHUD
import SwiftyStoreKit

class GPmyPurchaseManagerLink: NSObject {
    static let `default` = GPmyPurchaseManagerLink()
    let buyManage = HightLightingPriceManager.default
    var currencyCode = "USD"
    var currentBuyModel: GPInCyStoreItem?
    var purchaseCompletion: ((Bool, String?)->Void)?
    
    
    
    override init() {
        // coin count
        super.init()
        addObserver()
        setupBuyManager()
    }
    deinit {
        buyManage.removeObserver()
    }
    
    func addObserver() {
        buyManage.addObserver()
    }
    
    func setupBuyManager() {
        buyManage.callBackBlock = { transaction in
            switch transaction.transactionState {
            case .purchased:
                print("💩💩💩💩purchased")
                ZKProgressHUD.dismiss()
                // 购买成功
                SKPaymentQueue.default().finishTransaction(transaction)
                if let model = self.currentBuyModel {
                    let price = model.price.float()

                    // new add
                    GPyymCoinManagr.default.addCoin(coin: model.coin)
                    AFlyerLibManage.event_PurchaseSuccessAll(symbolType: "$", needMoney: Float(price ?? 0.0), iapId: model.iapId)
                    self.purchaseCompletion?(true, nil)
                    //
                }
                break
                
            case .purchasing:
                print("💩💩💩💩purchasing")
                break
                
            case .restored:
                print("💩💩💩💩restored")
                ZKProgressHUD.dismiss()
                ZKProgressHUD.showError(transaction.error?.localizedDescription)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            case .failed:
                print("💩💩💩💩failed")
                //交易失败
                ZKProgressHUD.dismiss()
                
                SKPaymentQueue.default().finishTransaction(transaction)
                self.purchaseCompletion?(false, transaction.error?.localizedDescription)
                break
            default:
                break
            }
        }
        
        buyManage.callBackProductErrorBlock = {
            DispatchQueue.main.async {
                ZKProgressHUD.dismiss()
                ZKProgressHUD.showError("Purchase Failed")
            }
        }
        

    }
    
    func purchaseIapId(item: GPInCyStoreItem, completion: @escaping ((Bool, String?)->Void)) {
        self.purchaseCompletion = completion
        buyIcon(model: item)
        
    }
    
    func buyIcon(model: GPInCyStoreItem) {
        let netManager = NetworkReachabilityManager()
        netManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable :
                self.netWorkError()
                break
            case .unknown :
                self.netWorkError()
                break
            case .reachable(_):
                
                ZKProgressHUD.show()
                self.currentBuyModel = model
                self.buyManage.validateIsCanBought(iapID: model.iapId)
                break
            }
        })
        
    }
    func netWorkError() {
        ZKProgressHUD.showError("The network is not reachable. Please reconnect to continue using the app.")
     
    }
}
