//
//  AppDelegate+BMap.swift
//  MQStructs
//
//  Created by AidyBao on 2017/11/1.
//  Copyright © 2017年 Aidy. All rights reserved.
//

import UIKit

var mapManager: BMKMapManager?

extension AppDelegate {
    
    func judgmentLocationServiceEnabled() {
        MQLocationUtils.shareInstance.checkCurrentLocation { (status, location) in
            var isSuccess: Bool = false
            if status == .success {
                isSuccess = true
            }else{
                isSuccess = false
            }
            NotificationCenter.mqpost.judgementLocationStatus(isSuccess)
        }
    }

    func launchBaiBuMap() {
        var bmap_Key: String = ""
        
        if MQDevice.mq_getBundleId() == MQ.Package.enterpriseBundleId{
            bmap_Key = MQ.BMap.Enterprise_Key
        }else{
            bmap_Key = MQ.BMap.AppStore_Key
        }
        mapManager = BMKMapManager.init()
        let ret: Bool = (mapManager?.start(bmap_Key, generalDelegate: self))!
        if !ret {
            print("manager start failed!")
        }
    }
}

extension AppDelegate: BMKGeneralDelegate {
    func onGetNetworkState(_ iError: Int32) {
        if 0 == iError {
            print("联网成功")
        }else{
            print("onGetNetworkState \(iError)")
        }
    }
    func onGetPermissionState(_ iError: Int32) {
        if 0 == iError {
            print("授权成功")
        }else{
            print("onGetPermissionState \(iError)")
        }
    }
}
