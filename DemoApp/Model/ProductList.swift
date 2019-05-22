//
//  ProductList.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class ProductList: NSObject {
    var intCategoryId: Int = 0
    var intSubCategoryId: Int = 0
    var intInnerSubCategoryId: Int = 0
    var intProductId: Int = 0
    var strProductName: String = ""
    var strProductDateAdded: String = ""
    var productVarientList: [Variant] = []
    var productTax: Tax?
    var intProductViewCount: Int = 0
    var intProductOrderCount: Int = 0
    var intProductShareCount: Int = 0
}
