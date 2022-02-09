//
//  GPySettingVC.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/14.
//

import UIKit

import UIKit
import SwifterSwift
import MessageUI



class GPySettingVC: UIViewController {
   let privacyBtn = UIButton(type: .custom)
   let termsBtn = UIButton(type: .custom)
   let feedbackBtn = UIButton(type: .custom)
   let backBtn = UIButton(type: .custom)
    var cancelClickActionBlock: (()->Void)?
   
   override func viewDidLoad() {
       super.viewDidLoad()

       setupView()
       
       
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
   }
   
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       
   }
     
   //
   
   func setupView() {
       view
           .backgroundColor(UIColor.black.withAlphaComponent(0.5))
       view.clipsToBounds()
        
       //
       
       backBtn
           .adhere(toSuperview: view)
       backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
       backBtn.snp.makeConstraints {
           $0.top.right.left.bottom.equalToSuperview()
       }
       
       
       //
       let bottomBgV = UIView()
       bottomBgV.backgroundColor(UIColor.white)
           .adhere(toSuperview: view)
       bottomBgV.layer.cornerRadius = 20
       bottomBgV.layer.masksToBounds = true
       bottomBgV.snp.makeConstraints {
           $0.left.equalToSuperview().offset(24)
           $0.right.equalToSuperview().offset(-24)
           $0.height.equalTo(240)
           $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
       }
       //
       feedbackBtn
           .title("Feedback")
           .backgroundColor(UIColor.clear)
           .titleColor(UIColor(hexString: "#2E2926")!)
           .font(20, "Baskerville")
           .adhere(toSuperview: bottomBgV)
       feedbackBtn.contentHorizontalAlignment = .center
//       feedbackBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       feedbackBtn.snp.makeConstraints {
           $0.left.right.equalToSuperview()
           $0.height.equalTo(80)
           $0.centerX.equalToSuperview()
           $0.top.equalToSuperview().offset(0)
       }
       feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
       //
       let feedbackLine = UIView()
       feedbackLine.backgroundColor(UIColor(hexString: "#ADB8D9")!)
       feedbackLine.adhere(toSuperview: feedbackBtn)
       feedbackLine.snp.makeConstraints {
           $0.height.equalTo(0.5)
           $0.bottom.equalToSuperview()
           $0.right.equalTo(0)
           $0.left.equalTo(0)
       }
       
       //
       termsBtn
           .title("Terms of use")
           .backgroundColor(UIColor.clear)
           .titleColor(UIColor(hexString: "#2E2926")!)
           .font(20, "Baskerville")
           .adhere(toSuperview: bottomBgV)
       termsBtn.contentHorizontalAlignment = .center
//       termsBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       termsBtn.snp.makeConstraints {
           $0.left.right.equalToSuperview()
           $0.height.equalTo(80)
           $0.centerX.equalToSuperview()
           $0.top.equalTo(feedbackBtn.snp.bottom).offset(0)
       }
       termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
       
       //
       let termsLine = UIView()
       termsLine.backgroundColor(UIColor(hexString: "#ADB8D9")!)
       termsLine.adhere(toSuperview: termsBtn)
       termsLine.snp.makeConstraints {
           $0.height.equalTo(0.5)
           $0.bottom.equalToSuperview()
           $0.right.equalTo(0)
           $0.left.equalTo(0)
       }
       
       //
       privacyBtn
           .title("Privacy Policy")
           .backgroundColor(UIColor.clear)
           .titleColor(UIColor(hexString: "#2E2926")!)
           .font(20, "Baskerville")
           .adhere(toSuperview: bottomBgV)
       privacyBtn.contentHorizontalAlignment = .center
//       privacyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       
       privacyBtn.snp.makeConstraints {
           $0.left.right.equalToSuperview()
           $0.height.equalTo(80)
           $0.centerX.equalToSuperview()
           $0.top.equalTo(termsBtn.snp.bottom).offset(0)
       }
       privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
       //
