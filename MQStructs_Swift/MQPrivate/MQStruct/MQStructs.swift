//
//  MQStructs.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/12/15.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

class MQStructs: NSObject {
    class func loadUIConfig()  {
        self.loadnavBarConfig()
        self.loadtabBarConfig()
    }
    
    class func loadnavBarConfig() {
        MQNavBarConfig.active()
    }
    
    class func loadtabBarConfig() {
        MQTabbarConfig.active()
    }
}
