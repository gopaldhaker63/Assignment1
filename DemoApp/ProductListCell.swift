//
//  ProductListCell.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var viewColors: UIView!
    @IBOutlet weak var lblAvailableColors: UILabel!
    @IBOutlet weak var constraintHeightLblAvailableSize: NSLayoutConstraint!
    @IBOutlet weak var lblAvailableSize: UILabel!
    @IBOutlet weak var constraintHeightAvailableSize: NSLayoutConstraint!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var lblProductViews: UILabel!
    @IBOutlet weak var lblProductOrder: UILabel!
    @IBOutlet weak var lblProductShared: UILabel!
    @IBOutlet weak var viewOuter: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
