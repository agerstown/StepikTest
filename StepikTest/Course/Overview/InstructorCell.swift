//
//  InstructorCell.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/10/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class InstructorCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewPhoto.layer.cornerRadius = imageViewPhoto.frame.height / 2
    }
    
}
