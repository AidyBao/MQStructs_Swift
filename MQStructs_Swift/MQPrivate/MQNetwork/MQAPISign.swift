//
//  MQAPISIgn.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/12.
//  Copyright © 2017年 MQ. All rights reserved.
//

import Foundation

let MQAPI_SIGN_KEY  = "reson"

extension Dictionary {
    //With Base64Encode
    func mq_signDicWithEncode(_ insertMemberInfo:Bool = true) -> Dictionary<String,Any> {
        var tempDic = self as! Dictionary<String,Any>
        var token = MQUser.user.userToken
        if let _token = tempDic["token"] as? String {
            token = _token
            tempDic.removeValue(forKey: "token")
        }
        var tempDic2:Dictionary<String,String> = [:]
        for key in tempDic.keys {
            let value = "\(tempDic[key] ?? "")"
            if value.count > 0 {
                tempDic2[key] = value.mq_base64Encode()
            } else {
                tempDic2[key] = value
            }
        }
        if insertMemberInfo {
            tempDic2["memberId"] = MQUser.user.memberId.mq_base64Encode()
        }
        
        var signString = tempDic2.mq_sortJsonString()
        signString += MQAPI_SIGN_KEY
        signString += token
        tempDic2["sign"] = signString.mq_md5String().mq_base64Encode()
        tempDic2["token"] = token.mq_base64Encode()
        
        return tempDic2
    }
    
    /// 签名-未编码
    ///
    func mq_signDic(_ insertMemberInfo: Bool = true) -> Dictionary<String,Any> {
        var tempDic = self as! Dictionary<String,Any>
        var token:String? = MQUser.user.userToken
        let memberId = MQUser.user.memberId
        if let _token = tempDic["token"] as? String {
            token = _token
            tempDic.removeValue(forKey: "token")
        }
        
        if insertMemberInfo {
            tempDic["memberId"] = memberId
        }
        
        var signString = tempDic.mq_sortJsonString()
        signString += MQAPI_SIGN_KEY
        signString += token ?? ""
        signString = signString.replacingOccurrences(of: "\\/", with: "/")
        
        var temp2 = tempDic
        temp2["sign"] = signString.mq_md5String()
        temp2["token"] = MQUser.user.userToken
        return temp2
    }
    
    func mq_sortJsonString() -> String {
        var tempDic = self as! Dictionary<String,Any>
        var keys = Array<String>()
        for key in tempDic.keys {
            keys.append(key)
        }
        keys.sort { $0 < $1 }
        var signString = "{"
        var arr: Array<String> = []
        for key in keys {
            let value = tempDic[key]
            if let value = value as? Dictionary<String,Any> {
                arr.append("\"\(key)\":\(value.mq_sortJsonString())")
            }else if let value = value as? Array<Any> {
                arr.append("\"\(key)\":\(value.mq_sortJsonString())")
            }else{
                //var strValue = "\(tempDic[key]!)"
                //strValue = strValue.replacingOccurrences(of: "\\\"", with: "\"", options: .regularExpression, range: nil)
                //arr.append("\"\(key)\":\"\(strValue as NSString)\"")
                arr.append("\"\(key)\":\"\(tempDic[key]!)\"")
            }
        }
        signString += arr.joined(separator: ",")
        signString += "}"
        return signString
    }
}

extension Array {
    func  mq_sortJsonString() -> String {
        let array = self 
        var arr: Array<String> = []
        var signString = "["
        for value in array {
            if let value = value as? Dictionary<String,Any> {
                arr.append(value.mq_sortJsonString())
            }else if let value = value as? Array<Any> {
                arr.append(value.mq_sortJsonString())
            }else{
                arr.append("\"\(value)\"")
            }
        }
        arr.sort { $0 < $1 }
        signString += arr.joined(separator: ",")
        signString += "]"
        return signString
    }
}

extension String {
    func mq_md5String() -> String{
        let mString = self
        let str = mString.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(mString.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String).uppercased()
    }
}

