//
//  CityModel.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation


extension CFCityPickerVC {
    
    class CityModel {
    
        let id: Int
        let pid: Int
        let name: String
        let spell: String
        var children: [CityModel]?
        
        init(id: Int, pid: Int, name: String, spell: String){
            
            self.id = id
            self.pid = pid
            self.name = name
            self.spell = spell
        }
        
        
        
        /** 首字母获取 */
        var getFirstUpperLetter: String {return (self.spell as NSString).substringToIndex(1).uppercaseString}
        
        
        /** 寻找城市模型：单个 */
        class func findCityModelWithCityName(cityNames: [String]?, cityModels: [CityModel]) -> [CityModel]?{
            
            if cityNames == nil {return nil}
            
            var destinationModels: [CityModel]? = []
            
            for name in cityNames!{
                    
                for cityModel in cityModels{
                        
                    if cityModel.children == nil {continue}
                
                    for cityModel2 in cityModel.children! {
                        
                        if cityModel2.name != name {continue}
                        
                        destinationModels?.append(cityModel2)
                    }
                
                }
                
            }
            
            return destinationModels
        }
    }
    
    

    
}