//
//  NSObject+MQ.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/30.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

public extension NSObject{
    var mq_className: String {
        return String(describing: type(of: self))
    }
    public class var mq_className: String{
        return NSStringFromClass(type(of: self) as! AnyClass).components(separatedBy: ".").last!
    }
}
