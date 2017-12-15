//
//  MQNavBarConfig.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

class MQNavBarConfig: NSObject {
    
    //MARK: - Config Dic
    public static var config: NSDictionary?
    public class func mqNavBarConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.mq_navBarConfigPath())!
            return config
        }
        return cfg
    }
    
    public static func configStringValue(forKey key: String!, defaultValue: String!) -> String! {
        if let configStr = (mqNavBarConfig().object(forKey: key) as? String),configStr.count > 0 {
            return configStr
        }
        return defaultValue
    }
    
    public static func configFontSizeValue(forKey key:String,defaultSize:CGFloat) -> CGFloat {
        if let dicF = mqNavBarConfig().object(forKey: key) as? NSDictionary {
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
    
    public static func configBoolValue(forKey key:String, defaultValue: Bool) -> Bool {
        if let boolValue = mqNavBarConfig().object(forKey: key) as? Bool {
            return boolValue
        }
        return defaultValue
    }

    
    //MARK: - Bool Value
    public class var userSystemBackButton: Bool {
        return configBoolValue(forKey: "mq_userSystemBackButton", defaultValue: true)
    }
    
    public class var showSeparatorLine: Bool {
        return configBoolValue(forKey: "mq_showSeparatorLine", defaultValue: true)
    }
    
    public class var isTranslucent: Bool {
        return configBoolValue(forKey: "mq_isTranslucent", defaultValue: false)
    }
    //MARK: - Color Hex String
    public class var narBarColorStr: String {
        return configStringValue(forKey: "mq_navBarColor", defaultValue: "#ff0000")
    }
    
    public class var titleColorStr: String {
        return configStringValue(forKey: "mq_titleColor", defaultValue: "#ffffff")
    }
    
    public class var barButtonColor: String  {
        return configStringValue(forKey: "mq_barButtonColor", defaultValue: "#ffffff")
    }
    
    //MARK: - Font Size
    
    public class var titleFontSize: CGFloat {
        return configFontSizeValue(forKey: "mq_titleFontSize", defaultSize: 18)
    }
    
    public class var barButtonFontSize: CGFloat {
        return configFontSizeValue(forKey: "mq_barButtonFontSize", defaultSize: 16)
    }
    //MARK: - Nav Title Font
    public class var navTitleFontName: String! {
        return configStringValue(forKey: "mq_navTitleFont", defaultValue: "Arial")
    }
    
    public class func navTilteFont(_ size:CGFloat) -> UIFont! {
        return UIFont(name: navTitleFontName, size: size)
    }
}

extension MQNavBarConfig {
    static func active(){
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent  = MQNavBarConfig.isTranslucent
        navBarAppearance.barTintColor   = UIColor.mq_navBarColor
        navBarAppearance.tintColor      = UIColor.mq_navBarButtonColor
        
        navBarAppearance.titleTextAttributes = {[NSAttributedStringKey.foregroundColor: UIColor.mq_navBarTitleColor,NSAttributedStringKey.font: MQNavBarConfig.navTilteFont(MQNavBarConfig.titleFontSize)]}()
        
        if !MQNavBarConfig.showSeparatorLine {
            navBarAppearance.shadowImage = UIImage()
            navBarAppearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        }
        
        if !MQNavBarConfig.userSystemBackButton {
            let image = Bundle.mq_navBackImage()
            navBarAppearance.backIndicatorImage = image
            navBarAppearance.backIndicatorTransitionMaskImage = image
        }
    }
}
