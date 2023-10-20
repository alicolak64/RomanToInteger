//
//  UIView+Extensions.swift
//  RomanToInteger
//
//  Created by Said Ebrar Çankıran on 19.10.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views : [UIView]){
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
