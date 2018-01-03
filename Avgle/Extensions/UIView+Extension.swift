//
//  UIView+Extension.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2018/1/3.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            var tempFrame: CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        } set {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        } set {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
}
