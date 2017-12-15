//
//  MQTabBarViewController.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

public class MQPresentVCInfo: NSObject {
    public static var mqPresentVCsDic:Dictionary<String,MQPresentVCInfo> = [:]
    public var className: String! = NSStringFromClass(UIViewController.self)
    public var barItem: MQTabbarItem! = nil
}

class MQTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        //
        self.addViewControllers()
        
    }

    fileprivate func addViewControllers() {
        self.mq_addChildViewController(FirstViewController(), fromPlistItemIndex: 0)
        self.mq_addChildViewController(SecondViewController(), fromPlistItemIndex: 1)
        self.mq_addChildViewController(ThreeViewController(), fromPlistItemIndex: 2)
        self.mq_addChildViewController(FourViewController(), fromPlistItemIndex: 3)
        self.mq_addChildViewController(FiveViewController(), fromPlistItemIndex: 4)
    }
    
    final public func mq_addChildViewController(_ controller:UIViewController!,fromPlistItemIndex index:Int) {
        let count = MQTabbarConfig.barItems.count
        if count > 0 ,index < count{
            self.mq_addChildrenViewController(controller, tabbarItem: MQTabbarConfig.barItems[index])
        }
    }
    
    final func mq_addChildrenViewController(_ controller: UIViewController, tabbarItem item: MQTabbarItem) {
        
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title
        
        if item.showAsPresent {//present
            let mInfo = MQPresentVCInfo.init()
            mInfo.className =  controller.mq_className
            //controller.classForCoder
            mInfo.barItem = item
            MQPresentVCInfo.mqPresentVCsDic["\((self.viewControllers?.count)!)"] = mInfo
            xxx_addChileViewController(UIViewController.init(), from: item)
        }else{
            if item.embedInNavigation,!controller.isKind(of: MQNavigationViewController.self) {
                let nav = MQNavigationViewController.init(rootViewController: controller)
                nav.tabBarItem.title = item.title
                self.addChildViewController(nav)
            }else{
                self.addChildViewController(controller)
            }
        }
    }
    
    final public func xxx_addChileViewController(_ controller:UIViewController!,from item:MQTabbarItem) {
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title
        
        self.addChildViewController(controller)
    }
    
    final func mq_tabBarController(_ tabBarController:UITabBarController,shouldSelectViewController viewController:UIViewController!) -> Bool {
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
                    if info.barItem.embedInNavigation,!vc.isKind(of: MQNavigationViewController.self) {
                        tabBarController.present(MQNavigationViewController.init(rootViewController: vc), animated: true, completion: nil)
                    }else{
                        tabBarController.present(vc, animated: true, completion: nil)
                    }
                    return false
                }
            }
        }
        return true;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MQTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return self.mq_tabBarController(tabBarController,shouldSelectViewController:viewController)
    }
}
