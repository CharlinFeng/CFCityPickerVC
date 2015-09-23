//
//  HeaderItemView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class HeaderItemView: UIView {

    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewHC: NSLayoutConstraint!

    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var contentView: CFCPContentView!
    
    var cityModles: [CFCityPickerVC.CityModel]!{didSet{dataCome()}}
}


extension HeaderItemView{
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        lineViewHC.constant = 0.5
    }
    
    func dataCome(){
        self.msgLabel.hidden = cityModles.count != 0
        self.contentView.cityModles = cityModles
    }
    
    
    class func getHeaderItemView(title: String) -> HeaderItemView{
        
        let itemView = NSBundle.mainBundle().loadNibNamed("HeaderItemView", owner: nil, options: nil).first as! HeaderItemView
        itemView.itemLabel.text = title
        
        return itemView
    }
}


extension CFCPContentView{
    
    class ItemBtn: UIButton {
        
        var cityModel: CFCityPickerVC.CityModel!
    
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
            
            self.setTitleColor(CFCityPickerVC.rgba(31, g: 31, b: 31, a: 1), forState: UIControlState.Normal)
            self.setTitleColor(CFCityPickerVC.rgba(141, g: 141, b: 141, a: 1), forState: UIControlState.Highlighted)
            self.titleLabel?.font = UIFont.systemFontOfSize(15)
            self.layer.cornerRadius = 4
            self.layer.masksToBounds = true
            self.backgroundColor = CFCityPickerVC.rgba(241, g: 241, b: 241, a: 1)
        }
    }
    
}


class CFCPContentView: UIView{
    
    var cityModles: [CFCityPickerVC.CityModel]!{didSet{btnsPrepare()}}
    
    let maxRowCount = 4
    var btns: [ItemBtn] = []
    
    
    
    /** 添加按钮 */
    func btnsPrepare(){
        
        if cityModles == nil {return}
        
        for cityModel in cityModles{
            
            let itemBtn = ItemBtn()
            itemBtn.setTitle(cityModel.name, forState: UIControlState.Normal)
            itemBtn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            btns.append(itemBtn)
            itemBtn.cityModel = cityModel
            self.addSubview(itemBtn)
        }
    }
    
    
    /** 按钮点击事件 */
    func btnClick(btn: ItemBtn){
        
        NSNotificationCenter.defaultCenter().postNotificationName(CityChoosedNoti, object: nil, userInfo: ["citiModel":btn.cityModel])
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if btns.count == 0 {return}
        let marginForRow: CGFloat = 16.0
        let marginForCol: CGFloat = 13
        let width: CGFloat = (self.bounds.size.width - (CGFloat(maxRowCount - 1)) * marginForRow) / CGFloat(maxRowCount)
        
        let height: CGFloat = 30
        for (index,btn) in btns.enumerate() {
            
            let row = index % maxRowCount
            
            let col = index / maxRowCount
            
            let x = (width + marginForRow) * CGFloat(row)
            let y = (height + marginForCol) * CGFloat(col)
            
            btn.frame = CGRectMake(x, y, width, height)
        }
    }
    
}



