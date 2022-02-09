//
//  GPyyFilterBar.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import Foundation
import UIKit

class GPyymFilterBar: UIView {
    
    var collection: UICollectionView!
    var backBtnClickBlock: (()->Void)?
    var didSelectFilterItemBlock: ((_ filterItem: GCFilterItem?, _ isFilterPro: Bool) -> Void)?
    var currentSelectIndexPath : IndexPath?
    var originalImage: UIImage?
    var filterList: [GCFilterItem] = []

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        loadData()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
//        currentSelectIndexPath = nil
//        collection.selectItem(at: currentSelectIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

}

extension GPyymFilterBar {
    func loadData() {
        
        self.filterList = GPyyDataManager.default.filterList
        currentSelectIndexPath = IndexPath(item: 0, section: 0)
        //Array(GPyyDataManager.default.filterList.suffix(from: 1))
    }
    
    func setupView() {
        
//        let backBtn = UIButton()
//        backBtn.image("close_ic")
//            .adhere(toSuperview: self)
//        backBtn.snp.makeConstraints {
//            $0.left.equalTo(10)
//            $0.top.equalToSuperview()
//            $0.width.height.equalTo(40)
//        }
//        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
//        let saveBtn = UIButton()
//        saveBtn.image("edit_done_ic")
//            .adhere(toSuperview: self)
//        saveBtn.snp.makeConstraints {
//            $0.right.equalTo(-10)
//            $0.top.equalToSuperview()
//            $0.width.height.equalTo(40)
//        }
//        saveBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
//        let clearBtn = UIButton()
//        clearBtn.image("no_shape_ic")
//            .adhere(toSuperview: self)
//        clearBtn.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview()
//            $0.width.height.equalTo(40)
//        }
//        clearBtn.addTarget(self, action: #selector(clearBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview()
        }
        collection.register(cellWithClass: GCFilterCell.self)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func clearBtnClick(sender: UIButton) {
        currentSelectIndexPath = nil
        didSelectFilterItemBlock?(nil, false)
    }
     
    
}


extension GPyymFilterBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: GCFilterCell.self, for: indexPath)
        let item = filterList[indexPath.item]
        let image_o = originalImage ?? UIImage(named: "frame1_big")
        let filteredImg = GPyyDataManager.default.filterOriginalImage(image: image_o!, lookupImgNameStr: item.imageName)
        if item.filterName == "Original" {
            cell.contentImageView.image = UIImage(named: item.imageName) ?? image_o
        } else {
            cell.contentImageView.image = filteredImg //UIImage.named("\(item.filterName)")
        }
        cell.nameLabel.text = item.filterName
        
        if currentSelectIndexPath?.item == indexPath.item {
            cell.contentView.alpha = 1
        } else {
            cell.contentView.alpha = 0.5
        }
        
        if indexPath.item <= 1 {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        
        cell.contentView.layer.cornerRadius = 0
        cell.selectView.layer.cornerRadius = 0
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPyymFilterBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let width: CGFloat = 80
        let padding: CGFloat = 1
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width: CGFloat = 80
        let padding: CGFloat = 1
        return padding
    }
    
}

extension GPyymFilterBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item =
            filterList[indexPath.item]
        currentSelectIndexPath = indexPath
        var pro = false
        
        if indexPath.item <= 1 {
            pro = false
        } else {
            pro = true
        }
        didSelectFilterItemBlock?(item, pro)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}






class GCFilterCell: UICollectionViewCell {
    var contentImageView: UIImageView = UIImageView()
    let selectView: UIView = UIView()
    var vipImgV: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        contentView.layer.masksToBounds = true
        contentImageView.contentMode = .scaleAspectFill
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
//        selectView.isHidden = true
//        selectView.backgroundColor = .clear
//        selectView.layer.borderWidth = 1
//        selectView.layer.borderColor = UIColor(hexString: "#000000")?.cgColor
//        contentView.addSubview(selectView)
//        selectView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(0)
//            $0.bottom.equalToSuperview().offset(0)
//            $0.left.equalToSuperview().offset(0)
//            $0.right.equalToSuperview().offset(0)
//        }
        
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
        
        
        nameLabel.isHidden = true
        contentView.addSubview(nameLabel)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.backgroundColor = UIColor(hexString: "#373737")?.withAlphaComponent(0.7)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(hexString: "#FFFFFF")
        nameLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 8)
        nameLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                selectView.isHidden = false
//            } else {
//                selectView.isHidden = true
//            }
//        }
//    }
    
}
