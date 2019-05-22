//
//  ViewController.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var btnSoryBy: UIButton!
    
    @IBOutlet weak var tblProducts: UITableView!
    
    var arrCategories:[CategoryList] = []
    
    var arrProductList:[ProductList] = []
    
    var arrFilteredProductList:[ProductList] = []
    
    var categoryListVC = CategoryListVC()
    
    var sortByListVC = SoryByListVC()
    
    var eCommerceProducts:ECommerceProducts!
    
    let defaults = UserDefaults.standard
    
    private var act = UIActivityIndicatorView()
    
    // MARK: - UIViewController Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        act.frame = CGRect(x: UIScreen.main.bounds.width/2 - 15, y: UIScreen.main.bounds.height/2 - 15, width: 30, height: 30)
        act.style = .gray
        
        if let eCommerceProducts = defaults.object(forKey: "StoredECommerceProducts") as? Data {
            let decoder = JSONDecoder()
            if let eCommerceProducts = try? decoder.decode(ECommerceProducts.self, from: eCommerceProducts) {
                self.getCategoryAndProductList(eCommerceProducts)
            }
        } else {
            callProductAPI()
        }
    }
    
    // MARK: - IBAction Methods -
    
    /// Event on button category pressed to add category list view
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnCategoryPressed(_ sender: Any) {
        categoryListVC = (AppDelegate.storyboard.instantiateViewController(withIdentifier: "CategoryListVC") as? CategoryListVC)!
        var frame = UIScreen.main.bounds
        frame.size.width = UIScreen.main.bounds.size.width-40
        frame.origin.x = 20
        categoryListVC.view.frame = frame//UIScreen.main.bounds
        categoryListVC.delegate = self
        categoryListVC.arrCategories = self.arrCategories
        AppDelegate.shared.window?.addSubview(categoryListVC.view)
        
    }
    
    /// Event on button sort by pressed to add sort by list view
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnSoryByPressed(_ sender: Any) {
        sortByListVC = (AppDelegate.storyboard.instantiateViewController(withIdentifier: "SoryByListVC") as? SoryByListVC)!
        sortByListVC.eCommerceProducts = self.eCommerceProducts
        sortByListVC.view.frame = UIScreen.main.bounds
        sortByListVC.delegate = self
        AppDelegate.shared.window?.addSubview(sortByListVC.view)
    }
    
    // MARK: - Private Methods -
    /// Method to call api
    func callProductAPI() {
        self.addActivityIndicator()
        let parser = ECommerceProductsParser()
        parser.callAPI([:]) { (eCommerceProducts, status, message) in
            self.removeActivityIndicator()
            if eCommerceProducts != nil {
                self.setObjectInPreference(eCommerceProducts!)
                self.getCategoryAndProductList(eCommerceProducts)
            }
        }
    }
    
    /// Method to fetch category list with its subcategeory and its innersubcategory and product list
    ///
    /// - Parameter eCommerceProducts: Object of ECommerceProducts
    func getCategoryAndProductList(_ eCommerceProducts:ECommerceProducts?) {
        self.eCommerceProducts = eCommerceProducts
        
        var arrTempCategories:[CategoryList] = []
        
        let allCategory = CategoryList()
        allCategory.intId = -1
        allCategory.strName = "All"
        allCategory.subCategoryList = []
        
        arrTempCategories.append(allCategory)
        
        for category in (eCommerceProducts?.categories)! {
            if category.childCategories.count > 0 {
                var arrSubCategory:[SubCategoryList] = []
                let categoryList = CategoryList()
                categoryList.intId = category.id
                categoryList.strName = category.name
                for childCategory in category.childCategories {
                    var arrInnerSubCategory:[InnerSubCategoryList] = []
                    let subCategoryList = SubCategoryList()
                    let arrFilteredCategory = eCommerceProducts?.categories.filter{$0.id == childCategory}
                    let filteredCategory = arrFilteredCategory?[0]
                    subCategoryList.intId = (filteredCategory?.id)!
                    subCategoryList.strName = (filteredCategory?.name)!
                    if filteredCategory?.childCategories.count ?? 0 > 0 {
                        for innerChildCategory in (filteredCategory?.childCategories)! {
                            let innerSubCategoryList = InnerSubCategoryList()
                            let arrFilteredInnerCategory = eCommerceProducts?.categories.filter{$0.id == innerChildCategory}
                            let filteredCategory = arrFilteredInnerCategory?[0]
                            innerSubCategoryList.intId = (filteredCategory?.id)!
                            innerSubCategoryList.strName = (filteredCategory?.name)!
                            arrInnerSubCategory.append(innerSubCategoryList)
                        }
                    }
                    subCategoryList.innerSubCategoryList = arrInnerSubCategory
                    
                    arrSubCategory.append(subCategoryList)
                }
                categoryList.subCategoryList = arrSubCategory
                arrTempCategories.append(categoryList)
            }
        }
        
        self.arrCategories = arrTempCategories
        
        for tempCategoryList in arrTempCategories {
            for subCategory in tempCategoryList.subCategoryList {
                let arrFilteredSubCategory = arrTempCategories.filter{$0.intId == subCategory.intId}
                if arrFilteredSubCategory.count > 0 {
                    let index = self.arrCategories.firstIndex(of: arrFilteredSubCategory[0])
                    self.arrCategories.remove(at: index!)
                }
            }
        }
        
        for category in (eCommerceProducts?.categories)! {
            for product in category.products {
                let productList = ProductList()
                for categoryList in self.arrCategories {
                    for subCategory in categoryList.subCategoryList {
                        for innerCategory in subCategory.innerSubCategoryList {
                            if innerCategory.intId == category.id {
                                productList.intCategoryId = categoryList.intId
                                productList.intSubCategoryId = subCategory.intId
                            }
                        }
                    }
                }
                                
                productList.intInnerSubCategoryId = category.id
                productList.intProductId = product.id
                productList.strProductName = product.name
                productList.strProductDateAdded = product.dateAdded
                productList.productVarientList = product.variants
                productList.productTax = product.tax
                
                let allProductRankingForView = eCommerceProducts?.rankings[0]
                let allProductRankingForOrder = eCommerceProducts?.rankings[1]
                let allProductRankingForShare = eCommerceProducts?.rankings[2]
                
                
                if allProductRankingForView?.ranking == "Most Viewed Products" {
                    let arrFilteredRanking = allProductRankingForView?.products.filter{$0.id == product.id}
                    if arrFilteredRanking?.count ?? 0 > 0 {
                        let filteredValue = arrFilteredRanking?[0]
                        productList.intProductViewCount = filteredValue?.viewCount ?? 0
                    }
                }
                
                if allProductRankingForOrder?.ranking == "Most OrdeRed Products" {
                    let arrFilteredRanking = allProductRankingForOrder?.products.filter{$0.id == product.id}
                    if arrFilteredRanking?.count ?? 0 > 0 {
                        let filteredValue = arrFilteredRanking?[0]
                        productList.intProductOrderCount = filteredValue?.orderCount ?? 0
                    }
                }
                
                if allProductRankingForShare?.ranking == "Most ShaRed Products" {
                    let arrFilteredRanking = allProductRankingForShare?.products.filter{$0.id == product.id}
                    if arrFilteredRanking?.count ?? 0 > 0 {
                        let filteredValue = arrFilteredRanking?[0]
                        productList.intProductShareCount = filteredValue?.shares ?? 0
                    }
                }
                
                self.arrProductList.append(productList)
            }
        }
        
        self.arrFilteredProductList = self.arrProductList
        
        //Initally product list display in sorted according to ordered value
        self.arrFilteredProductList = self.arrFilteredProductList.sorted { $0.intProductOrderCount > $1.intProductOrderCount }
        
        self.reloadTable()
    }
    
    /// Method to set eCommerceProducts data into preference
    ///
    /// - Parameter eCommerceProducts: Object of ECommerceProducts
    func setObjectInPreference(_ eCommerceProducts: ECommerceProducts) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(eCommerceProducts) {
            defaults.set(encoded, forKey: "StoredECommerceProducts")
        }
    }
    
    /// Methos to reload tableview
    func reloadTable() {
        DispatchQueue.main.async {
            self.tblProducts.reloadData()
        }
    }
    
    /// Method to remove duplicate color string from array of color
    ///
    /// - Parameter arrColor: Array of color string
    /// - Returns: Array of color string
    func removeDuplicatesColorString(_ arrColor: inout [String]) -> [String] {
        arrColor = Set(arrColor).sorted()
        return arrColor
    }

    /// Methos to remove duplicate product size from array of size
    ///
    /// - Parameter arrSize: Array of size
    /// - Returns: Array of size
    func removeDuplicatesSize(_ arrSize: inout [Int]) -> [Int] {
        arrSize = Set(arrSize).sorted()
        return arrSize
    }
    
    /// Fetch the color from color string
    ///
    /// - Parameter colorName: color string
    /// - Returns: Color object
    func getColorUsingString(_ colorName: String) -> UIColor {
        switch colorName {
        case "blue":
            return UIColor.blue
        case "red":
            return UIColor.red
        case "green":
            return UIColor.green
        case "light blue":
            return UIColor.cyan
        case "white":
            return UIColor.white
        case "yellow":
            return UIColor.yellow
        case "grey":
            return UIColor.gray
        case "brown":
            return UIColor.brown
        case "silver":
            return UIColor.init(white: 192.0/255.0, alpha: 1.0)
        case "golden":
            return UIColor.init(red: 255.0/255.0, green: 223.0/255.0, blue: 0/255.0, alpha: 1.0)
        default:
            return UIColor.black
        }
    }
    
    /// Method to add activity indicator
    func addActivityIndicator() {
        self.view.addSubview(act)
        act.startAnimating()
    }
    
    /// Method to remove activity indicator
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.act.stopAnimating()
            self.act.removeFromSuperview()
        }
    }

}

