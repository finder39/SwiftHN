//
//  RoundedLabel.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 31/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

@IBDesignable class RoundedLabel: UILabel {
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.textColor = UIColorEXT.HNColor()
        self.textAlignment = .Center
        self.text = "155"
        self.font = UIFont.systemFontOfSize(12.0)
        
        self.layer.borderColor = UIColorEXT.HNColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
