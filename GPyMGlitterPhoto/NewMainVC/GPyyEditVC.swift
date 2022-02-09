//
//  GPyyEditVC.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

import UIKit
import DeviceKit
import GPUImage
import Photos

class GPyyEditVC: UIViewController {

    var originalImg: UIImage
    
    let topBanner = UIView()
    let contentBgV = UIView()
    let contentImgV = UIImageView()
    let overlayerImgV = UIImageView()
    let bottomBar = GPyyBottomBar()
    let toolBgV = UIView()
    var overlayerBar: GPyyBorderBar!
    let filterBar = GPyymFilterBar()
    let stickerBar = GPyyStickerBar()
    let textBar = GPyyTextBar()
    let unlockAlertView = GPyCoinalertV()
    
    var currentOverlayerItem: GPCyStickerItem?
    var currentSelectFilterItem: GCFilterItem?
    var isFilterPro: Bool = false
    
    var viewWillAppearOnce = Once()
    
    var isAddNewText: Bool = false
    
    
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewWillAppearOnce.run {
            var topOffset: CGFloat = 0
            var leftOffset: CGFloat = 0
            if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            
            }
            
            let width: CGFloat = UIScreen.main.bounds.width - (leftOffset * 2)
            let height: CGFloat = width
            
            topOffset = ((toolBgV.frame.minY - topBanner.frame.maxY) - height) / 2
            
            topOffset = topOffset/2 + topBanner.frame.maxY
            
            contentBgV.adhere(toSuperview: view)
            contentBgV.layer.masksToBounds = true
            contentBgV.frame = CGRect(x: leftOffset, y: topOffset, width: width, height: height)
             
            //
            contentImgV
                .image(originalImg)
                .contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            contentImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(contentBgV)
            }
            
            //
            overlayerImgV.contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            overlayerImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(contentBgV)
            }
            
            //
             
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(UIColor(hexString: "#2F2D2B")!)
        setupView()
        setupUnlockAlertView()
        setupContentView()
        setupActionBlock()
        setupDefaultSTatus()
        
        
        let aTapGR = UITapGestureRecognizer.init(target: self, action: #selector(editingHandlers))
        contentBgV.addGestureRecognizer(aTapGR)
        
    }
    
    @objc func editingHandlers() {
        GPpYymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
    
    func setupDefaultSTatus() {
        bottomBar.currentItem = bottomBar.list.first
        bottomBar.collection.reloadData()
        if let item = bottomBar.currentItem {
            showToolBar(item: item)
        }
        
    }
    
    func setupView() {
        
        
        topBanner.backgroundColor(.clear)
            .adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        //
        let backBtn = UIButton()
        backBtn.image(UIImage(named: "all_arrow_left"))
            .adhere(toSuperview: topBanner)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let saveBtn = UIButton()
        saveBtn.image(UIImage(named: "editor_download"))
            .adhere(toSuperview: topBanner)
        saveBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
     
        
        //

        bottomBar.adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        bottomBar.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showToolBar(item: item)
            GPpYymAddonManager.default.cancelCurrentAddonHilightStatus()
        }
        //
        
        toolBgV.adhere(toSuperview: view)
            .backgroundColor(.clear)
        toolBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(96)
        }
        
    }
    
    func setupContentView() {
        overlayerBar = GPyyBorderBar(frame: .zero, originImg: originalImg.reSizeImage(reSize: CGSize(width: 96 * 2, height: 96 * 2)))
        overlayerBar.adhere(toSuperview: toolBgV)
        overlayerBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        overlayerBar.clickBlock = {
            [weak self] item, isPro in
            guard let `self` = self else {return}
            self.currentOverlayerItem = item
            self.overlayerImgV.image(item.bigName)
        }
        
        //
    
        filterBar.originalImage = originalImg.scaled(toWidth: 150)
        filterBar.adhere(toSuperview: toolBgV)
        filterBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        filterBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.filterBar.isHidden = true
            }
        }
        
        filterBar.didSelectFilterItemBlock = {
            [weak self] filterItem, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
                self.isFilterPro = isPro
                self.changeFilter(item: filterItem)
            }
        }
        
        //
        
        stickerBar.adhere(toSuperview: toolBgV)
        stickerBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        stickerBar.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            if let img = UIImage(named: item.bigName ?? "") {
                GPpYymAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: img, stickerItem: item, atView: self.contentBgV)
            }

        }
        
        //
        
        textBar.adhere(toSuperview: toolBgV)
        textBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        textBar.addNewBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            let defaulTextStr = ""
            let defaultFont = UIFont(name: "AvenirNext-Medium", size: 40) ?? UIFont.systemFont(ofSize: 40)
            self.isAddNewText = true
            self.showTextInputViewStatus(contentString: defaulTextStr, font: defaultFont)
        }
        textBar.colorClickBlock = {
            [weak self] color, indexPath in
            guard let `self` = self else {return}
            let colorc = UIColor(hexString: color) ?? UIColor.white
//            GPpYymAddonManager.default.replaceSetupTextAddonTextColor(color: colorc, canvasView: self.contentBgV)
            GPpYymAddonManager.default.replaceSetupTextAddonTextColorName(colorName: color, colorIndexPath: indexPath, canvasView: self.contentBgV)
            
        }
        textBar.fontClickBlock = {
            [weak self] font, indexPath in
            guard let `self` = self else {return}
            GPpYymAddonManager.default.replaceSetupTextAddonFontItem(fontItem: font, fontIndexPath: indexPath, canvasView: self.contentBgV)
        }
        
        
    }
    
    func changeFilter(item: GCFilterItem?) {
        currentSelectFilterItem = item
        
        if let filterItem = item {
            if let filteredImg = GPyyDataManager.default.filterOriginalImage(image: self.originalImg, lookupImgNameStr: filterItem.imageName) {
                self.contentImgV.image = filteredImg
            }
        } else {
            self.contentImgV.image = originalImg
             
        }
    }
     
}

