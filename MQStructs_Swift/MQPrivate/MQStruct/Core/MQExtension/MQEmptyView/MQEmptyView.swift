//
//  MQEmptyView.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/7.
//  Copyright © 2017年 AidyBao. All rights reserved.
//

import UIKit

typealias MQClosure_Empty = () -> Void

enum MQEnumEmptyType {
    case noData,networkError,cartEmpty,storeEmpty
}

class MQEmptyView: UIView {
    
    var imgIcon     = UIImageView()
    var lbInfo      = UILabel()
    var btnRetry    = UIButton(type: .custom)
    private var currentType = MQEnumEmptyType.noData
    var action:MQClosure_Empty?
    
    private class func emptyView(in view:UIView) -> MQEmptyView? {
        var eView:MQEmptyView? = nil
        for aView in view.subviews {
            if let aView = aView as? MQEmptyView {
                eView = aView
                break
            }
        }
        return eView
    }
    
    class func show(in view:UIView!,type:MQEnumEmptyType,text:String?,retry callBack:MQClosure_Empty? = nil) {
        if let view = view {
            self.hide(from: view)
            let emptyView = MQEmptyView.init(frame: CGRect.zero)
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emptyView)
            emptyView.action = callBack
            
            let leading = NSLayoutConstraint(item: emptyView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: emptyView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
            var trailing = NSLayoutConstraint(item: emptyView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            if view is UIScrollView {
                trailing = NSLayoutConstraint(item: emptyView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: MQBOUNDS_WIDTH)
            }
            view.addConstraints([top,leading,height,trailing])
            
            emptyView.setEmptyViewType(type)
            emptyView.settext1(with: text)
            
        }
    }
    
    class func hide(from view:UIView!) {
        guard let view = self.emptyView(in: view) else {
            return
        }
        view.removeFromSuperview()
    }
    var imgCenterX: NSLayoutConstraint!
    var imgTop: NSLayoutConstraint!
    var imgWidth: NSLayoutConstraint!
    var imgHeight: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgIcon.contentMode = .center
        lbInfo.textAlignment = .center
        lbInfo.numberOfLines = 0
        lbInfo.lineBreakMode = .byWordWrapping
        lbInfo.font = UIFont.mq_titleFont(14)
        lbInfo.textColor = UIColor.mq_textColorMark
        btnRetry.backgroundColor = UIColor.clear
        btnRetry.layer.borderColor = UIColor.mq_textColorBody.cgColor
        btnRetry.layer.cornerRadius = 5
        btnRetry.layer.borderWidth = 1.0
        btnRetry.setTitle("点击重试", for: .normal)
        btnRetry.setTitleColor(UIColor.mq_textColorBody, for: .normal)
        btnRetry.titleLabel?.font = UIFont.mq_bodyFont
        btnRetry.addTarget(self, action: #selector(self.retryAction), for: .touchUpInside)
        btnRetry.layer.cornerRadius = 5.0
        imgIcon.translatesAutoresizingMaskIntoConstraints = false
        lbInfo.translatesAutoresizingMaskIntoConstraints = false
        btnRetry.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgIcon)
        addSubview(lbInfo)
        addSubview(btnRetry)
        self.backgroundColor = UIColor.mq_subTintColor
        
        imgCenterX = NSLayoutConstraint(item: imgIcon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        imgTop = NSLayoutConstraint(item: imgIcon, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 40)
        imgWidth = NSLayoutConstraint(item: imgIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        imgHeight = NSLayoutConstraint(item: imgIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 130)
        self.addConstraints([imgCenterX,imgTop,imgWidth,imgHeight])
        
        let lbtop = NSLayoutConstraint(item: lbInfo, attribute: .top, relatedBy: .equal, toItem: imgIcon, attribute: .bottom, multiplier: 1, constant: 10)
        let lbleading = NSLayoutConstraint(item: lbInfo, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let lbtrailing = NSLayoutConstraint(item: lbInfo, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20)
        self.addConstraints([lbleading,lbtop,lbtrailing])
        
        
        let btntop = NSLayoutConstraint(item: btnRetry, attribute: .top, relatedBy: .equal, toItem: lbInfo, attribute: .bottom, multiplier: 1, constant: 5)
        let btncenterx = NSLayoutConstraint(item: btnRetry, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let btnWidth = NSLayoutConstraint(item: btnRetry, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        let btnheight = NSLayoutConstraint(item: btnRetry, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        self.addConstraints([btntop,btncenterx,btnWidth,btnheight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func retryAction() {
        
        self.action?()
    }
    
    func settext1(with text:String?) {
        if let text = text {
            self.lbInfo.text = text
        }else {
            switch currentType {
            case .networkError:
                self.lbInfo.text = "访问数据失败"
            case .noData:
                self.lbInfo.text = "暂无相关数据"
            case .cartEmpty:
                self.lbInfo.text = "去首页看看吧"
            case .storeEmpty:
                self.lbInfo.text = "线上药店准备中"
            }
        }
    }
    
    func setEmptyViewType(_ type:MQEnumEmptyType) {
        currentType = type
        imgWidth.constant = 150
        imgHeight.constant = 130
        imgTop.constant = 40
        imgCenterX.constant = 0
        
        switch type {
        case .noData:
            imgIcon.image = #imageLiteral(resourceName: "h_no_data")
            //btnRetry.isHidden = true
            btnRetry.setTitle("点击刷新", for: .normal)
        case .networkError:
            imgIcon.image = #imageLiteral(resourceName: "h_network_error")
            //btnRetry.isHidden = false
            btnRetry.setTitle("点击重试", for: .normal)
            imgWidth.constant = 57
            imgHeight.constant = 84
            imgTop.constant = 40
            imgCenterX.constant = 10
        case .cartEmpty:
            imgIcon.image = #imageLiteral(resourceName: "h_no_data")
            //btnRetry.isHidden = true
            btnRetry.setTitle("点击刷新", for: .normal)
        case .storeEmpty:
            imgIcon.image = #imageLiteral(resourceName: "zx-store-empty")
            //btnRetry.isHidden = true
            btnRetry.setTitle("点击刷新", for: .normal)
        }
        
        if self.action == nil {
            btnRetry.isHidden = true
        } else {
            btnRetry.isHidden = false
        }
        self.layoutIfNeeded()
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        if view == btnRetry {
//            self.retryAction()
//        }
//        return view
//    }
}
