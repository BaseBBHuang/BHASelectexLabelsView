//
//  UILabel+SizeToFit.swift
//  ToDoDemo
//
//  Created by 乔贝斯 on 2017/9/27.
//  Copyright © 2017年 Mars. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    public func widthOfSizeToFit() -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 0))
        label.text = self.text
        label.font = self.font
        label.sizeToFit()
        return label.frame.size.width
    }
    
    public func heightOfSizeToFit(width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = self.text
        label.font = self.font
        label.numberOfLines = 0
        return label.frame.size.height
    }
    
}
