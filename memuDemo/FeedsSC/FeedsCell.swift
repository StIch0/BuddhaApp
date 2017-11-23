//
//  FeedsCell.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 18/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class FeedsCell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var shortText: UILabel!
    @IBOutlet var dataTime: UILabel!    
    @IBOutlet var spinner: UIActivityIndicatorView!

        
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state            
    }
}
