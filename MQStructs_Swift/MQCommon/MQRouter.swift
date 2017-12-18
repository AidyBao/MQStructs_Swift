//
//  MQRouter.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/7.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import UIKit

class MQRouter: NSObject {
    class func changeRootViewController(_ rootVC:UIViewController!){
        MQRootController.appWindow()?.rootViewController = rootVC
    }
    
    class func tabbarSelect(at index:Int) {
        if let tabbar = MQRootController.mq_tabbarVC() {
            tabbar.selectedIndex = index
        }
    }
    
    class func tabbarShouldSelected(at index:Int) {
        if let tabbar = MQRootController.mq_tabbarVC(),tabbar.delegate != nil {
            guard let controller = tabbar.viewControllers?[index] else {
                return
            }
            let _ = tabbar.delegate?.tabBarController!(tabbar, shouldSelect: controller)
        }
    }
    
    static func mq_backToHomePage() {
        MQRouter.tabbarSelect(at: 0)
        MQRootController.mq_nav(at: 1).popToRootViewController(animated: true)
        MQRootController.mq_nav(at: 2).popToRootViewController(animated: true)
        MQRootController.mq_nav(at: 3).popToRootViewController(animated: true)
    }
}
