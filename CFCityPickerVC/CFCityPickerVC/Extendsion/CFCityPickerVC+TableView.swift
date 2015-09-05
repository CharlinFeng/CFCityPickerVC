//
//  CFCityPickerVC+TableView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit

extension CFCityPickerVC: UITableViewDataSource,UITableViewDelegate{
    
    var searchH: CGFloat{return 60}
    
    private var currentCityModel: CityModel? {if self.currentCity==nil{return nil};return CityModel.findCityModelWithCityName([self.currentCity], cityModels: self.cityModels, isFuzzy: false)?.first}
    private var hotCityModels: [CityModel]? {if self.hotCities==nil{return nil};return CityModel.findCityModelWithCityName(self.hotCities, cityModels: self.cityModels, isFuzzy: false)}
    private var historyModels: [CityModel]? {if self.selectedCityArray.count == 0 {return nil};return CityModel.findCityModelWithCityName(self.selectedCityArray, cityModels: self.cityModels, isFuzzy: false)}
    
    private var headViewWith: CGFloat{return UIScreen.mainScreen().bounds.width - 10}
    
    private var headerViewH: CGFloat{
        
        var h0: CGFloat = searchH
        var h1: CGFloat = 100
        var h2: CGFloat = 100; if self.historyModels?.count > 4{h2+=40}
        var h3: CGFloat = 100; if self.hotCities?.count > 4 {h3+=40}
        return h0+h1+h2+h3
    }
    
    private var sortedCityModles: [CityModel] {
    
        return cityModels.sorted({ (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
        })
    }
    
    
    /** 计算高度 */
    private func headItemViewH(count: Int) -> CGRect{

        var height: CGFloat = count < 4 ? 90 : 140
        return CGRectMake(0, 0, headViewWith, height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        //vfl
        let viewDict = ["tableView": tableView]
        let vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        let vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        
        self.view.addConstraints(vfl_arr_H)
        self.view.addConstraints(vfl_arr_V)
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
        let location = LocationManager.sharedInstance
        
        location.autoUpdate = true

        location.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            location.stopUpdatingLocation()
            
            location.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
                
                if error != nil {return}
                if placemark == nil {return}
                let city: NSString = (placemark!.locality! as NSString).stringByReplacingOccurrencesOfString("市", withString: "")
                self.currentCity = city as String
                
            })
            
        }
    }
    
    
    
    /** headerView */
    func headerviewPrepare(){
        
        let headerView = UIView()
        
        //搜索框
        searchBar = CitySearchBar()
        headerView.addSubview(searchBar)

        //vfl
        let searchBarViewDict = ["searchBar": searchBar]
        let searchBar_vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-18-[searchBar]-20-|", options: NSLayoutFormatOptions(0), metrics: nil, views: searchBarViewDict)
        let searchBar_vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[searchBar(==36)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: searchBarViewDict)
        headerView.addConstraints(searchBar_vfl_arr_H)
        headerView.addConstraints(searchBar_vfl_arr_V)
        
        searchBar.searchAction = { (searchText: String) -> Void in
        
            println(searchText)
        
        }
        
        searchBar.searchBarShouldBeginEditing = {[unowned self] in
        
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.searchRVC.cityModels = nil
            
            UIView.animateWithDuration(0.15, animations: {[unowned self] () -> Void in
                self.searchRVC.view.alpha = 1
            })
        }
        
        
        searchBar.searchBarDidEndditing = {[unowned self] in
            
            if self.searchRVC.cityModels != nil {return}
            
            self.searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.text = ""
        
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animateWithDuration(0.14, animations: {[unowned self] () -> Void in
                self.searchRVC.view.alpha = 0
            })
        }
        
        searchBar.searchTextDidChangedAction = {[unowned self] (text: String) in
        
            if count(text) == 0 {self.searchRVC.cityModels = nil;return}
            
            let searchCityModols = CityModel.searchCityModelsWithCondition(text, cities: self.cityModels)
            
            self.searchRVC.cityModels = searchCityModols
        }
        
        searchBar.searchBarCancelAction = {[unowned self] in
        
            self.searchRVC.cityModels = nil
            self.searchBar.searchBarDidEndditing?()
        }
        
        //SeatchResultVC
        self.searchRVC = CitySearchResultVC(nibName: "CitySearchResultVC", bundle: nil)
        self.addChildViewController(searchRVC)
        
        self.view.addSubview(searchRVC.view)
        self.view.bringSubviewToFront(searchRVC.view)
        searchRVC.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        //vfl
        let maskViewDict = ["maskView": searchRVC.view]
        let maskView_vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[maskView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: maskViewDict)
        let maskView_vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[maskView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: maskViewDict)
        self.view.addConstraints(maskView_vfl_arr_H)
        self.view.addConstraints(maskView_vfl_arr_V)
        searchRVC.view.alpha = 0
        searchRVC.touchBeganAction = {[unowned self] in
            searchBar.endEditing(true)
        }
        
        searchRVC.tableViewScrollAction = { [unowned self] in
            searchBar.endEditing(true)
        }
        
        searchRVC.tableViewDidSelectedRowAction = {[unowned self] (cityModel: CityModel) in
            
            self.citySelected(cityModel)
        }
        
        
        headerView.frame = CGRectMake(0, 0, headViewWith, headerViewH)
        
        let itemView = HeaderItemView.getHeaderItemView("当前城市")
        currentCityItemView = itemView
        var currentCities: [CityModel] = []
        if self.currentCityModel != nil {currentCities.append(self.currentCityModel!)}
        itemView.cityModles = currentCities
        var frame1 = headItemViewH(itemView.cityModles.count)
        frame1.origin.y = searchH
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
        
        
        self.tableView?.tableHeaderView = headerView
    }
    
    
    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(currentCityName: String){
        
        if self.currentCityModel == nil {return}
        if currentCityItemView?.cityModles.count != 0 {return}
        currentCityItemView?.cityModles = [self.currentCityModel!]
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
    
        return children==nil ? 0 : children!.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = CFCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 44
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return indexHandle()
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {

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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func showIndexTitle(indexTitle: String){

        self.dismissBtn.enabled = false
        self.view.userInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.addSubview(indexTitleLabel)

    }
    
    func dismissIndexTitle(){
        self.dismissBtn.enabled = true
        self.view.userInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(cityModel: CityModel){

        if let cityIndex = find(self.selectedCityArray, cityModel.name) {
            self.selectedCityArray.removeAtIndex(cityIndex)
            
        }else{
            if self.selectedCityArray.count >= 8 {self.selectedCityArray.removeLast()}
        }
        
        self.selectedCityArray.insert(cityModel.name, atIndex: 0)
        
        NSUserDefaults.standardUserDefaults().setObject(self.selectedCityArray, forKey: SelectedCityKey)
        selectedCityModel?(cityModel: cityModel)
        delegate?.selectedCityModel(self, cityModel: cityModel)
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
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        indexTitleLabel.center = self.view.center
    }
    

}

