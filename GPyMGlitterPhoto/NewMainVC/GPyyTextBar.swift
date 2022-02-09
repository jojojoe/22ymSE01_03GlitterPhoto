//
//  GPyyTextBar.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import Foundation
import UIKit


class GPyyTextBar: UIView {
    
    let fontBar = GPyyTextFontView()
    let colorBar = GPyyTextColorView()
    var colorClickBlock: ((String, IndexPath)->Void)?
    var fontClickBlock: ((String, IndexPath)->Void)?
    var addNewBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        fontBar.adhere(toSuperview: self)
        fontBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(48)
        }
        fontBar.addNewBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.addNewBtnClickBlock?()
        }
        fontBar.fontDidSelectBlock = {
            [weak self] font, indexPath in
            guard let `self` = self else {return}
            self.fontClickBlock?(font, indexPath)
        }
        
        //

        colorBar.adhere(toSuperview: self)
        colorBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(fontBar.snp.bottom)
            $0.height.equalTo(48)
        }
         
        colorBar.colorDidSelectBlock = {
            [weak self] color, indexPath in
            guard let `self` = self else {return}
            self.colorClickBlock?(color, indexPath)
        }
        
        
        
    }
    
}

extension GPyyTextBar {
    
}





