//
//  AppDelegate+Login.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/12/18.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

extension AppDelegate {
    func mq_addNotice() {
        NotificationCenter.default.addObserver(self, selector: #selector(mq_loginInvalidAction), name: MQNotification.Login.invalid.mq_noticeName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mq_loginSuccess), name: MQNotification.Login.success.mq_noticeName(), object: nil)
    }
    
    @objc func mq_loginInvalidAction() {
        if !isProcessed {
            return
        }
        isProcessed = false
        MQUser.user.invalid()
        MQAlertUtils.showAlert(wihtTitle: nil, message: "登录已失效,请重新登录", buttonText: nil) {
            self.isProcessed = true;
            MQRootController.mqReload()
//            MQRouter.changeRootViewController(UINavigationController.init(rootViewController: MQLoginRootViewController()))
        }
    }
    
    @objc func mq_loginSuccess() {
        isProcessed = true
    }
    
    func checkRemoteNoticeStatus() {
        self.isAllowRemoteNotification { (success) in
//            NotificationCenter.mqpost.openNotice(success)
        }
    }
}
