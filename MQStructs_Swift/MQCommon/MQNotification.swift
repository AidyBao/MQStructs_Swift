//
//  MQNotification.swift
//  ZXStructs
//
//  Created by AidyBao on 2017/7/12.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import Foundation

class MQNotification {
    struct Login {
        static let invalid          =   "MQNOTICE_LOGIN_OFFLINE"                //登录失效通知
        static let success          =   "MQNOTICE_LOGIN_SUCCESS"                //登录成功
        static let accountChanged   =   "MQNOTICE_LOGIN_ACCOUNT_CHANGED"        //用户已切换
    }
    
    struct UI {
        static let reload           =   "MQNOTICE_RELOAD_UI"
        static let badgeReload      =   "MQNOTICE_RELOAD_BADGE"
        static let enterForeground  =   "MQNOTICE_ENTERFOREGROUND"
    }
    
    struct BMap {
        static let isOpenLocation   =   "MQNOTICE_BMap_IsOpenLoaction"
    }

}


extension NotificationCenter {
    struct mqpost {
        
        /// 判断定位是否开启
        static func judgementLocationStatus(_ isOpen: Bool) {
            NotificationCenter.default.post(name:MQNotification.BMap.isOpenLocation.mq_noticeName(), object: isOpen)
        }
        
        static func accountChanged() {
            NotificationCenter.default.post(name: MQNotification.Login.accountChanged.mq_noticeName(), object: nil)
        }
        
        static func loginSuccess() {
            NotificationCenter.default.post(name: MQNotification.Login.success.mq_noticeName(), object: nil)
        }
        
        static func loginInvalid() {
            NotificationCenter.default.post(name: MQNotification.Login.invalid.mq_noticeName(), object: nil)
        }
        
        static func reloadUI() {
            NotificationCenter.default.post(name: MQNotification.UI.reload.mq_noticeName(), object: nil)
        }
        
        static func reloadBadge() {
            NotificationCenter.default.post(name: MQNotification.UI.badgeReload.mq_noticeName(), object: nil)
        }
    }
}