//       let privacyLine = UIView()
//       privacyLine.backgroundColor(UIColor(hexString: "#ADB8D9")!)
//       privacyLine.adhere(toSuperview: privacyBtn)
//       privacyLine.snp.makeConstraints {
//           $0.height.equalTo(0.5)
//           $0.bottom.equalToSuperview()
//           $0.right.equalTo(0)
//           $0.left.equalTo(0)
//       }
       
       
       
   }

   
   @objc func backBtnClick(sender: UIButton) {
//       if self.navigationController != nil {
//           self.navigationController?.popViewController()
//       } else {
//           self.dismiss(animated: true, completion: nil)
//       }
       cancelClickActionBlock?()
   }
   
   @objc func privacyBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
       let vc = HighLightingViewController(contentUrl: nil)
       vc.pushSaferiVC(url: PrivacyPolicyURLStr)
       
   }
   
   @objc func termsBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: TermsofuseURLStr)
       let vc = HighLightingViewController(contentUrl: nil)
       vc.pushSaferiVC(url: TermsofuseURLStr)
        
   }
   
   @objc func feedbackBtnClick(sender: UIButton) {
       feedback()
   }
   
   
}

extension GPySettingVC: MFMailComposeViewControllerDelegate {
  func feedback() {
      //首先要判断设备具不具备发送邮件功能
      if MFMailComposeViewController.canSendMail(){
          //获取系统版本号
          let systemVersion = UIDevice.current.systemVersion
          let modelName = UIDevice.current.modelName
          
          let infoDic = Bundle.main.infoDictionary
          // 获取App的版本号
          let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
          // 获取App的名称
          let appName = "\(AppName)"

          
          let controller = MFMailComposeViewController()
          //设置代理
          controller.mailComposeDelegate = self
          //设置主题
          controller.setSubject("\(appName) Feedback")
          //设置收件人
          // FIXME: feed back email
          controller.setToRecipients([feedbackEmail])
          //设置邮件正文内容（支持html）
       controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
          
          //打开界面
       self.present(controller, animated: true, completion: nil)
      }else{
          HUD.error("The device doesn't support email")
      }
  }
  
  //发送邮件代理方法
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
  }
}


extension GPySettingVC {
   
//   func showLoginVC() {
//       if APLoginMana.currentLoginUser() == nil {
//           let loginVC = APLoginMana.shared.obtainVC()
//           loginVC.modalTransitionStyle = .crossDissolve
//           loginVC.modalPresentationStyle = .fullScreen
//
//           self.present(loginVC, animated: true) {
//           }
//       }
//   }
//   func updateUserAccountStatus() {
//       if let userModel = APLoginMana.currentLoginUser() {
//           let userName = userModel.userName ?? ""
////            loginUserNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Signed in with apple ID"
//           logoutBtn.isHidden = false
//           //
//           let logoutStr = "Log out (\(userName))"
//           
//           let logoutAttriStr = NSMutableAttributedString(string: logoutStr, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-DemiBold", size: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#735950")!.withAlphaComponent(0.6)])
//           
//           let ran1 = logoutStr.range(of: "Log out")
//           let ran1n = "".nsRange(from: ran1!)
//           logoutAttriStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hexString: "#735950")!], range: ran1n)
//           logoutBtn.setAttributedTitle(logoutAttriStr, for: .normal)
//           
////            loginUserNameLabel.isHidden = false
//           loginBtn.isHidden = true
//
//           
//       } else {
////            loginUserNameLabel.text = ""
//           logoutBtn.isHidden = true
////            loginUserNameLabel.isHidden = true
//           loginBtn.isHidden = false
//
//           
//       }
//   }
}
//extension String {
//   /// range转换为NSRange
//   func nsRange(from range: Range<String.Index>) -> NSRange {
//       return NSRange(range, in: self)
//   }
//}
