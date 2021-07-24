//
//  RoundedImageView.swift
//  Ghost Network
//
//  Created by MacBook on 24.07.2021.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

}