// MARK: - TableView Delegate Methods -
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell") as! ProductListCell
        let productList = self.arrFilteredProductList[indexPath.row]
        cell.lblProductName.text = productList.strProductName
        cell.lblProductName.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.lblProductPrice.text = "Price : Rs\(productList.productVarientList[0].price)"
        var arrAvailableColor:[String] = []
        
        for varients in productList.productVarientList {
            arrAvailableColor.append(varients.color)
        }
        
        cell.viewColors.backgroundColor = .white
        cell.viewColors.layer.cornerRadius = 8.0
        cell.viewColors.layer.shadowColor = UIColor.black.cgColor
        cell.viewColors.layer.shadowOffset = CGSize(width: 3, height:3)
        cell.viewColors.layer.shadowOpacity = 0.2
        cell.viewColors.layer.shadowRadius = 6.0
        
        cell.viewSize.backgroundColor = .white
        cell.viewSize.layer.cornerRadius = 8.0
        cell.viewSize.layer.shadowColor = UIColor.black.cgColor
        cell.viewSize.layer.shadowOffset = CGSize(width: 3, height:3)
        cell.viewSize.layer.shadowOpacity = 0.2
        cell.viewSize.layer.shadowRadius = 6.0
        
        cell.viewOuter.layer.cornerRadius = 12.0
        cell.viewOuter.layer.shadowColor = UIColor.black.cgColor
        cell.viewOuter.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.viewOuter.layer.shadowOpacity = 0.2
        cell.viewOuter.layer.shadowRadius = 6.0
        
        arrAvailableColor = self.removeDuplicatesColorString(&arrAvailableColor)
        
        if arrAvailableColor.count > 0 {
            var xPosColor = 0
            
            for view in cell.viewColors.subviews {
                view.removeFromSuperview()
            }
            
            for object in arrAvailableColor.enumerated(){
                let btn = UIButton(frame: CGRect(x: 5 + xPosColor, y: 5, width: 30, height: 30))
                xPosColor = xPosColor + 40
                btn.backgroundColor = self.getColorUsingString(object.element.lowercased())
                btn.layer.cornerRadius = 15
                btn.layer.borderColor = UIColor.black.cgColor
                btn.layer.borderWidth = 1.0
                cell.viewColors.addSubview(btn)
            }
        } else {
            for view in cell.viewColors.subviews {
                view.removeFromSuperview()
            }
        }
        
        var arrAvailableSize:[Int] = []
        
        for varients in productList.productVarientList {
            if let size = varients.size {
                arrAvailableSize.append(size)
            }
        }
        
        arrAvailableSize = self.removeDuplicatesSize(&arrAvailableSize)
        
        if arrAvailableSize.count > 0 {
            cell.lblAvailableSize.isHidden = false
            cell.constraintHeightLblAvailableSize.constant = 21
            cell.constraintHeightAvailableSize.constant = 40
            arrAvailableSize = arrAvailableSize.sorted()
            var xPosSize = 0
            
            for view in cell.viewSize.subviews {
                view.removeFromSuperview()
            }
            
            for object in arrAvailableSize.enumerated(){
                let btn = UIButton(frame: CGRect(x: 5 + xPosSize, y: 5, width: 30, height: 30))
                xPosSize = xPosSize + 40
                btn.setTitle("\(object.element)", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .black
                btn.layer.cornerRadius = 15
                btn.layer.borderColor = UIColor.black.cgColor
                btn.layer.borderWidth = 1.0
                cell.viewSize.addSubview(btn)
            }
        } else {
            for view in cell.viewSize.subviews {
                view.removeFromSuperview()
            }
            cell.lblAvailableSize.isHidden = true
            cell.constraintHeightLblAvailableSize.constant = 0
            cell.constraintHeightAvailableSize.constant = 0
        }
        
        cell.lblProductViews.text = "Views : \(productList.intProductViewCount)"
        cell.lblProductOrder.text = "Ordered : \(productList.intProductOrderCount)"
        cell.lblProductShared.text = "Shared : \(productList.intProductShareCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - CategoryListDelegate Methods -
extension ViewController: CategoryListDelegate {
    func selectedCategory(_ id: Int, _ selectionType: String) {
        
        switch selectionType {
        case "Category":
            if id == -1 {
                self.arrFilteredProductList = self.arrProductList
                self.reloadTable()
            } else {
                self.arrFilteredProductList = self.arrProductList.filter{$0.intCategoryId == id}
                if arrFilteredProductList.count > 0 {
                    self.reloadTable()
                }
            }
            break
            self.arrFilteredProductList = self.arrProductList.filter{$0.intInnerSubCategoryId == id}
            if arrFilteredProductList.count > 0 {
                self.reloadTable()
            }
            break
        default:
            break
        }
        
        
    }    
}

// MARK: - CategoryListDelegate Methods -
extension ViewController: SoryByListDelegate {
    func selectedSortingMethod(_ id: Int) {
        let ranking = self.eCommerceProducts.rankings[id]
        
        switch ranking.ranking {
        case "Most Viewed Products":
            self.arrFilteredProductList = self.arrFilteredProductList.sorted { $0.intProductViewCount > $1.intProductViewCount }
            self.reloadTable()
            break
            
        case "Most OrdeRed Products":
            self.arrFilteredProductList = self.arrFilteredProductList.sorted { $0.intProductOrderCount > $1.intProductOrderCount }
            self.reloadTable()
            break
            
        case "Most ShaRed Products":
            self.arrFilteredProductList = self.arrFilteredProductList.sorted { $0.intProductShareCount > $1.intProductShareCount }
            self.reloadTable()
            break
        default:
            break
        }
    }
}

