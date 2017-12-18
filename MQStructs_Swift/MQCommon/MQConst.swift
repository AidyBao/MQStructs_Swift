//
//  MQURLConst.swift
//  ZXStructs
//
//  Created by AidyBao on 2017/4/17.
//  Copyright © 2017年 MQ. All rights reserved.
//

import Foundation
import UIKit

let MQBOUNDS_WIDTH      =   UIScreen.main.bounds.size.width
let MQBOUNDS_HEIGHT     =   UIScreen.main.bounds.size.height

class MQ {
    
    static let PageSize:Int             =   12
    static let HUDDelay                 =   1.2
    static let CallDelay                =   0.5
    
    //MARK: - 会员、管家、店铺二维码
    static let QRCode_ContainText       =   ""   //二维码地址需包含
    //定位失败 默认位置
    struct Location {
        static let latitude             =   30.592061
        static let longitude            =   104.063396
    }
    
    struct Package {
        //MARK: - 应用包名
        static let enterpriseBundleId   =   ""           //企业
        static let appStoreBundleId     =   ""  //AppStore
        static let appStoreId           =   ""
    }
    //MARK: - 百度地图
    struct BMap {
        static let AppStore_Key   =   ""  //AppStore
        static let Enterprise_Key =   ""  //企业
    }
    
    //MARK: - 测试账号
    struct TestAccount {
        static let account   =   "18888888888"
        static let password  =   "666666"
    }
}


/// 接口地址
class MQURLConst {
    //线上
    struct Api {
        static let url                  =   ""
        static let port                 =   ""
    }
    
    struct Resource {
        static let url                  =   ""
        static let port                 =   ""
    }
    
    struct Web {
        static let url                  =   ""          //Web
        static let about                =   "" //关于H5
        static let serviceItems         =   ""   //服务条款H5
    }
    
    struct Update {
        static let enterprise           =   "https://"
        static let appstore             =   "https://"

    }
    
    struct Post {
        static let express              =   "https://"
    }
}

/// 功能模块接口
class MQAPIConst {
    struct Store {
        static let home                 =   ""
    }
}
