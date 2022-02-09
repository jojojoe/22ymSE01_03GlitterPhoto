//
//  UIViewControllerExtension.swift
//  GPyyGliterPhoto
//
//  Created by GliterPhoto on 2022/1/14.
//  Copyright © 2022 Gliter. All rights reserved.
//

import UIKit

public extension UIViewController {
    var rootVC: UIViewController? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    }

    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }

    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }

    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }

    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }


        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        return viewController
    }

    func present(_ controller: UIViewController) {
        self.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true, completion: nil)
    }
    
    func pushVC(_ controller: UIViewController ,animate: Bool) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(controller, animated: animate)
        } else {
            present(controller, animated: animate, completion: nil)
        }
    }
    
    func popVC() {
        if let navigationController = self.navigationController {
            navigationController.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentDissolve(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: completion)
    }
    
    func presentFullScreen(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: completion)
    }
}
