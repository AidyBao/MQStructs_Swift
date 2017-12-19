//
//  SecondViewController.swift
//  MQStructs_Swift
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 MQ. All rights reserved.
//

import UIKit
import ZXAutoScrollView

class SecondViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbSubTitle: UILabel!
    
    @IBOutlet weak var lbBody: UILabel!
    
    @IBOutlet weak var lbMark: UILabel!
    
    @IBOutlet weak var lbIconFont: UILabel!
    
    var scrollView:ZXAutoScrollView!
    lazy var imagePicker = {
        return HImagePickerUtils()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.Nav/HImagePickerUtils
        self.mq_addNavBarButtonItems(textNames: ["相册","拍照"], font: nil, color: UIColor.red, at: .right)
        
        //1.ZXAutoScrollView
        scrollView = ZXAutoScrollView.init(frame: CGRect(x: 50, y: 100, width: UIScreen.main.bounds.width - 100, height: 100))
        scrollView.delegate = self
        scrollView.dataSource = self
        self.view.addSubview(scrollView)
        
        self.lbTitle.font = UIFont.mq_titleFont
        self.lbTitle.text = "Title"
        self.lbTitle.textColor = UIColor.mq_textColorTitle
        
        self.lbSubTitle.font = UIFont.mq_subTitleFont(-1)
        self.lbSubTitle.text = "SubTitle"
        self.lbSubTitle.textColor = UIColor.mq_customCColor
        
        self.lbBody.font = UIFont.mq_bodyFont(14)
        self.lbBody.text = "Body"
        self.lbBody.textColor = UIColor.mq_textColorBody
        
        self.lbMark.font = UIFont.mq_bodyFont(14)
        self.lbMark.text = "Mark"
        self.lbMark.textColor = UIColor.mq_textColorMark
        
        self.lbIconFont.font = UIFont.mq_iconFont(26)  //size 26
        self.lbIconFont.text = "A\u{e673}B"
        self.lbIconFont.textColor = UIColor.mq_customBColor
        
    }
    
    override func mq_keyboardWillHide(duration dt: Double, userInfo: Dictionary<String, Any>) {
        
    }
    
    override func mq_rightBarButtonAction(index: Int) {
        if index == 0 {
            imagePicker.choosePhoto(presentFrom: self, completion: { (image, status) in
                print(status.description())
            })
        } else {
            imagePicker.takePhoto(presentFrom: self, completion: { (image, status) in
                print(status.description())
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SecondViewController: ZXAutoScrollViewDataSource {
    func zxAutoScrollView(_ scollView: ZXAutoScrollView, pageAt index: Int) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.text = "Page:\(index + 1)"
        switch index {
        case 0:
            label.backgroundColor = UIColor.blue
        case 1:
            label.backgroundColor = UIColor.brown
        case 2:
            label.backgroundColor = UIColor.purple
        case 3:
            label.backgroundColor = UIColor.cyan
        case 4:
            label.backgroundColor = UIColor.gray
        default:
            label.backgroundColor = UIColor.black
        }
        return label
    }
    
    func numberofPages(_ inScrollView: ZXAutoScrollView) -> Int {
        return 5
    }
}

extension SecondViewController: ZXAutoScrollViewDelegate {
    func zxAutoScrolView(_ scrollView: ZXAutoScrollView, selectAt index: Int) {
        
        MQAlertUtils.showAlert(withTitle: nil, message: "Selected At:\(index + 1)")
    }
}
