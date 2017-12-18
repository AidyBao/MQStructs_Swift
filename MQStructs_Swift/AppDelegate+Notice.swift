//
//  AppDelegate+Notice.swift
//  MQStructs
//
//  Created by AidyBao on 2017/11/9.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import UIKit
import UserNotifications
let UM_KEY_APPSTORE     =   "583e3b4307fe651cf1000088"
let UM_KEY_ENTERPRISE   =   "5872ec808f4a9d7485002122"

extension AppDelegate {
    func mq_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        var um_key = UM_KEY_APPSTORE //AppStore
        if Bundle.mq_bundleId == MQ.Package.enterpriseBundleId {
            um_key = UM_KEY_ENTERPRISE//Enterprise
        }
        
        UMessage.start(withAppkey: um_key, launchOptions: launchOptions)
        UMessage.setLogEnabled(false)
        
        //统计
        let config = UMAnalyticsConfig.sharedInstance()
        config?.appKey = um_key
        if Bundle.mq_bundleId == MQ.Package.enterpriseBundleId {
            config?.channelId = "Enterprise"
        }else{
            config?.channelId = "App Store"
        }
        MobClick.start(withConfigure: config)
    }

    
    func registRemoteNotification() {
        if #available(iOS 10.0, *){
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge,.alert,.sound], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    if !granted {
                        self.showNotAllowRemoteNoticeAlert()
                    }
                }
            })
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            isAllowRemoteNotification({ (allow) in
                if !allow {
                    self.showNotAllowRemoteNoticeAlert()
                }
            })
            let setting = UIUserNotificationSettings(types: [.sound,.alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func isAllowRemoteNotification(_ callBack:((_ allow:Bool) -> Void)?) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .authorized {
                        callBack?(true)
                    }else{
                        callBack?(false)
                    }
                }
            })
        } else {
            let setting = UIApplication.shared.currentUserNotificationSettings
            if setting?.types != .none {
                callBack?(true)
            }else{
                callBack?(false)
            }
        }
    }
    
    fileprivate func showNotAllowRemoteNoticeAlert() {
        if repeatNotice() {
            MQAlertUtils.showAlert(wihtTitle: nil, message: "您阻止了程序接受消息,可能会错过提醒消息哦!", buttonTexts: ["不在提示","去开启"], action: { (index) in
                if index == 0 {
                    UserDefaults.standard.set(1, forKey: "ZX_Not_Repeat_Notice")
                    UserDefaults.standard.synchronize()
                }else{
                    MQCommonUtils.openURL(UIApplicationOpenSettingsURLString)
                }
            })
        }
    }
    
    //ZX_Not_Show_Alert
    fileprivate func repeatNotice() -> Bool {
        if let num = UserDefaults.standard.object(forKey: "ZX_Not_Repeat_Notice") {
            if let num = num as? Int ,num == 1{
                return false
            }
        }
        return true
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        UserDefaults.standard.set(token, forKey: "deviceToken")
        UserDefaults.standard.synchronize()

    }
    
    //<=10
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        if let userInfo = userInfo as? Dictionary<String,Any>{
//            MQRouter.showNotice(userInfo)
        }
    }
    //处理程序未启动 - 需要开启BackgroundModes
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        if let userInfo = userInfo as? Dictionary<String,Any>{
//            MQRouter.showNotice(userInfo)
        }
    }
}

@available(iOS 10.0, *)
extension AppDelegate:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var userInfo = notification.request.content.userInfo as! Dictionary<String,Any>
        userInfo["fromUserTap"] = false
        if notification.request.trigger is UNPushNotificationTrigger {
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
//            MQRouter.showNotice(userInfo)
        }else{
            print("iOS10 接受本地通知:\(userInfo)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var userInfo = response.notification.request.content.userInfo as! Dictionary<String,Any>
        userInfo["fromUserTap"] = true
        if response.notification.request.trigger is UNPushNotificationTrigger {
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
//            MQRouter.showNotice(userInfo)
        }else{
            print("iOS10 接受本地通知:\(userInfo)")
        }
        completionHandler()  // 系统要求执行这个方法
    }
}

