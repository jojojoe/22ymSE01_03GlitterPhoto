//
//  InnTwoFactorLiView.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//
import UIKit

class InnTwoFactorLiView: UIView {
    @IBOutlet weak var codeView:UIView!
    @IBOutlet weak var tipLab:UILabel!
    @IBOutlet weak var okBtn:UIButton!
    @IBOutlet weak var bottomLab:UILabel!
    @IBOutlet weak var codeTF:UITextField!
    var okActionHandler:((_ code:String?)->())?
    var closeClick:(()->())?
    
    var codeStr:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.okBtn.isEnabled = true
        self.okBtn.backgroundColor = UIColor.init(red: 14.0 / 255.0, green: 129.0 / 255.0, blue: 221.0 / 255.0, alpha: 1)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    @IBAction func okAction(_ sender:Any) {
        if self.codeTF.text?.count ?? 0 > 0 {
          self.okActionHandler?(self.codeTF.text)
        }
    }


    @IBAction func closeAction(_ sender:Any) {
        self.closeClick?()
    }
}
