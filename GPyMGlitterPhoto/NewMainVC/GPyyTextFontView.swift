//
//  GPyyTextFontView.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import UIKit


class GPyyTextFontView: UIView {
    
    var collection: UICollectionView!
    var currentFontStr: String?
    var currentIndexPath: IndexPath?
    var fontDidSelectBlock: ((String, IndexPath)->Void)?
    var addNewBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().offset(64)
        }
        collection.register(cellWithClass: GCgymFontCell.self)
        
        //
        
        let addNewBtn = UIButton()
        addNewBtn.image(UIImage(named: "editor_plus"))
            .adhere(toSuperview: self)
        addNewBtn.addTarget(self, action: #selector(addNewBtnClick(sender: )), for: .touchUpInside)
        addNewBtn.snp.makeConstraints {
            $0.centerY.equalTo(collection.snp.centerY)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
    }
    
    @objc func addNewBtnClick(sender: UIButton) {
        
        addNewBtnClickBlock?()
    }
    
}

extension GPyyTextFontView: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withClass: GCgymFontCell.self, for: indexPath)
       let font =  GPyyDataManager.default.textFontList[indexPath.item]
       cell.layer.cornerRadius = 4
       cell.layer.masksToBounds = true
       cell.fontLabel.fontName(24, font)
          
       if currentIndexPath?.item == indexPath.item {
           cell.fontLabel.textColor = UIColor(hexString: "#FFAD59")
       } else {
           cell.fontLabel.textColor = UIColor(hexString: "#988B7F")
       }
       
       if indexPath.item <= 1 {
           cell.vipImageV.isHidden = true
       } else {
           cell.vipImageV.isHidden = false
       }
       return cell
   }
   
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return GPyyDataManager.default.textFontList.count
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
   }
   
}

extension GPyyTextFontView: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 76, height: 48)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 10)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 2
   }
   
}

extension GPyyTextFontView: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item = GPyyDataManager.default.textFontList[indexPath.item]
       fontDidSelectBlock?(item, indexPath)
       currentFontStr = item
       currentIndexPath = indexPath
       collectionView.reloadData()
   }
   
   func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
   }
}


class GCgymFontCell: UICollectionViewCell {
   let fontLabel = UILabel()
   let vipImageV = UIImageView()
   override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   func setupView() {
       
       //
       fontLabel
           .textAlignment(.center)
           .text("Font")
           .adjustsFontSizeToFitWidth()
           .color(UIColor(hexString: "#000000")!)
           .adhere(toSuperview: contentView)
       fontLabel.snp.makeConstraints {
           $0.left.right.equalToSuperview()
           $0.centerY.equalToSuperview()
           $0.height.equalTo(40)
       }
       //
        vipImageV
            .image("editor_diamond")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        vipImageV.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(16)
        }
//
       
   }
}


