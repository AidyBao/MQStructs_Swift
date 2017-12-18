//
//  MQRootRouter.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/17.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import UIKit

class MQRootController: NSObject {
    
    private static var xxxTabbarVC:UITabBarController?
    class func mq_tabbarVC() -> UITabBarController! {
        guard let tabbarvc = xxxTabbarVC else {
            xxxTabbarVC = UITabBarController()
            xxxTabbarVC?.tabBar.layer.shadowColor = UIColor.mq_colorWithHexString("4f8ee5").cgColor
            xxxTabbarVC?.tabBar.layer.shadowRadius = 3
            xxxTabbarVC?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
            xxxTabbarVC?.tabBar.layer.shadowOpacity = 0.3
            return xxxTabbarVC!
        }
        return tabbarvc
    }
    
    class func selectedNav() -> UINavigationController {
        var nav = self.mq_tabbarVC().selectedViewController as! UINavigationController
        if let presentedvc = nav.presentedViewController as? UINavigationController {
            nav = presentedvc
        }
        return nav
    }
    
    static func mq_nav(at index:Int) -> UINavigationController {
        return self.mq_tabbarVC().viewControllers![index] as! UINavigationController
    }
    
    static func topVC() -> UIViewController {
        var topVC = self.mq_tabbarVC().selectedViewController!
        while topVC.presentedViewController != nil {
            topVC = topVC.presentedViewController!
        }
        return topVC

    }
    
    /// 初始化VC
    
    class func mqReload() {
        xxxTabbarVC = nil
        let tabbarvc = self.mq_tabbarVC()
        tabbarvc?.mq_addChildViewController(FirstViewController(), fromPlistItemIndex: 0)
        tabbarvc?.mq_addChildViewController(SecondViewController(), fromPlistItemIndex: 1)
        tabbarvc?.mq_addChildViewController(ThreeViewController(), fromPlistItemIndex: 2)
        tabbarvc?.mq_addChildViewController(FourViewController(), fromPlistItemIndex: 3)
        tabbarvc?.mq_addChildViewController(FiveViewController(), fromPlistItemIndex: 4)
//        tabbarvc?.(FirstViewController(), fromPlistItemIndex: 0)
//        tabbarvc?.addChildViewController(SecondViewController(), fromPlistItemIndex: 1)
//        tabbarvc?.addChildViewController(ThreeViewController(), fromPlistItemIndex: 2)
//        tabbarvc?.addChildViewController(FourViewController(), fromPlistItemIndex: 3)
//        tabbarvc?.addChildViewController(FiveViewController(), fromPlistItemIndex: 4)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            tabbarvc?.delegate = appDelegate
        }
    }
    
    class func appWindow() -> UIWindow? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.window
        }
        return self.topVC().view.window
    }
}

extension UINavigationController {
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
        //self.topViewController
    }
    
    override open var childViewControllerForStatusBarHidden: UIViewController? {
        return visibleViewController
    }
}
