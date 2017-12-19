//
//  FirstViewController.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //上拉刷新、下拉刷新的使用
        self.tableView.mq_addHeaderRefresh(showGif: true, target: self, action: #selector(headerFresh))
        
        self.tableView.mq_addFooterRefresh(autoRefresh: true, target: self, action: #selector(footerFresh))
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func headerFresh() {
        self.tableView.mj_header.endRefreshing()
    }
    
    @objc func footerFresh() {
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    //MARK:- 例子
    /**
     *1.MQNetwork的使用
     *2.MQHUD的使用
     *3.MQEmptyView的使用
    */
    func requestForTest() {
        MQHUD.showLoading(in: self.view, text: MQ_LOADING_TEXT, delay: nil)
        MQNetwork.asyncRequest(withUrl: MQAPI.api(address: MQAPIConst.Store.home), params: ["":"","":""], method: .post) { (succ, code, content, string, errMsg) in
            MQHUD.hide(for: self.view, animated: true)
            MQEmptyView.hide(from: self.view)
            if succ {
                if code == MQAPI_SUCCESS {
                    MQHUD.showSuccess(in: self.view, text: "成功", delay: MQ.HUDDelay)
                }else{
                    MQHUD.showFailure(in: self.view, text: "失败", delay: MQ.HUDDelay)
                }
            }else if code != MQAPI_LOGIN_INVALID{
                MQEmptyView.show(in: self.view, type: .noData, text: "暂无数据", retry: {
                    MQEmptyView.hide(from: self.view)
                    self.requestForTest()
                })
            }
        }
    }
}
