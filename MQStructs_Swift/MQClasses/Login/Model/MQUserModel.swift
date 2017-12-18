//
//  MQUserModel.swift
//  MQStructs
//
//  Created by AidyBap on 2017/11/2.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

@objcMembers class MQUserModel: NSObject {
    fileprivate var uid:Int = -1
    fileprivate var token:String = ""
    
    var ageGroups: Int = -1
    var appVersion: String = ""
    var birthday: String = ""
    var birthdayStr: String = ""
    var channelId: String = ""
    var currentIntegral: String = ""
    var headPortraitFiles: String = ""
    var headPortraitFilesStr: String = ""
    var isNew: Int = -1
    var latitude: Float32 = 0
    var longitude: Float32 = 0
    var mobileModel: String = ""
    var mobileSystemType: String = ""
    var mobileSystemVersion: String = ""
    var name: String = ""
    var pushId: String = ""
    var qrCode: String = ""
    var qrStr: String = ""
    var regDate: String = ""
    var remark: String = ""
    var sex: Int = -1
    var sexStr: String = ""
    var socialSecurityNumber: String = ""
    var sourceType: Int = 0
    var status: Int = 0
    var tel: String = ""
    var uuid: String = ""
    var isRepeatedReminders: Int = -1
    var deviceToken: String = ""
    var isVoiceRemind: Int = -1
    var packageName: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["uid":"id"]
    }
    
    //id
    var memberId:String {
        get {
            if uid <= 0 {
                var random = arc4random() %  9999
                if random == 0 {
                    random = 1
                }
                return "-\(random)"
            }
            return "\(uid)"
        }
    }
    //token
    var userToken:String {
        get {
            if token.isEmpty {
                return NSUUID.init().uuidString
            }
            return token
        }
    }
    
    var isLogin: Bool {
        get {
            if self.valid,uid > 0 {
                return true
            }
            return false
        }
    }
    
    func save(_ dic:[String:Any]?) {
        if let dic = dic {
            var tempDic = dic
            
            //更新model
            let user = MQUserModel.mj_object(withKeyValues: tempDic)
            if let uid = tempDic["id"] as? Int {
                user?.uid = uid
            }
            if let token = tempDic["token"] as? String {
                user?.token = token
            }
            MQUser.mquser = user
            
            //保存数据
            let dic2 = user?.mj_keyValues()
            dic2?["id"] = tempDic["id"]
            dic2?["token"] = tempDic["token"]
            UserDefaults.standard.set(dic2, forKey: "MQUser")
            UserDefaults.standard.synchronize()
        }
    }
    
    func sync() {
        if MQUser.user.uid >= 0 {
            let dic2 = MQUser.user.mj_keyValues()
            dic2?["id"] = MQUser.mquser?.uid
            dic2?["token"] = MQUser.mquser?.token
            UserDefaults.standard.set(dic2, forKey: "MQUser")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() {
        if let dic = UserDefaults.standard.value(forKey: "MQUser") as? [String:Any] {
            MQUser.mquser = MQUserModel.mj_object(withKeyValues: dic)
            if let uid = dic["id"] as? Int {
                MQUser.user.uid = uid
            }
            if let token = dic["token"] as? String {
                MQUser.user.token = token
            }
        }
    }
    
    static var lastTel = "" //判断用户切换
    fileprivate var valid = true
    
    func invalid() {
        MQUserModel.lastTel = self.tel
        self.valid = false
    }
    
    func logout() {
        MQUser.mquser = nil
        UserDefaults.standard.removeObject(forKey: "MQUser")
        UserDefaults.standard.removeObject(forKey: "flashImgData")
        UserDefaults.standard.removeObject(forKey: "flashImgURL")
        UserDefaults.standard.synchronize()
    }
    
    func saveFlashImageURL(_ flashImgURL:String) {
        if flashImgURL.isEmpty == false {
            if let flashImgData: Data = try? Data.init(contentsOf: URL.init(string: flashImgURL)!) {
                let userDefault: UserDefaults = UserDefaults.standard
                userDefault.set(flashImgData, forKey: "flashImgData")
                userDefault.set(flashImgURL, forKey: "flashImgURL")
                userDefault.synchronize()
            }
        }else{
            let userDefault: UserDefaults = UserDefaults.standard
            userDefault.removeObject(forKey: "flashImgData")
            userDefault.removeObject(forKey: "flashImgURL")
        }
    }
    
    func getFlashImage() -> UIImage? {
        if let flashImageData = UserDefaults.standard.object(forKey: "flashImgData") {
            let flashImage: UIImage = UIImage.init(data: flashImageData as! Data)!
            return flashImage
        }
        return nil
    }
    
    func getFlashImageURL() -> String {
        if let url = UserDefaults.standard.object(
            forKey: "flashImgURL") {
            return url as! String
        }
        return ""
    }
}

class MQUser: NSObject {
    fileprivate static var mquser:MQUserModel?
    static var user:MQUserModel {
        get {
            if let _user = mquser {
                return _user
            } else {
                mquser = MQUserModel()
            }
            return mquser!
        }
    }
}

