//
//  GPyyBorderBar.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import Foundation
import UIKit


class GPyyBorderBar: UIView {
    
    var collection: UICollectionView!
    var originImg: UIImage
    var currentItem: GPCyStickerItem?
    var clickBlock: ((GPCyStickerItem, Bool)->Void)?
    
    
    init(frame: CGRect, originImg: UIImage) {
        self.originImg = originImg
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        currentItem = GPyyDataManager.default.borderList.first
        
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
        collection.register(cellWithClass: GPyyBorderCell.self)
    }
    
    
    
    
    
}

extension GPyyBorderBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GPyyBorderCell.self, for: indexPath)
        let item = GPyyDataManager.default.borderList[indexPath.item]
        cell.contentImgV.image = originImg
        cell.overlayerImgV.image(item.thumbName)
        
        if currentItem?.thumbName == item.thumbName {
            cell.contentImgV.alpha = 1
            cell.overlayerImgV.alpha = 1
        } else {
            cell.contentImgV.alpha = 0.5
            cell.overlayerImgV.alpha = 0.5
        }
        
        if indexPath.item <= 1 {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GPyyDataManager.default.borderList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPyyBorderBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 96)
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

extension GPyyBorderBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pro = false
        
        if indexPath.item <= 1 {
            pro = false
        } else {
            pro = true
        }
        let item = GPyyDataManager.default.borderList[indexPath.item]
        currentItem = item
        collectionView.reloadData()
        clickBlock?(item, pro)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class GPyyBorderCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let overlayerImgV = UIImageView()
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
            $0.top.left.equalToSuperview()
        }
        
        //
        overlayerImgV.contentMode = .scaleAspectFill
        overlayerImgV.clipsToBounds = true
        contentView.addSubview(overlayerImgV)
        overlayerImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.left.equalToSuperview()
        }
        
        //
        vipImgV.contentMode = .scaleAspectFit
        vipImgV.image("editor_diamond")
        vipImgV.clipsToBounds = true
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-4)
            $0.width.height.equalTo(16)
        }
        
        
    }
}
