//
//  ViewController.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func showAction(sender: AnyObject) {
        
        //目前有如下问题
        
        //1.顺序不对
        //2.历史重复添加、数量超过8个
        //3.还没做定位
        //4.headerView的高度是写死的
        
        
        
        
        
        let cityVC = CFCityPickerVC.getInstance()
        
//        //设置当前城市
//        cityVC.currentCity = "成都"

        
        //设置热门城市
        cityVC.hotCities = ["北京","上海","广州","成都","杭州","重庆"]
        
        
        let navVC = UINavigationController(rootViewController: cityVC)
        navVC.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.presentViewController(navVC, animated: true, completion: nil)
        
        //解析字典数据
        let cityModels = cityModelsPrepare()
        cityVC.cityModels = cityModels
        
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
        
        
            println("您选中了城市： \(cityModel.name)")
        
        }
        
    }

}






















extension ViewController{
    
    /** 解析字典数据，由于swift中字典转模型工具不完善，这里先手动处理 */
    func cityModelsPrepare() -> [CFCityPickerVC.CityModel]{
        
        //加载plist，你也可以加载网络数据
        let plistUrl = NSBundle.mainBundle().URLForResource("City", withExtension: "plist")!
        let cityArray = NSArray(contentsOfURL: plistUrl) as! [NSDictionary]
        
        var cityModels: [CFCityPickerVC.CityModel] = []
        
        for dict in cityArray{
            let cityModel = parse(dict)
            cityModels.append(cityModel)
        }
        
        return cityModels
    }
    
    func parse(dict: NSDictionary) -> CFCityPickerVC.CityModel{
        
        let id = dict["id"] as! Int
        let pid = dict["pid"] as! Int
        let name = dict["name"] as! String
        let spell = dict["spell"] as! String
        
        let cityModel = CFCityPickerVC.CityModel(id: id, pid: pid, name: name, spell: spell)
        
        let children = dict["children"]
        
        if children != nil { //有子级
            
            var childrenArr: [CFCityPickerVC.CityModel] = []
            for childDict in children as! NSArray {
                
                let childrencityModel = parse(childDict as! NSDictionary)
                
                childrenArr.append(childrencityModel)
            }
            
            cityModel.children = childrenArr
        }
        
        
        return cityModel
    }
    
}

