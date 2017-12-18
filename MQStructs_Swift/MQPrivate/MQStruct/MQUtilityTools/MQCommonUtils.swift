//
//  MQCommonUtils.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/19.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

class MQCommonUtils: NSObject {
    
    static func openURL(_ urlstr:String) {
        if #available(iOS 10.0, *) {
            if let url = URL(string: urlstr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if let url = URL(string: urlstr) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func call(_ tel:String,failed:((_ error:String) -> Void)?) {
        if let url = URL(string: "tel://\(tel)") {
            if UIApplication.shared.canOpenURL(url) {
                self.openURL("tel://\(tel)")
            } else {
                failed?("该设备不支持拨打电话")
            }
        }
        
    }
    
     static func showNetworkActivityIndicator(_ show:Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    static func pasteString() -> String {
        let pasteBoard = UIPasteboard.general
        return pasteBoard.string ?? ""
    }
    
    static func copy(_ text:String!) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = text
    }
}
