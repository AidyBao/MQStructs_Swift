//
//  UITabbarController+MQ.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/6.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import UIKit


class MQ_XXNavigationController: UINavigationController {
    //override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    //    viewController.mq_clearNavbarBackButtonTitle()
    //    super.pushViewController(viewController, animated: animated)
    //}
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for (idx,vc) in viewControllers.enumerated() {
            if idx != 0 {
                vc.mq_clearNavbarBackButtonTitle()
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
}

class MQPresentVCInfo: NSObject {
    static var mqPresentVCsDic:Dictionary<String,MQPresentVCInfo> = [:]
    var className: String! = NSStringFromClass(UIViewController.self)
    var barItem: MQTabbarItem! = nil
}

extension UITabBarController {
    
    final func mq_addChildViewController(_ controller:UIViewController!,fromItem item:MQTabbarItem) {
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title
        
        
        if item.showAsPresent {
            let mInfo = MQPresentVCInfo.init()
            mInfo.className =  controller.mq_className
            //controller.classForCoder
            mInfo.barItem = item
            MQPresentVCInfo.mqPresentVCsDic["\((self.viewControllers?.count)!)"] = mInfo
            xxx_addChileViewController(UIViewController.init(), from: item)
        }else{
            if item.embedInNavigation,!controller.isKind(of: UINavigationController.self) {
                let nav = MQ_XXNavigationController.init(rootViewController: controller)
                nav.tabBarItem.title = item.title
                self.addChildViewController(nav)
            }else{
                self.addChildViewController(controller)
            }
        }
    }
    
    final func mq_addChildViewController(_ controller:UIViewController!,fromPlistItemIndex index:Int) {
        let count = MQTabbarConfig.barItems.count
        if count > 0 ,index < count{
            mq_addChildViewController(controller, fromItem: MQTabbarConfig.barItems[index])
        }
    }
    
    final func xxx_addChileViewController(_ controller:UIViewController!,from item:MQTabbarItem) {
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title
        
        self.addChildViewController(controller)
    }
    
    final class func mq_tabBarController(_ tabBarController:UITabBarController,shouldSelectViewController viewController:UIViewController!) -> Bool {
        var sIndex = -1
        if let viewcontrollers = tabBarController.viewControllers {
            for (index,value) in viewcontrollers.enumerated() {
                if value == viewController {
                    sIndex = index
                    break
                }
            }
        }
        if sIndex != -1 {
            guard let info = MQPresentVCInfo.mqPresentVCsDic["\(sIndex)"]  else {
                return true
            }
            if info.barItem.showAsPresent {
                var vcClass = NSClassFromString(info.className) as? UIViewController.Type
                if vcClass == nil {
                    let className = Bundle.mq_projectName + "." + info.className
                    vcClass = NSClassFromString(className) as? UIViewController.Type
                }
                if let vcClass = vcClass {
                    let vc = vcClass.init()
                    if info.barItem.embedInNavigation,!vc.isKind(of: UINavigationController.self) {
                        tabBarController.present(MQ_XXNavigationController.init(rootViewController: vc), animated: true, completion: nil)
                    }else{
                        tabBarController.present(vc, animated: true, completion: nil)
                    }
                    return false
                }
            }
        }
        return true;
    }
}
