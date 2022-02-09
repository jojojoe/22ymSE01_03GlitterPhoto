//
//  GPyMainVCm.swift
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/14.
//

import UIKit
import SnapKit
import DeviceKit
import Photos
import YPImagePicker

class GPyMainVCm: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        AFlyerLibManage.event_LaunchApp()
        setupView()
        
    }
    
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#403429")!)
        //
        let bgImgV = UIImageView()
        bgImgV.image("homepage_bg_x")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 6.9 {
            bgImgV.image("homepage_bg")
        }
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let iconImgV = UIImageView()
        iconImgV.image("homepage_img")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        iconImgV.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-168)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(612 / 2)
            $0.height.equalTo(168 / 2)
        }
        
        //
        let playBtn = UIButton()
        playBtn.backgroundImage(UIImage(named: "mainPlay"))
            .title("Play", .normal)
            .titleColor(UIColor(hexString: "#2E2926")!)
            .font(24, "Baskerville-SemiBold")
            .adhere(toSuperview: view)
        playBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-66)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(128)
            $0.height.equalTo(64)
        }
        playBtn.addTarget(self, action: #selector(playBtnClick(sender: )), for: .touchUpInside)
        
        //
        let storeBtn = UIButton()
        storeBtn.backgroundImage(UIImage(named: "homepage_store"))
            .adhere(toSuperview: view)
        storeBtn.snp.makeConstraints {
            $0.centerY.equalTo(playBtn.snp.centerY)
            $0.right.equalTo(playBtn.snp.left).offset(-32)
            $0.width.equalTo(48)
            $0.height.equalTo(48)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender: )), for: .touchUpInside)
        
        //
        let settingBtn = UIButton()
        settingBtn.backgroundImage(UIImage(named: "homepage_setting"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.centerY.equalTo(playBtn.snp.centerY)
            $0.left.equalTo(playBtn.snp.right).offset(32)
            $0.width.equalTo(48)
            $0.height.equalTo(48)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        
        
    }
    
    
}

extension GPyMainVCm {
    @objc func playBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    @objc func settingBtnClick(sender: UIButton) {
        showSettingVC()
    }
    @objc func storeBtnClick(sender: UIButton) {
        self.present(GPySetoreVC(), animated: true, completion: nil)
        
    }
}

extension GPyMainVCm {
    func showSettingVC() {
        let settingVC = GPySettingVC()
        self.addChild(settingVC)
        view.addSubview(settingVC.view)
        settingVC.view.alpha = 0
         
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            settingVC.view.alpha = 1
        }
        settingVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        settingVC.cancelClickActionBlock = {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                settingVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    settingVC.removeViewAndControllerFromParentViewController()
                }
            }
        }
    }
}



extension GPyMainVCm: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
//                            self.presentPhotoPickerController()
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
//                                self.presentPhotoPickerController()
                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor(UIColor.white)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let vc = GPyyEditVC(originalImg: image)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}





