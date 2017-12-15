//
//  MQTabbarConfig.swift
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

public class MQTabbarConfig: NSObject {
    
    public static var config: NSDictionary?
    public class func mqTarbarConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.mq_tabBarConfigPath())!
            return config
        }
        return cfg
    }
    
    static func configBoolValue(forKey key:String, defaultValue: Bool) -> Bool {
        if let boolValue = mqTarbarConfig().object(forKey: key) as? Bool {
            return boolValue
        }
        return defaultValue
    }
    
    static func configStringValue(forKey key: String!, defaultValue: String!) -> String! {
        if let configStr = (mqTarbarConfig().object(forKey: key) as? String),configStr.count > 0 {
            return configStr
        }
        return defaultValue
    }
    
    static func configFontSizeValue(forKey key:String,defaultSize:CGFloat) -> CGFloat {
        if let dicF = mqTarbarConfig().object(forKey: key) as? NSDictionary {
            switch UIDevice.mq_DeviceSizeType() {
            case .s_4_0Inch:
                return dicF.object(forKey: "4_0") as! CGFloat
            case .s_4_7Inch:
                return dicF.object(forKey: "4_7") as! CGFloat
            case .s_5_5_Inch:
                return dicF.object(forKey: "5_5") as! CGFloat
            default:
                return dicF.object(forKey: "5_5") as! CGFloat
            }
        }
        return defaultSize
    }

    //MARK: - Bool Value
    public class var showSeparatorLine: Bool {
        return configBoolValue(forKey: "mq_showSeparatorLine", defaultValue: true)
    }
    
    public class var isTranslucent: Bool {
        return configBoolValue(forKey: "mq_isTranslucent", defaultValue: false)
    }
    
    //MARK: - Font
    public class var isCustomTitleFont: Bool {
        return configBoolValue(forKey: "mq_customTitleFont", defaultValue: false)
    }
    
    public class var customTitleFont: UIFont {
        return UIFont(name: customTitleFontName, size: customTitleFontSize)!
    }
    
    public class var customTitleFontSize: CGFloat {
        return configFontSizeValue(forKey: "mq_customTitleFontSize", defaultSize: 11)
    }
    
    public class var customTitleFontName: String {
        return configStringValue(forKey: "mq_customTitleFontName", defaultValue: "Arial")
    }
    
    //MARK: - Color Hex String
    public class var backgroundColorStr: String {
        return configStringValue(forKey: "mq_backgroundColor", defaultValue: "#ff0000")
    }
    
    public class var titleNormalColorStr: String {
        return configStringValue(forKey: "mq_titleNormalColor", defaultValue: "#ff0000")
    }
    
    public class var titleSelectedColorStr: String {
        return configStringValue(forKey: "mq_titleSelectedColor", defaultValue: "#ff0000")
    }
    
    fileprivate static var tabBarItems: [MQTabbarItem]?
    class var barItems: [MQTabbarItem] {
        if tabBarItems == nil {
            tabBarItems = []
            if let items = mqTarbarConfig().object(forKey: "mq_barItems") as? Array<Dictionary<String,Any>> {
                for item in items {
                    let mqItem = MQTabbarItem()
                    mqItem.embedInNavigation = (item["embedInNavigation"] as? Bool) ?? true
                    mqItem.showAsPresent = (item["showAsPresent"] as? Bool) ?? false
                    mqItem.normalImage = (item["normalImage"] as? String) ?? ""
                    mqItem.selectedImage = (item["selectedImage"] as? String) ?? ""
                    mqItem.title = (item["title"] as? String) ?? ""
                    tabBarItems?.append(mqItem)
                }
            }
        }
        return tabBarItems!
    }
}

extension MQTabbarConfig {
    static func active() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = MQTabbarConfig.isTranslucent
        tabBarAppearance.barTintColor = UIColor.mq_tabBarColor
        if !MQTabbarConfig.showSeparatorLine {
            tabBarAppearance.shadowImage = UIImage()
            tabBarAppearance.backgroundImage = UIImage()
        }

        let tabBarItem = UITabBarItem.appearance()
        if !MQTabbarConfig.isCustomTitleFont {
            tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.mq_tabBarTitleNormalColor], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.mq_tabBarTitleSelectedColor], for: .selected)
        }else{
            tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.mq_tabBarTitleNormalColor,NSAttributedStringKey.font:MQTabbarConfig.customTitleFont], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.mq_tabBarTitleSelectedColor,NSAttributedStringKey.font:MQTabbarConfig.customTitleFont], for: .selected)
        }
    }
}
