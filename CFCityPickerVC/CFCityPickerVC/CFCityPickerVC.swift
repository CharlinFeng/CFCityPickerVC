//
//  CFCityPickerVC.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CFCityPickerVC: UITableViewController {

    var cityModels: [CityModel]!
    
    let cityPVCTintColor = UIColor.grayColor()
    
    /** 可设置：当前城市 */
    var currentCity: String!
    
    /** 可设置：热门城市 */
    var hotCities: [String]!
    
    
    lazy var indexTitleLabel: UILabel = {UILabel()}()

    var showTime: CGFloat = 1.0
    
    var indexTitleIndexArray: [Int] = []
    
    var selectedCityModel: ((cityModel: CityModel) -> Void)!
    
    lazy var dismissBtn: UIButton = { UIButton(frame: CGRectMake(0, 0, 24, 24)) }()
    
    lazy var selectedCityArray: [String] = {NSUserDefaults.standardUserDefaults().objectForKey(SelectedCityKey) as? [String] ?? []}()

}


extension CFCityPickerVC{
    
    class func getInstance() -> CFCityPickerVC{
        return CFCityPickerVC(style: UITableViewStyle.Plain)
    }
}