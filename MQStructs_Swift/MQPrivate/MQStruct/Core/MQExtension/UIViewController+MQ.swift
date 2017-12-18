//
//  UIViewController+MQ.swift
//  MQStructs
//
//  Created by JuanFelix on 2017/4/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 添加键盘通知
    func mq_addKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillShow(notice:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillHide(notice:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillChangeFrame(notice:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    /// 移除键盘通知
    func mq_removeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func mq_keyboardWillShow(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    @objc func mq_keyboardWillHide(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    @objc func mq_keyboardWillChangeFrame(beginRect:CGRect,endRect: CGRect,duration dt:Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    //MARK: - 
    @objc final func xxx_baseKeyboardWillShow(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            mq_keyboardWillShow(duration: dt, userInfo:userInfo )
        }
    }
    
    @objc final func xxx_baseKeyboardWillHide(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            mq_keyboardWillHide(duration: dt, userInfo: userInfo)
        }
    }
    
    @objc final func xxx_baseKeyboardWillChangeFrame(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let beginRect   = userInfo[UIKeyboardFrameBeginUserInfoKey] as! CGRect
            let endRect     = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let dt          = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            mq_keyboardWillChangeFrame(beginRect: beginRect, endRect: endRect, duration: dt, userInfo: userInfo)
        }
    }
    
    //MARK: - Common
    class func mq_keyController() -> UIViewController! {
        //var keyVC = UIApplication.shared.keyWindow?.rootViewController//购物车window冲突
        var keyVC: UIViewController?
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            keyVC = appDelegate.window?.rootViewController
        } else {
            keyVC = UIApplication.shared.keyWindow?.rootViewController
        }
        repeat{
            if let presentedVC = keyVC?.presentedViewController {
                keyVC = presentedVC
            }else {
                break
            }
        } while ((keyVC?.presentedViewController) != nil)
        return keyVC
    }
    
    //MARK: - 
    @objc func mq_refresh() {
        
    }
    
    @objc func mq_loadmore() {
        
    }

    
    func mq_push(to vc:UIViewController,removeCount:Int,animated:Bool) {
        var nav:UINavigationController?
        if let nv = self as? UINavigationController {
            nav = nv
        } else if let nv = self.navigationController {
            nav = nv
        }
        if let nav = nav {
            var controllers = nav.viewControllers
            for _ in 0..<removeCount {
                controllers.removeLast()
            }
            controllers.append(vc)
            nav.setViewControllers(controllers, animated: animated)
        } else {
            MQAlertUtils.showAlert(withTitle: nil, message: "无法完成PUSH操作")
        }
    }
}
