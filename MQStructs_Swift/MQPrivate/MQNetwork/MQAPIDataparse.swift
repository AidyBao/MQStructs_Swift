//
//  MQAPIDataparse.swift
//  MQStructs
//
//  Created by AidyBao on 2017/4/12.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

let MQAPI_TIMEOUT_INTREVAL      =   10.0    //接口超时时间
let MQAPI_SUCCESS:Int           =   0       //接口调用成功
let MQAPI_UNREGIST:Int          =   100004  //用户不存在
let MQAPI_STOCK_NOTENOUGH:Int   =   202005  //库存不足
let MQAPI_LOGIN_INVALID:Int     =   100001  //登录失效
let MQAPI_FORMAT_ERROR:Int      =   900900  //无数据或格式错误
let MQAPI_SERVCE_ERROR:Int      =   -1009   //网络错误
let MQAPI_SERVCE_STOP:Int       =   -1004   //网络错误
let MQAPI_COUPON_ERROR:Int      =   200006  //保存订单现金券异常

let MQAPI_HTTP_TIME_OUT         =   -1001   //请求超时
let MQAPI_HTTP_ERROR            =   900901  //HTTP请求失败



class MQError: NSObject {
    var errorMessage:String = ""
    init(_ msg:String!) {
        super.init()
        errorMessage = msg
    }
    
    override var description: String{
        get {
            return errorMessage
        }
    }
}


typealias MQAPISuccessAction        = (Int,Dictionary<String,Any>) -> Void          //Code,Response Object
typealias MQAPIPOfflineAction       = (Int,MQError,Dictionary<String,Any>) -> Void                         //OfflineMessage
typealias MQAPIServerErrorAction    = (Int,MQError,Dictionary<String,Any>) -> Void  //Status,ErrorMsg,Object
typealias MQAPICompletionAction     = (Bool,Int,Dictionary<String,Any>,String,MQError?) -> Void       //success 服务器正取返回，code = 0，Object,ObjectString,ErrorInfo

class MQAPIDataparse: NSObject {
    
    fileprivate static func postLoginInvalidNotice(url:String) -> Bool{
//        if url == MQAPI.address(module: MQAPIConst.Home.cartNum) ||
//            url == MQAPI.address(module: MQAPIConst.Home.unreadMsg) ||
//            url == MQAPI.address(module: MQAPIConst.User.updateEquipmentInfo) ||
//            url == MQAPI.address(module: MQAPIConst.Category.getHistoricRecords){
//            return false
//        }
        return true
    }
    class func parseJsonObject(_ objA:Any?,
                               url:String? = nil,
                               success:MQAPISuccessAction?,
                               offline:MQAPIPOfflineAction?,
                               serverError:MQAPIServerErrorAction?) {
        if let objB = objA as? Dictionary<String,Any> {
            var status = 0
            if let s = objB["status"] as? NSNumber {
                status = s.intValue
            }else if let s = objB["status"] as? String {
                status = Int(s)!
            }
            switch status {
                case MQAPI_LOGIN_INVALID:
                    if let url = url,self.postLoginInvalidNotice(url: url) {
                        NotificationCenter.mqpost.loginInvalid()
                    }
                    offline?(status,MQError.init((objB["msg"] as? String) ?? "用户登录失效"),objB)
                case MQAPI_SUCCESS:
                    success?(status,objB)
                default:
                    serverError?(status,MQError.init((objB["msg"] as? String) ?? "未知错误"),objB)
                    break
            }
        }else{
            serverError?(MQAPI_FORMAT_ERROR,MQError.init("无数据或格式错误"),[:])
        }
    }
}

extension MQNetwork {
    
    class func errorCodeParse(_ code:Int,httpError:(() -> Void)?,serverError:(() -> Void)?,loginInvalid:(() -> Void)? = nil) {
        if code != MQAPI_SUCCESS {
            if code == MQAPI_LOGIN_INVALID {
                loginInvalid?()
            } else if code == NSURLErrorUnknown ||
                code == NSURLErrorCancelled ||
                code == NSURLErrorBadURL ||
                code == NSURLErrorUnsupportedURL ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost ||
                code == NSURLErrorDNSLookupFailed ||
                code == NSURLErrorHTTPTooManyRedirects ||
                code == NSURLErrorResourceUnavailable ||
                code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorRedirectToNonExistentLocation ||
                code == NSURLErrorBadServerResponse ||
                code == NSURLErrorUserCancelledAuthentication ||
                code == NSURLErrorUserAuthenticationRequired ||
                code == NSURLErrorZeroByteResource ||
                code == NSURLErrorCannotDecodeRawData ||
                code == NSURLErrorCannotDecodeContentData ||
                code == NSURLErrorCannotParseResponse{
                httpError?()
            } else {
                serverError?()
            }
        }
        
    }
    
    @discardableResult class func asyncRequest(withUrl url:String,
                                               params: Dictionary<String, Any>?,
                                               sign: Bool = true,
                                               method:MQHTTPMethod,
                                               completion:@escaping MQAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if showRequestLog {
            print("\n------------Request------------\n请求地址:\n\(url)\n请求参数:\n\(String(describing: params))\n---------------------------\n")
        }
        if sign,tempP["sign"] == nil {
            tempP = tempP.mq_signDic()
        }
        let task = MQNetwork.mq_asyncRequest(withUrl: url, params: tempP, method: method, completion: { (objA, stringValue) in
            MQAPIDataparse.parseJsonObject(objA,url: url, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",MQError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",MQError.init(errorMsg))
        }
        return task
    }
    
    
    /// 图片文件上传
    ///
    /// - Parameters:
    ///   - url:
    ///   - images:
    ///   - params:
    ///   - sign:
    ///   - compressRatio: 压缩图片质量 0~1 0 最大压缩 1 不压缩
    ///   - completion:
    /// - Returns: 
    @discardableResult class func uploadImage(to url:String!,
                                              images:Array<UIImage>!,
                                              params:Dictionary<String,Any>?,
                                              sign: Bool = true,
                                              compressRatio:CGFloat,
                                              completion:@escaping MQAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if sign,tempP["sign"] == nil {
            tempP = tempP.mq_signDic()
        }
        
        let task = MQNetwork.mq_uploadImage(to: url, images: images, params: tempP, compressRatio: compressRatio, completion: { (objA, stringValue) in
            MQAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",MQError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",MQError.init(errorMsg))
        }
        return task
    }
    
    @discardableResult class func fileupload(to url:String!,
                                             name: String,
                                             fileName: String,
                                             mimeType: String,
                                             fileData: Data,
                                             params:Dictionary<String,Any>?,
                                             sign: Bool = true,
                                             completion:@escaping MQAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if sign,tempP["sign"] == nil {
            tempP = tempP.mq_signDic()
        }
        let task = MQNetwork.mq_fileupload(to: url, name: name, fileName: fileName, mimeType: mimeType, fileData: fileData, params: tempP, completion: { (objA, stringValue) in
            MQAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",MQError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",MQError.init(errorMsg))
        }
        return task
    }
}