extension GPyyEditVC {
    func showToolBar(item: BottomBarItem) {
        for v in toolBgV.subviews {
            v.isHidden = true
        }
        if item.normalImgName == "editor_frame" {
            overlayerBar.isHidden = false
        } else if item.normalImgName == "editor_filter" {
            filterBar.isHidden = false
        } else if item.normalImgName == "editor_text" {
            textBar.isHidden = false
        } else if item.normalImgName == "editor_sticker" {
            stickerBar.isHidden = false
        }
        
    }
    
    
}


extension GPyyEditVC {
    @objc func backBtnClick(sender: UIButton) {
        GPpYymAddonManager.default.clearAddonManagerDefaultStatus()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        GPpYymAddonManager.default.cancelCurrentAddonHilightStatus()
        //
        var isPro: Bool = false
        if currentOverlayerItem?.isPro == true || isFilterPro == true {
            isPro = true
        }
        if isPro == false {
            for stickerV in GPpYymAddonManager.default.addonStickersList {
                if stickerV.stikerItem?.isPro == true {
                    isPro = true
                }
            }
        }
        if isPro == false {
            for textV in GPpYymAddonManager.default.addonTextsList {
                if textV.fontIndexPath.item > 1 {
                    isPro = true
                }
            }
        }
        
        
        if isPro {
            self.showUnlockunlockAlertView()
        } else {
            saveAction()
        }
        
    }
    
    func saveAction() {
        if let imgs = contentBgV.screenshot {
            self.saveImgsToAlbum(imgs: [imgs])
        }
        
    }
    
}

extension GPyyEditVC {
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        
        
        DispatchQueue.main.async {
            let title = ""
            let message = "Photo saved successfully!"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}

extension GPyyEditVC {
    
    func setupUnlockAlertView() {
        
        unlockAlertView.alpha = 0
        view.addSubview(unlockAlertView)
        unlockAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showUnlockunlockAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.unlockAlertView.alpha = 1
        }
        self.view.bringSubviewToFront(self.unlockAlertView)
        unlockAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if GPyymCoinManagr.default.coinCount >= GPyymCoinManagr.default.coinCostCount {
                DispatchQueue.main.async {
                     
                    GPyymCoinManagr.default.costCoin(coin: GPyymCoinManagr.default.coinCostCount)
                    DispatchQueue.main.async {
                        self.saveAction()
                        
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient Coins, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
//                            self.navigationController?.pushViewController(InCymInStoreVC(), animated: true)
                            self.present(GPySetoreVC(), animated: true, completion: nil)
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        
        unlockAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
    }
    
}

extension GPyyEditVC {
    func showTextInputViewStatus(contentString: String, font: UIFont) {
        let textinputVC = GPyyTextInputVC()
        self.addChild(textinputVC)
        view.addSubview(textinputVC.view)
        textinputVC.view.alpha = 0
        textinputVC.startEdit()
        if contentString == "" {
//            textinputVC.contentTextView.placeholder = "Halloween"
        } else {
            textinputVC.contentText = contentString
//            textinputVC.contentTextView.text = contentString
        }
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            textinputVC.view.alpha = 1
        }
        textinputVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        textinputVC.contentTextView.becomeFirstResponder()
        textinputVC.cancelClickActionBlock = {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            
            textinputVC.contentTextView.resignFirstResponder()
        }
        textinputVC.doneClickActionBlock = {
            [weak self] contentString, isAddNew in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            textinputVC.contentTextView.resignFirstResponder()
            GPpYymAddonManager.default.replaceSetupTextContentString(contentString: contentString, canvasView: self.contentBgV, isAddNewTextAddon: self.isAddNewText)
            
            
        }
    }
    
    func addNewfirstTextView() {
        
//        WCymAddonManager.default.replaceSetupTextAddonFontItem(fontItem: "AvenirNext-Medium", fontIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasBgV)
        
        GPpYymAddonManager.default.replaceSetupTextBgColor(bgColorName: "#00000000", indexPath: IndexPath(item: 0, section: 0), canvasView: self.contentBgV)
    }

    func setupActionBlock() {
          
        GPpYymAddonManager.default.removeStickerAddonActionBlock = { [weak self] in
            guard let `self` = self else {return}
            
            
        }
        
        GPpYymAddonManager.default.textAddonSingleClickStatusBlock = {
            [weak self] textV in
            guard let `self` = self else {return}
            self.textBar.fontBar.currentIndexPath = textV.fontIndexPath
            self.textBar.colorBar.currentColorS = textV.currentTextColorName
            self.textBar.fontBar.collection.reloadData()
            self.textBar.colorBar.collection.reloadData()
        }
        
        GPpYymAddonManager.default.textAddonReplaceBarStatusBlock = {
            [weak self] textV in
            guard let `self` = self else {return}
            self.textBar.fontBar.currentIndexPath = textV.fontIndexPath
            self.textBar.colorBar.currentColorS = textV.currentTextColorName
            self.textBar.fontBar.collection.reloadData()
            self.textBar.colorBar.collection.reloadData()
        }
        
        
        
        GPpYymAddonManager.default.doubleTapTextAddonActionBlock = { [weak self] contentString, font in
            guard let `self` = self else {return}
            
            let fontT = UIFont(name: font.fontName, size: 28 ) ?? UIFont.systemFont(ofSize: 28)
            self.isAddNewText = false
            self.showTextInputViewStatus(contentString: contentString, font: fontT)
            
        }
        
        
    }
    
}
