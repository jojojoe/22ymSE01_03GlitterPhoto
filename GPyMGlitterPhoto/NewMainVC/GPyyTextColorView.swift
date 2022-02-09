//
//  GPyyTextColorView.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import UIKit


class GPyyTextColorView: UIView {

    //
    var collection: UICollectionView!
    
    var borderColorList: [String] = []
    var colorDidSelectBlock: ((String, IndexPath)->Void)?
    var currentColorS: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderColorList = GPyyDataManager.default.iconColorList
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        
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
            $0.right.left.equalToSuperview()
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
        }
        collection.register(cellWithClass: MSmsyColorCell.self)
        
    }
    

}


extension GPyyTextColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MSmsyColorCell.self, for: indexPath)
        let colorS = borderColorList[indexPath.item]
        
        
        
        
        if colorS.contains("#") {
            cell.contentImgV.image = UIImage(named: "lamb_love_color_img")?.withRenderingMode(.alwaysTemplate)
            cell.contentImgV.backgroundColor(UIColor(hexString: colorS) ?? UIColor.clear)
            cell.contentImgV.layer.cornerRadius = 32/2
//            cell.contentImgV.backgroundColor(UIColor(hexString: colorS) ?? UIColor.clear)
        } else {
            cell.contentImgV.backgroundColor(.clear)
            cell.contentImgV.image(colorS)
        }
        //
//        if colorS.contains("FFFFFF") {
//            cell.contentImgV.layer.borderWidth = 1
//            cell.contentImgV.layer.borderColor = UIColor.lightGray.cgColor
//        } else {
//            cell.contentImgV.layer.borderWidth = 0
//        }
        //
        if currentColorS == colorS {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return borderColorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPyyTextColorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension GPyyTextColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorS = borderColorList[indexPath.item]
        colorDidSelectBlock?(colorS, indexPath)
        
        //
        currentColorS = colorS
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class MSmsyColorCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        //
        
        selectV
            .image("editor_selected")
            .adhere(toSuperview: contentView)
        selectV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }
}

