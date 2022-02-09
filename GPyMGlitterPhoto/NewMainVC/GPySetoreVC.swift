//
//  GPySetoreVC.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/14.
//

import UIKit
import NoticeObserveKit
import ZKProgressHUD

class GPySetoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    let backBtn = UIButton(type: .custom)
    var topBanner: UIView = UIView()
//    let collectionTopV = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addNotificationObserver()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = ( "\(GPyymCoinManagr.default.coinCount)")
            }
        }
        .invalidated(by: pool)
        
    }

}

extension GPySetoreVC {
    func setupView() {
        view
            .backgroundColor(UIColor(hexString: "#FFFFFF")!)
        view.clipsToBounds()
  
        let topBanner = UIView()
        topBanner
            .backgroundColor(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
        }
        
        //
//        let topTitleLabel = UILabel()
//        topTitleLabel
//            .fontName(16, "Comfortaa")
//            .color(UIColor(hexString: "#000000")!)
//            .text("Store")
//            .adhere(toSuperview: topBanner)
//        topTitleLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(backBtn.snp.centerY)
//            $0.width.height.greaterThanOrEqualTo(1)
//        }
        
        //
        
//        collectionTopV.backgroundColor(UIColor(hexString: "#FAD39B")!)
            
        
        //
        let coinBgV = UIView()
        coinBgV.backgroundColor(UIColor(hexString: "#F1EFEC")!)
            .adhere(toSuperview: view)
        
        
        
        //
        topCoinLabel
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#000000")!)
            .adhere(toSuperview: view)
        topCoinLabel.text = ( "\(GPyymCoinManagr.default.coinCount)")
        topCoinLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(64)
        }
        
        //
        let topCoinImgV = UIImageView()
        topCoinImgV
            .image("store_diamond_small")
            .adhere(toSuperview: view)
        topCoinImgV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel.snp.centerY)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-5)
            $0.width.height.greaterThanOrEqualTo(24)
        }
        
        
        coinBgV.snp.makeConstraints {
            $0.right.equalTo(topCoinLabel.snp.right).offset(16)
            $0.left.equalTo(topCoinImgV.snp.left).offset(-16)
            $0.centerY.equalTo(topCoinLabel.snp.centerY)
            $0.height.equalTo(40)
            
        }
        coinBgV.layer.cornerRadius = 20
        coinBgV.layer.masksToBounds = true
        
        //
        
        backBtn
            .image(UIImage(named: "all_close"))
            .adhere(toSuperview: topBanner)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        //
        let titleeLabel = UILabel()
        titleeLabel
            .fontName(28, "Baskerville-Bold")
            .color(UIColor(hexString: "#000000")!)
            .adhere(toSuperview: view)
        titleeLabel.text("Store")
        titleeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalTo(topCoinLabel.snp.centerY)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(64)
        }
        
        //
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleeLabel.snp.bottom).offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: GPyoymStoreCell.self)
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        //
//        collectionTopV
//            .adhere(toSuperview: collection)
//        collectionTopV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220)
        
        //
        let bottomM = UIView()
        bottomM
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomM.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(collection.snp.bottom)
        }
        
//        collection.addSubview(collectionTopV)
//        collectionTopV.snp.makeConstraints {
//            $0.width
//        }
        
    }
    
}

extension GPySetoreVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
     
    @objc func topCoinBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(GPySetoreVC(), animated: true)
    }
}



extension GPySetoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GPyoymStoreCell.self, for: indexPath)
        
        let item = GPyymCoinManagr.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin)"
        if let localPrice = item.localPrice {
            cell.priceLabel.text = item.localPrice
        } else {
            cell.priceLabel.text = "$\(item.price)"
//            let str = "$\(item.price)"
//            let att = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont(name: "MarkerFelt-Wide", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
//            let ran1 = str.range(of: "$")
//            let ran1n = "".nsRange(from: ran1!)
//            att.addAttributes([NSAttributedString.Key.font : UIFont(name: "MarkerFelt-Wide", size: 32) ?? UIFont.systemFont(ofSize: 16)], range: ran1n)
//            cell.priceLabel.attributedText = att
            
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GPyymCoinManagr.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GPySetoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let cellwidth: CGFloat = 156
        let cellHeight: CGFloat = 188
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellwidth: CGFloat = 156
        let left: CGFloat = (UIScreen.main.bounds.width - cellwidth * 2 - 1) / 3
        
        
        return UIEdgeInsets(top: 20, left: left, bottom: 50, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellwidth: CGFloat = 156
        let left: CGFloat = (UIScreen.main.bounds.width - cellwidth * 2 - 1) / 3
        return left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let cellwidth: CGFloat = 156
        let left: CGFloat = (UIScreen.main.bounds.width - cellwidth * 2 - 1) / 3
        return left
    }
    
//    referenceSizeForHeaderInSection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
//        return CGSize(width: UIScreen.width, height: 220)
        return CGSize(width: UIScreen.width, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath)
            
            return view
        }
        return UICollectionReusableView()
    }
    
}

extension GPySetoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = GPyymCoinManagr.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func selectCoinItem(item: GPInCyStoreItem) {
        // core
        
        GPmyPurchaseManagerLink.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                ZKProgressHUD.showSuccess("Purchase successful.")
            } else {
                ZKProgressHUD.showError("Purchase failed.")
            }
        }
        //
         
    }
    
}

class GPyoymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var iconImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor =  UIColor.white
//        let bgImgV = UIImageView()
//        bgImgV.image("store_coins_bg")
//            .adhere(toSuperview: contentView)
//        bgImgV.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "#ADB8D9")?.cgColor
        
         
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel
            .color(UIColor(hexString: "#000000")!)
            .numberOfLines(1)
            .fontName(18, "Avenir-Medium")
            .textAlignment(.center)
            .adhere(toSuperview: contentView)
        coinCountLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.bottom.equalTo(contentView.snp.centerY).offset(8)
            $0.width.height.greaterThanOrEqualTo(24)
        }
        
        //
        iconImageV.backgroundColor = .clear
        iconImageV.contentMode = .scaleAspectFit
        iconImageV.image = UIImage(named: "store_diamond")
        contentView.addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.bottom.equalTo(coinCountLabel.snp.top).offset(-6)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        
        let priceBgV = UIView()
        priceBgV
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: contentView)
        priceBgV.layer.cornerRadius = 24
        //
        priceBgImgV.image("mainPlay")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: priceBgV)
        priceBgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(priceBgV)
        }
        //
        priceLabel.textColor = UIColor(hexString: "#2E2926")
        priceLabel.font = UIFont(name: "Baskerville-SemiBold", size: 20)
        priceLabel.textAlignment = .center
        contentView.addSubview(priceLabel)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(coinCountLabel.snp.bottom).offset(21)
            $0.height.equalTo(48)
            $0.width.greaterThanOrEqualTo(50)
        }
        
        priceBgV.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.top).offset(0)
            $0.left.equalTo(priceLabel.snp.left).offset(-24)
            $0.bottom.equalTo(priceLabel.snp.bottom).offset(0)
            $0.right.equalTo(priceLabel.snp.right).offset(24)
        }
        
        
        
    }
     
}




