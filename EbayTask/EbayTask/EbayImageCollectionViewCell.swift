//
//  EbayImageCollectionViewCell.swift
//  EbayTask
//
//  Created by Matthew Lewis on 7/26/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import UIKit

class EbayImageCollectionViewCell: UICollectionViewCell {
    
    var ebayImage  : UIImageView?
    
    static let EbayImageCollectionViewCellIndentifer = "EbayImageCollectionViewCellIndentifer"
    
    override init(frame: CGRect) {
        self.ebayImage = UIImageView()
        super.init(frame: frame)
        self.ebayImage?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(self.ebayImage!)
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateWithImage(ebayImage : EbayImage) {
   
        self.ebayImage?.contentMode = .scaleToFill
        self.ebayImage?.image = ebayImage.image
        
    }

}
