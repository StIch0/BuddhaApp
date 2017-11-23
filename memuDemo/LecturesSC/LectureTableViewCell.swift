//
//  LectureTableViewCell.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 29/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class LectureTableViewCell: UITableViewCell {


    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var shortTextLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var img: UIImageView!        
    @IBOutlet var imgHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
