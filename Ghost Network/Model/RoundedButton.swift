//
//  RoundedButton.swift
//  Ghost Network
//
//  Created by MacBook on 25.07.2021.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.layer.cornerRadius = 30
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
    }
}
