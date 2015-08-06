//
//  CFCityPickerVC+Main.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit


extension CFCityPickerVC {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /** 返回按钮 */
        dismissBtnPrepare()
        
        /** 为tableView准备 */
        tableViewPrepare()
        
        /** 处理label */
        labelPrepare()
        
        self.tableView.sectionIndexColor = CFCityPickerVC.cityPVCTintColor
        
        /** headerView */
        headerviewPrepare()
        
        /** 定位处理 */
        locationPrepare()
        
        //通知处理
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notiAction:", name: CityChoosedNoti, object: nil)
    }
    
    /** 返回按钮 */
    func dismissBtnPrepare(){
        
        dismissBtn.setImage(UIImage(named: "img.bundle/cancel"), forState: UIControlState.Normal)
        dismissBtn.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissBtn)
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}