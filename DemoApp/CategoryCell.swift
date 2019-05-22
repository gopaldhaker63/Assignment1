//
//  CategoryCell.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivArrow: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
