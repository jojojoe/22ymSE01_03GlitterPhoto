//
//  InnTextView.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//

import UIKit

@objc protocol InnTextViewDelegate: class {
    @objc optional func textViewDidFinishedEdit(codeStr:String)
    @objc optional func textViewDidChangeEdit(codeStr:String)
}


class InnTextView: UIView {
    
    typealias TextDidFinished = (String?) -> ()
    var textFinished:TextDidFinished?
    var maxCount:Int = 0
    var normalTextColor:UIColor = UIColor.black
    var highlightTextColor:UIColor = UIColor.white
    var normalBorderColor:UIColor = UIColor.lightGray
    var highlightBorderColor:UIColor = UIColor.white
    weak var delegate:InnTextViewDelegate?
    
    lazy var backgroundView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap))
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var textView: UITextView = {
        let `textView` = UITextView.init(frame: self.bounds)
        textView.tintColor = UIColor.clear
        textView.textColor = UIColor.clear
        textView.delegate = self
        textView.keyboardType = .numberPad
        return textView
    }()
    
    init(frame:CGRect,codeSize:CGSize, maxCount:Int){
        super.init(frame: frame)
        self.maxCount = maxCount
        
        self.addSubview(backgroundView)
        self.backgroundView.subviews.forEach{$0.removeFromSuperview()}
        for i in 0 ..< maxCount  {
            let showLabel = UILabel()
            showLabel.textAlignment = .center;
            showLabel.backgroundColor = UIColor.white
            showLabel.textColor = UIColor.black
            showLabel.layer.borderWidth = 1
            showLabel.layer.borderColor = UIColor.lightGray.cgColor
            showLabel.layer.cornerRadius = 5
            showLabel.tag = 1000 + i
            
    
            let space = (frame.size.width - size.width * CGFloat(maxCount))/(CGFloat(maxCount) - 1)
        
            showLabel.frame = CGRect(x: CGFloat(i) * (size.width + space) , y: (frame.size.height - size.height)/2.0, width: size.width, height: size.height)
            backgroundView.addSubview(showLabel)
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InnTextView {

   func setUpBorder(
       _ normalBorderColor: UIColor,
       highlightBorderColor: UIColor,
       borderWidth: CGFloat,
       borderCornerRadius: CGFloat
   )
    {
        self.normalBorderColor = normalBorderColor
        self.highlightBorderColor = highlightBorderColor
        
        for i in 0 ..< maxCount  {
            let showLabel =  backgroundView.viewWithTag(1000+i) as? UILabel
            showLabel?.layer.borderColor = normalBorderColor.cgColor
            showLabel?.layer.borderWidth = borderWidth
            showLabel?.layer.cornerRadius = borderCornerRadius
        }
       
        
    }

    func setUpText(_ normalTextColor:UIColor,
                    highlightColor:UIColor,
                    textFont:UIFont,
                    textAlignment:NSTextAlignment,
                    keyboardType:UIKeyboardType)
    {
        self.textView.keyboardType = keyboardType
        self.normalTextColor = normalTextColor
        self.highlightBorderColor = highlightColor
        for i in 0 ..< maxCount  {
            let showLabel =  backgroundView.viewWithTag(1000+i) as? UILabel
            showLabel?.textColor = normalTextColor
            showLabel?.font = textFont
            showLabel?.textAlignment = textAlignment
        }
              

    }
    
    func clearCode() {
        self.textView.text = ""
        
        for i in 0 ..< maxCount  {
            let showLabel =  backgroundView.viewWithTag(1000+i) as? UILabel
            showLabel?.text = "";
            showLabel?.layer.borderColor = self.normalBorderColor.cgColor
            showLabel?.textColor = self.normalTextColor
        }
        
        let selectLabel = backgroundView.viewWithTag(1000) as? UILabel
        selectLabel?.layer.borderColor = self.highlightBorderColor.cgColor
        selectLabel?.textColor = self.highlightTextColor
    }


}

extension InnTextView {
    @objc func backgroundViewTap() {
        self.textView.becomeFirstResponder()
          
        let length = self.textView.text.count
        var selectLabel:UILabel?
          
        if(length == 0)
        {
            selectLabel = backgroundView.viewWithTag(1000) as? UILabel
        }
        else
        {
            selectLabel = backgroundView.viewWithTag(1000 + length - 1) as? UILabel
        }
        
        selectLabel?.layer.borderColor = self.highlightBorderColor.cgColor
        selectLabel?.textColor = self.highlightTextColor
          
    }
}

extension InnTextView:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let length = textView.text.count
        
        
        if length == maxCount {
            self.textView.resignFirstResponder()
            self.textFinished?(textView.text)
            self.delegate?.textViewDidFinishedEdit?(codeStr: textView.text)
            
        }
       
        self.delegate?.textViewDidChangeEdit?(codeStr: textView.text)
        
        for i in 0 ..< maxCount
        {
            let showLabel = backgroundView.viewWithTag(1000+i) as? UILabel
            showLabel?.text = ""
            showLabel?.layer.borderColor = self.normalBorderColor.cgColor
            showLabel?.textColor = self.normalTextColor
        }
        
        
        let selectLabel =  self.backgroundView.viewWithTag(1000 + length) as? UILabel
        selectLabel?.layer.borderColor = self.highlightBorderColor.cgColor
        selectLabel?.textColor = self.highlightTextColor
        
        
        for i in 0 ..< length {
            let showLabel = backgroundView.viewWithTag(1000+i) as? UILabel
            let text = textView.text ?? ""
       
            if text.count > 0 {
                guard let range =  Range(NSRange(location: i, length: 1), in: text) else { return }
               
                let startIndex = range.upperBound
                let endIndex = range.lowerBound
                let subString = String(text[startIndex..<endIndex])
                showLabel?.text = subString
            }
        }
    }
}
