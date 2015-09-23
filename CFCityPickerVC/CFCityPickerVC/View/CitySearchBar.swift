//
//  CitySearchBar.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CitySearchBar: UISearchBar,UISearchBarDelegate {
    
    var searchBarShouldBeginEditing: (()->())?
    var searchBarDidEndditing: (()->())?
    
    var searchAction: ((searchText: String)->Void)?
    var searchTextDidChangedAction: ((searchText: String)->Void)?
    var searchBarCancelAction: (()->())?
    
    
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
        self.backgroundColor = UIColor.clearColor()
        self.backgroundImage = UIImage()
        self.layer.borderColor = CFCityPickerVC.cityPVCTintColor.CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = "输出城市名、拼音或者首字母查询"
        self.tintColor = CFCityPickerVC.cityPVCTintColor
        
        self.delegate = self
    }
}

extension CitySearchBar{
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarShouldBeginEditing?()
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBarDidEndditing?()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarCancelAction?()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchAction?(searchText: searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTextDidChangedAction?(searchText: searchText)
    }
}




