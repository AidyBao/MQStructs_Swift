//
// MQAPI.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/14.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

enum MQWebPageType: Int {
    case floorIds = 1   //楼层
    case activity = 2   //活动
}

class MQAPI: NSObject {
    final class func api(address path:String!) -> String {
        var strAPIURL = MQURLConst.Api.url + ":" + MQURLConst.Api.port
        if path.hasPrefix("/") {
            strAPIURL += path
        }else {
            strAPIURL += "/" + path
        }
        return strAPIURL
    }
    
    final class func file(address path:String!) -> String {
        var strAPIURL = MQURLConst.Resource.url + ":" + MQURLConst.Resource.port
        if path.hasPrefix("/") {
            strAPIURL += path
        }else {
            strAPIURL += "/" + path
        }
        return strAPIURL
    }
    
    final class func store(address path:String!) -> String {
        //var strAPIURL = ZXAPIConst.Store.url//接口地址合并
        var strAPIURL = MQURLConst.Api.url + ":" + MQURLConst.Api.port
        if path.hasPrefix("/") {
            strAPIURL += path
        }else {
            strAPIURL += "/" + path
        }
        return strAPIURL
    }
    
    final class func activity(_ sId:String,type:MQWebPageType) -> String {
        var strWebURL = MQURLConst.Web.url
        var arrParams = [String]()
        arrParams.append("id=\(sId)")
        arrParams.append("flag=\(type.rawValue)")
        arrParams.append("pageSize=\(MQ.PageSize)")
        arrParams.append("pageNum=1")
        arrParams.append("memberId=\(MQUser.user.memberId)")
        arrParams.append("token=\(MQUser.user.userToken)")
        
        if arrParams.count > 0 {
            strWebURL.append("?\(arrParams.joined(separator: "&"))")
            strWebURL.append("&uTime=\(NSUUID.init().uuidString)")
        }else{
            strWebURL.append("?uTime=\(NSUUID.init().uuidString)")
        }
        print(strWebURL)
        return strWebURL
    }
}
