//
//  MQTabbarCongig.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

public class MQTabbarItem:NSObject {
    public var embedInNavigation:  Bool    = true
    public var showAsPresent:      Bool    = false
    public var normalImage:        String  = ""
    public var selectedImage:      String  = ""
    public var title:              String  = ""
    
    override init() {
        
    }
    
    public init(_ dic:[String:Any]!) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

public class MQTabbarCongig: NSObject {
    
    public static var config: NSDictionary?
    public class func mqTarbarConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.mq_tabBarConfigPath())!
            return config
        }
        return cfg
    }
    
    public class var barItems: [MQTabbarItem] {
        var arrItems: [MQTabbarItem] = []
        if let items = mqTarbarConfig().object(forKey: "mq_barItems") as? Array<Dictionary<String,Any>> {
            for item in items {
                arrItems.append(MQTabbarItem(item))
            }
        }
        return arrItems
    }
}
