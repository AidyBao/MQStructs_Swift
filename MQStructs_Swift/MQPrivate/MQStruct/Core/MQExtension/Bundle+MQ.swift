//
//  Bundle+MQ.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

extension Bundle {
    
    public static var getCoreBundle: Bundle {
        let mqCoreStr = Bundle.main.path(forResource: "MQCore", ofType: "bundle")
        let mqCoreBundle = Bundle.init(path: mqCoreStr!)
        return mqCoreBundle!
    }
    
    public class func mq_tintColorConfigPath() -> String! {
        return getCoreBundle.path(forResource: "MQConfig/MQTintColorConfig", ofType: "plist")
    }
    
    public class func mq_fontConfigPath() -> String! {
        return getCoreBundle.path(forResource: "MQConfig/MQFontConfig", ofType: "plist")
    }
    
    public class func mq_navBarConfigPath() -> String! {
        return getCoreBundle.path(forResource: "MQConfig/MQNavBarConfig", ofType: "plist")
    }
    
    public class func mq_tabBarConfigPath() -> String! {
        return getCoreBundle.path(forResource: "MQConfig/MQTabBarConfig", ofType: "plist")
    }
    
    public class func mq_navBackImage() -> UIImage! {
        return UIImage(contentsOfFile: mq_navBackImageName())
    }
    
    public class func mq_navBackImageName() -> String! {
        let scale: Int = Int(UIScreen.main.scale)
        return getCoreBundle.path(forResource: "mq_navback@\(scale)x", ofType: "png")!
    }
    
    
    /// Project Name
    static var mq_projectName: String! {
        return self.main.infoDictionary!["CFBundleExecutable"] as! String
    }
    
    
    /// Version
    static var mq_bundleVersion: String {
        return self.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /// Build
    static var mq_bundleBuild: String {
        return self.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    
    /// BundleId
    static var mq_bundleId: String {
        return self.main.infoDictionary!["CFBundleIdentifier"] as! String
    }

}
