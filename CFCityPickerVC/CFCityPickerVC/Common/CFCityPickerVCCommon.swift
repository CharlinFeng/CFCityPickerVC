//
//  CFCommon.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit

/** 通知 */
let CityChoosedNoti = "CityChoosedNoti"

/** 归档key */
let SelectedCityKey = "SelectedCityKey"

extension CFCityPickerVC{
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    

}

