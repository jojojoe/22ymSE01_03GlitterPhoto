import UIKit
import AdServices
import AdSupport
import Alamofire
import SwifterSwift

class ASAManage: NSObject {
    var afID = ""
    
    static let singleton = ASAManage()
    private override init() {
    }
    
    private let AppDelegateASAKey = "AppDelegate_ASA_Key"
    func getASA() {
        if let _ = self.getASAAttributionDic() {
            
            NotificationCenter.default.post(name: .notificationPostASA, object: nil)
        } else {
            setASA()
        }
    }
    
    func setASA() {
        
        
        if TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1 {
            return
        }
        
        let temp = self.getASAAttributionDic()
        if let temp = temp,
           !temp.isEmpty {
            return
        }
        
        if #available(iOS 14.3, *) {
            do {
                let token = try AdServices.AAAttribution.attributionToken()
                self.requestAttribution(token: token)
            } catch {
                
            }
        } else {
            
        }
        
    }
    
    func getASAAttributionDic() -> [String:Any]? {
        let temp = UserDefaults.standard.data(forKey: self.AppDelegateASAKey)
        if let dic = try? temp?.jsonObject() as? [String:Any] {
            return dic
        }
        return nil
    }
    
    func requestAttribution(token: String) {
        
        if token.isEmpty {return}
        
        
                
        let rootStr = "gsso9..`r`-env`qcsdbg-bnl".formatte()
        let urlStr = rootStr + "/attribution/asa/\("nodm".formatte())/token"
        
        guard let url = URL(string: urlStr) else { return }
        
        let dic: [String:String] = [
            "token":token,
            "shushuDistinctId" : "",
            "shushuAccountId" : "dbb303558c32490a8a26b79fa3e12f8c",
            "idfa" : ASIdentifierManager.shared().advertisingIdentifier.uuidString,
            "deviceId" : UIDevice.getDeviceIdStr(),
            "bundleId" : Bundle.main.bundleIdentifier ?? "",
            "afId": afID
        ]
        
        
        AF.request(url,
                   method: .post,
                   parameters: dic,
                   encoding: JSONEncoding.default,
                   requestModifier: { (request) in
                    request.timeoutInterval = 30.0
                   })
            .responseData { response in
                
                switch response.result {
                
                case .success(let value):
                    
                    if let dic = try? value.jsonObject() as? [String:Any] {
                        let code = dic["code"] as? Int
                        if code == 6000 {
                            
                            if let records = dic["records"] as? [String:Any] {
                                
                                UserDefaults.standard.set(records.jsonData(), forKey: self.AppDelegateASAKey)
                                UserDefaults.standard.synchronize()
                                self.getASA()
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
}

extension UIDevice {
    
    static func getDeviceIdStr() -> String {
        
        let userDef = UserDefaults.standard
        if let identifier = userDef.string(forKey: "AppDeviceIdKey") {
            return identifier
        }
        
        
        let uuidString = UUID().uuidString
        userDef["AppDeviceIdKey"] = uuidString
        return uuidString
    }
}

extension Notification.Name {
    static let notificationPostASA = Notification.Name("notificationPostASA")
    static let notificationPostAFlyerLib = Notification.Name("notificationPostAFlyerLib")
    static let notificationAGet = Notification.Name("notificationAGet")
    static let notificatioinPostNext = Notification.Name("postNext")
    static let notificationHelloWord = Notification.Name("HelloWord")
}
