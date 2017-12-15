//
//  String+MQ.swift
//  MQStructs
//
//  Created by AidyBao on 2017/3/31.
//  Copyright © 2017年 MQ. All rights reserved.
//

import Foundation
import UIKit

let PASSWORD_REG    = "^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$" //6-20位字母+数字
let MOBILE_REG      = "[1]\\d{10}$"
let EMAIL_REG       = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
let CHINESE_REG     = "(^[\\u4e00-\\u9fa5]+$)"
let VALID_REG     = "[\\u4E00-\\u9FA5A-Za-z0-9_]+$"

extension String {
    func index(at: Int) -> Index {
        return self.index(startIndex, offsetBy: at)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(at: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(at: to)
        return substring(to: toIndex)
    }
    
    func substring(with r:Range<Int>) -> String {
        let startIndex  = index(at: r.lowerBound)
        let endIndex    = index(at: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension String {
    func mq_matchs(regularString mstr:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@",mstr)
        return predicate.evaluate(with:self)
    }
    
    func mq_passwordValid() -> Bool {
        return mq_matchs(regularString: PASSWORD_REG)
    }
    
    func mq_mobileValid() -> Bool {
        return mq_matchs(regularString: MOBILE_REG)
    }
    
    func mq_emailValid() -> Bool {
        return mq_matchs(regularString: EMAIL_REG)
    }
    
    func mq_isChinese() -> Bool {
        return mq_matchs(regularString: CHINESE_REG)
    }
    
    func mq_inValidText() -> Bool {
        return !mq_matchs(regularString: VALID_REG)
    }
    
    func mq_textRectSize(toFont font:UIFont,limiteSize:CGSize) -> CGSize {
        let size = (self as NSString).boundingRect(with: limiteSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue|NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes:[NSAttributedStringKey.font:font], context: nil).size
        return size
    }
    
    func mq_noticeName() -> NSNotification.Name {
        return NSNotification.Name.init(self)
    }
    
    func mq_telSecury() -> String {
        if self.mq_mobileValid() {
            let head = self.substring(with: 0..<3)
            let tail = self.substring(with: (self.count - 4)..<self.count)
            return "\(head)****\(tail)"
        } else {
            return self
        }
    }
    
    func mq_priceFormat(_ fontName:String,size:CGFloat,bigSize:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var price = self.mq_priceString()
        let aRange = NSMakeRange(0, price.count)//¥ + 小数部分
        var pRange = NSMakeRange(1, price.count)//整数部分
        
        let location = (price as NSString).range(of: ".")
        if  location.length > 0 {
            pRange = NSMakeRange(1, location.location)//整数部分
        }
        
        let formatPrice = NSAttributedString.mq_colorFormat(price, color: color, at: aRange)
        
        formatPrice.mq_appendFont(font: UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size), at: aRange)
        formatPrice.mq_appendFont(font: UIFont(name: fontName, size: bigSize) ?? UIFont.systemFont(ofSize: bigSize), at: pRange)
        
        return formatPrice
    }
    
    func mq_priceFormat(color:UIColor?) -> NSMutableAttributedString {
        return self.mq_priceFormat(UIFont.mq_titleFontName, size: UIFont.mq_titleFontSize, bigSize: UIFont.mq_titleFontSize, color: color ?? UIColor.mq_customAColor)
    }
    
    func mq_priceString(_ unit:Bool = true,_ clipRadixPointIfInt: Bool = false) -> String {
        var price = self
        if price.count <= 0 {
            price = "0"
        }
        let location = (price as NSString).range(of: ".")
        if  location.length <= 0 {
            price += ".00"
        } else if (price.count - 1 - location.location) < 2 {
            price += "0"
        }
        price = price.replacingOccurrences(of: "(?<=\\d)(?=(\\d\\d\\d)+(?!\\d))", with: ",", options: .regularExpression, range: price.startIndex..<price.endIndex)
        if unit {
            if !price.hasPrefix("¥") {
                return "¥\(price)"
            }
        } else {
            if price.hasPrefix("¥") {
                return price.substring(from: 1)
            }
        }
        
        if clipRadixPointIfInt {
            price = price.replacingOccurrences(of: ".00", with: "")
        }
        
        return price
    }
    
    func mq_pinyin(removeSpace: Bool = false)->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        if removeSpace {
            return string.lowercased().replacingOccurrences(of: " ", with: "")
        } else {
            return string
        }
    }
    
}

extension NSNumber {
    func mq_priceString(_ unit:Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        var str = formatter.string(from: self) ?? "0.00"
        str = str.replacingOccurrences(of: "^[^\\d]*", with: unit ? "¥" : "", options: .regularExpression, range: str.startIndex..<str.endIndex)
        return str
    }
}
