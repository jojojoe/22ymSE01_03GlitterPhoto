//
//  GPyyStickerBar.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import Foundation
import UIKit


class GPyyStickerBar: UIView {
    
    var collection: UICollectionView!
    var currentItem: GPCyStickerItem?
    var clickBlock: ((GPCyStickerItem)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
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
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: GPyyStickerCell.self)
    }
    
    
    
    
    
}

extension GPyyStickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GPyyStickerCell.self, for: indexPath)
        let item = GPyyDataManager.default.stickerList[indexPath.item]
        cell.contentImgV.image(item.thumbName)
        
        
//        if currentItem?.thumbName == item.thumbName {
//            cell.selectImgV.isHidden = false
//        } else {
//            cell.selectImgV.isHidden = true
//        }
        
        if indexPath.item <= 1 {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GPyyDataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPyyStickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension GPyyStickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = GPyyDataManager.default.stickerList[indexPath.item]
        currentItem = item
        collectionView.reloadData()
        clickBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class GPyyStickerCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectImgV = UIImageView()
    
    let vipImgV = UIImageView()
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
            $0.center.equalToSuperview()
            $0.top.left.equalToSuperview().offset(8)
        }
        
        //
//        selectImgV.contentMode = .scaleAspectFill
//        selectImgV.clipsToBounds = true
//        selectImgV.image("editor_selected")
//        contentView.addSubview(selectImgV)
//        selectImgV.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.top.left.equalToSuperview().offset(0)
//        }
        
        //
        vipImgV.contentMode = .scaleAspectFit
        vipImgV.clipsToBounds = true
        vipImgV.image("editor_diamond")
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.width.height.equalTo(16)
        }
        
        
    }
}
