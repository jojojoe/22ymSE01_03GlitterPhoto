//
//  GPyyBottomBar.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import UIKit


struct BottomBarItem {
    var normalImgName: String
    var selectImgName: String
}

class GPyyBottomBar: UIView {

    var clickBlock: ((BottomBarItem)->Void)?
    
    var list: [BottomBarItem] = []
    var currentItem: BottomBarItem?
    var collection: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func loadData() {
        let item1 = BottomBarItem(normalImgName: "editor_frame", selectImgName: "editor_frame_selected")
        let item2 = BottomBarItem(normalImgName: "editor_filter", selectImgName: "editor_filter_selected")
        let item3 = BottomBarItem(normalImgName: "editor_text", selectImgName: "editor_text_selected")
        let item4 = BottomBarItem(normalImgName: "editor_sticker", selectImgName: "editor_sticker_selected")
        list = [item1, item2, item3, item4]
    }
    
    
}

extension GPyyBottomBar {
    func setupView() {
        backgroundColor(UIColor(hexString: "#2F2D2B")!)
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
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: GPyyBottomCell.self)
        
        
    }
    
    
    
}

extension GPyyBottomBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GPyyBottomCell.self, for: indexPath)
        let item = list[indexPath.item]
        if currentItem?.normalImgName == item.normalImgName {
            cell.contentImgV.image(item.selectImgName)
        } else {
            cell.contentImgV.image(item.normalImgName)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPyyBottomBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.width - 80 * 2 - 44 * 4) / 3
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.width - 80 * 2 - 44 * 4) / 3
        return padding
    }
    
}

extension GPyyBottomBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        currentItem = item
        collectionView.reloadData()
        clickBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GPyyBottomCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        
    }
}
