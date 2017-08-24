//
//  MQNavigationViewController.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit

class MQNavigationViewController: UINavigationController {
    
//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//        self.setNavigationStyle()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationStyle()
    }
    
    
    final func setNavigationStyle() {
        self.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.blue
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = {[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)]}()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MQNavigationViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
