//
//  UIViewController+MQNavControl.swift
//  MQStructs
//
//  Created by JuanFelix on 2017/4/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum MQNavBarButtonItemPosition {
    case left,right
}

extension UIViewController {
    //MARK: - Navigation Control
    
    var mq_navFixSapce:CGFloat {
        get {
            if UIDevice.mq_DeviceSizeType() == .s_4_0Inch {
                return 0
            }
            return -5
            //return 0
        }
    }
    
    /// Clear backBarButtonItem Title
    func mq_clearNavbarBackButtonTitle() {
        let backItem = UIBarButtonItem(title: " ", style: .done, target: self, action: #selector(self.mq_popviewController(animated:)))
        
        self.navigationItem.backBarButtonItem = backItem
    }
    
    
    /// Add BarButton Item from Image names
    ///
    /// - Parameters:
    ///   - names: image names
    ///   - useOriginalColor: (true - imageColor false - bar tintcolor)
    ///   - position: .left .right
    func mq_addNavBarButtonItems(imageNames names:Array<String>,useOriginalColor:Bool,at position:MQNavBarButtonItemPosition) {
        if names.count > 0 {
            var items: Array<UIBarButtonItem> = Array()
            var n = 0
            for imgName in names {
                let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                negativeSpacer.width = mq_navFixSapce
                items.append(negativeSpacer)
                
                var itemT:UIBarButtonItem!
                var image = UIImage.init(named: imgName)
                if useOriginalColor {
                    image = image?.withRenderingMode(.alwaysOriginal)
                }
                if position == .right {
                    itemT = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(self.xxx_rightBarButtonAction(sender:)))
                }else{
                    itemT = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(self.xxx_leftBarButtonAction(sender:)))
                }
                itemT.tag = n
                n += 1
                items.append(itemT)
            }
            if position == .left {
                self.navigationItem.leftBarButtonItems = items
            }else{
                self.navigationItem.rightBarButtonItems = items
            }
        }else{
            if position == .left {
                self.navigationItem.leftBarButtonItems = nil
            }else{
                self.navigationItem.rightBarButtonItems = nil
            }
        }
        //self.navigationController?.navigationBar.topItem?.xxx_ButtonItem 效果不对
    }
    
    
    /// Add BarButton Item from text title
    ///
    /// - Parameters:
    ///   - names: text title
    ///   - font: text font (Default:MQNavBarConfig.navTilteFont)
    ///   - color: text color (Default:UIColor.mq_navBarButtonColor)
    ///   - position: .left .right
    func mq_addNavBarButtonItems(textNames names:Array<String>,font:UIFont?,color:UIColor?,at position:MQNavBarButtonItemPosition) {
        if names.count > 0 {
            var items: Array<UIBarButtonItem> = Array()
            var n = 0
            for title in names {
                let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                negativeSpacer.width = mq_navFixSapce
                items.append(negativeSpacer)
                
                var itemT:UIBarButtonItem!
                if position == .right {
                    itemT = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(self.xxx_rightBarButtonAction(sender:)))
                }else{
                    itemT = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(self.xxx_leftBarButtonAction(sender:)))
                }
                itemT.tag = n
                n += 1
                itemT.setTitleTextAttributes([NSAttributedStringKey.font:font ?? MQNavBarConfig.navTilteFont(MQNavBarConfig.barButtonFontSize)!,NSAttributedStringKey.foregroundColor: color ?? UIColor.mq_navBarButtonColor!], for: .normal)
                items.append(itemT)
            }
            if position == .left {
                self.navigationItem.leftBarButtonItems = items
            }else{
                self.navigationItem.rightBarButtonItems = items
            }
        }else{
            if position == .left {
                self.navigationItem.leftBarButtonItems = nil
            }else{
                self.navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    
    /// Add BarButton Item from iconfont Unicode Text
    ///
    /// - Parameters:
    ///   - names: iconfont Unicode Text
    ///   - size: font size
    ///   - color: font color (Default UIColor.mq_navBarButtonColor)
    ///   - position: .left .right
    func mq_addNavBarButtonItems(iconFontTexts names:Array<String>,fontSize size:CGFloat,color:UIColor?,at position:MQNavBarButtonItemPosition) {
        if names.count > 0 {
            var items: Array<UIBarButtonItem> = Array()
            var n = 0
            for title in names {
                let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                negativeSpacer.width = mq_navFixSapce
                items.append(negativeSpacer)
                
                var itemT:UIBarButtonItem!
                if position == .right {
                    itemT = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(self.xxx_rightBarButtonAction(sender:)))
                }else{
                    itemT = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(self.xxx_leftBarButtonAction(sender:)))
                }
                itemT.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.mq_iconFont(size),NSAttributedStringKey.foregroundColor: color ?? UIColor.mq_navBarButtonColor!], for: .normal)
                itemT.tag = n
                n += 1
                items.append(itemT)
            }
            if position == .left {
                self.navigationItem.leftBarButtonItems = items
            }else{
                self.navigationItem.rightBarButtonItems = items
            }
        }else{
            if position == .left {
                self.navigationItem.leftBarButtonItems = nil
            }else{
                self.navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    func mq_addNavBarButtonItems(customView view:UIView!,at position:MQNavBarButtonItemPosition) {
        var items: Array<UIBarButtonItem> = Array()
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = mq_navFixSapce
        items.append(negativeSpacer)
        
        let itemT = UIBarButtonItem.init(customView: view)
        items.append(itemT)
        
        if position == .left {
            self.navigationItem.leftBarButtonItems = items
        }else{
            self.navigationItem.rightBarButtonItems = items
        }
    }
    
    /// Right Bar Button Action
    ///
    /// - Parameter index: index 0...
    @objc func mq_rightBarButtonAction(index: Int) {
        
    }
    
    /// Left BarButton Action
    ///
    /// - Parameter index: index 0...
    @objc func mq_leftBarButtonAction(index: Int) {
        
    }
    
    //MARK: - NavBar Background Color
    func mq_setNavBarBackgroundColor(_ color: UIColor!) {
        self.navigationController?.navigationBar.barTintColor = color
        if color == UIColor.clear {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        }else{
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func mq_setNavBarSubViewsColor(_ color: UIColor!){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.mq_titleFontSize)]
        self.navigationController?.navigationBar.tintColor = color
    }
    
    //MARK: - Tabar Background Color
    func mq_setTabbarBackgroundColor(_ color:UIColor!) {
        self.tabBarController?.tabBar.barTintColor = color
        if color == UIColor.clear {
            self.tabBarController?.tabBar.isTranslucent = true
            self.tabBarController?.tabBar.backgroundImage = UIImage()
        }else{
            self.tabBarController?.tabBar.isTranslucent = false
        }
    }
    
    //MARK: -
    @objc final func xxx_rightBarButtonAction(sender:UIBarButtonItem) {
        mq_rightBarButtonAction(index: sender.tag)
    }
    
    @objc final func xxx_leftBarButtonAction(sender:UIBarButtonItem) {
        mq_leftBarButtonAction(index: sender.tag)
    }
    
    @objc func mq_popviewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}

//extension UINavigationController {
//    override open var prefersStatusBarHidden: Bool {
//        return false
//    }
//    
//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    override open var childViewControllerForStatusBarStyle: UIViewController? {
//        return visibleViewController
//        //self.topViewController
//    }
//    
//    override open var childViewControllerForStatusBarHidden: UIViewController? {
//        return visibleViewController
//    }
//}

