//
//  CityMaskView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CityMaskView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /** 视图准备 */
        self.viewPrepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /** 视图准备 */
        self.viewPrepare()
    }
    
    /** 视图准备 */
    func viewPrepare(){
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

}
