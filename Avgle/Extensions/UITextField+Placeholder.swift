//
//  UITextField+Placeholder.swift
//  Avgle
//
//  Created by ChenZheng-Yang on 2017/12/28.
//  Copyright © 2017年 ChenCheng-Yang. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: newValue!])
            }
        }
    }
}
