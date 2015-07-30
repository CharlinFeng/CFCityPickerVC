//
//  CFCityPickerVC+TableView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit

extension CFCityPickerVC{
    
    var currentCityModel: CityModel? {if self.currentCity==nil{return nil};return CityModel.findCityModelWithCityName([self.currentCity], cityModels: self.cityModels)?.first}
    var hotCityModels: [CityModel]? {if self.hotCities==nil{return nil};return CityModel.findCityModelWithCityName(self.hotCities, cityModels: self.cityModels)}
    var historyModels: [CityModel]? {if self.selectedCityArray.count == 0 {return nil};return CityModel.findCityModelWithCityName(self.selectedCityArray, cityModels: self.cityModels)}
    
    var headViewWith: CGFloat{return UIScreen.mainScreen().bounds.width - 10}
    
    
    var sortedCityModles: [CityModel] {
    
        return cityModels.sorted({ (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
        })
    }
    
    
    /** 计算高度 */
    func headItemViewH(count: Int) -> CGRect{
        var height: CGFloat = count < 4 ? 90 : 140
        return CGRectMake(0, 0, headViewWith, height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
        /** 处理label */
        labelPrepare()
        
        self.tableView.sectionIndexColor = cityPVCTintColor
        
        /** headerView */
        headerviewPrepare()
        
        /** 定位处理 */
        locationPrepare()
        
        //通知处理
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notiAction:", name: CityChoosedNoti, object: nil)
        
        println(self.selectedCityArray)
    }
    
    
    func notiAction(noti: NSNotification){
        
        let userInfo = noti.userInfo as! [String: CityModel]
        let cityModel = userInfo["citiModel"]!
        citySelected(cityModel)
    }
    
    
    
    
    
    /** 定位处理 */
    func locationPrepare(){
        
        if self.currentCity != nil {return}
        
        //定位开始
    }
    
    
    
    /** headerView */
    func headerviewPrepare(){
        
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, headViewWith, 420)
        
        
        
        let itemView = HeaderItemView.getHeaderItemView("当前城市")
        var currentCities: [CityModel] = []
        if self.currentCityModel != nil {currentCities.append(self.currentCityModel!)}
        itemView.cityModles = currentCities
        var frame1 = headItemViewH(itemView.cityModles.count)
        frame1.origin.y = 20
        itemView.frame = frame1
        headerView.addSubview(itemView)
        
        
        let itemView2 = HeaderItemView.getHeaderItemView("历史选择")
        var historyCityModels: [CityModel] = []
        if self.historyModels != nil {historyCityModels += self.historyModels!}
        itemView2.cityModles = historyCityModels
        var frame2 = headItemViewH(itemView2.cityModles.count)
        frame2.origin.y = CGRectGetMaxY(frame1)
        itemView2.frame = frame2
        headerView.addSubview(itemView2)
        
        
        
        let itemView3 = HeaderItemView.getHeaderItemView("热门城市")
        var hotCityModels: [CityModel] = []
        if self.hotCityModels != nil {hotCityModels += self.hotCityModels!}
        itemView3.cityModles = hotCityModels
        var frame3 = headItemViewH(itemView3.cityModles.count)
        frame3.origin.y = CGRectGetMaxY(frame2)
        itemView3.frame = frame3
        headerView.addSubview(itemView3)
        
        
        self.tableView.tableHeaderView = headerView
    }
    
    
    
    
    
    
    

    
    /** 处理label */
    func labelPrepare(){
        
        indexTitleLabel.backgroundColor = CFCityPickerVC.rgba(0, g: 0, b: 0, a: 0.4)
        indexTitleLabel.center = self.view.center
        indexTitleLabel.bounds = CGRectMake(0, 0, 120, 100)
        indexTitleLabel.font = UIFont.boldSystemFontOfSize(80)
        indexTitleLabel.textAlignment = NSTextAlignment.Center
        indexTitleLabel.textColor = UIColor.whiteColor()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
    
        return children==nil ? 0 : children!.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = CFCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 44
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return indexHandle()
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {

        showIndexTitle(title)
        
        self.showTime = 1
 
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in

            self.showTime = 0.8

        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
      
            if self.showTime == 0.8 {
                
                self.showTime = 0.6
            }
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.6 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
         
            if self.showTime == 0.6 {
                
                self.showTime = 0.4
            }
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            

            if self.showTime == 0.4 {
                
                self.showTime = 0.2
            }
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
 
            if self.showTime == 0.2 {
               
                self.dismissIndexTitle()
            }
            
            
        })
        
        return indexTitleIndexArray[index]
    }
    

    func showIndexTitle(indexTitle: String){

        self.dismissBtn.enabled = false
        self.view.userInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.window?.addSubview(indexTitleLabel)

    }
    
    func dismissIndexTitle(){
        self.dismissBtn.enabled = true
        self.view.userInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(cityModel: CityModel){
        
//        self.selectedCityArray.insert(cityModel.name, atIndex: 0)
        self.selectedCityArray.append(cityModel.name)
        
        NSUserDefaults.standardUserDefaults().setObject(self.selectedCityArray, forKey: SelectedCityKey)
        selectedCityModel?(cityModel: cityModel)
        self.dismiss()
    }
    
}



extension CFCityPickerVC{

    /** 处理索引 */
    func indexHandle() -> [String] {
        
        var indexArr: [String] = []
        
        for (index,cityModel) in enumerate(sortedCityModles) {
            let indexString = cityModel.getFirstUpperLetter
            
            if contains(indexArr, indexString) {continue}
            
            indexArr.append(indexString)
            
            indexTitleIndexArray.append(index)
        }
        
        return indexArr
    }
    
    

}

