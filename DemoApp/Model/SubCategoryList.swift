//
//  SubCategoryList.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class SubCategoryList: NSObject {
    var intId: Int = 0
    var strName: String = ""
    var innerSubCategoryList: [InnerSubCategoryList] = [InnerSubCategoryList()]
    var isExpand: Bool = false

}
