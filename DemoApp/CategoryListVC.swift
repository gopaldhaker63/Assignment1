//
//  CategoryListVC.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

protocol CategoryListDelegate{
    func selectedCategory(_ id: Int, _ selectionType: String)
}

class CategoryListVC: UIViewController {
    
    @IBOutlet weak var tblCategory: UITableView!
    
    var delegate:CategoryListDelegate!
    
    var arrCategories:[CategoryList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.tblCategory.delegate = self
            self.tblCategory.dataSource = self
            self.tblCategory.reloadData()
            self.tblCategory.tableFooterView = UIView()
        }
    }

    @IBAction func btnClosePressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @objc func clickOnInnerProduct(sender:UIButton) {
        self.view.removeFromSuperview()
        self.delegate.selectedCategory(sender.tag, "InnerSubCategory")
    }
    
    @objc func clickOnMainCategory(sender:UIButton) {
        self.view.removeFromSuperview()
        self.delegate.selectedCategory(sender.tag, "Category")
    }
}

extension CategoryListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCategories[section].subCategoryList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrCategories[indexPath.section].subCategoryList[indexPath.row].strName
        cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        let width = cell.frame.size.width
        var Ypos = 0
        
        if arrCategories[indexPath.section].subCategoryList[indexPath.row].isExpand == true{
            cell.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            
            cell.ivArrow.image = UIImage(named: "Img-Drop-Down-Gray")
            
            for (_,object) in                arrCategories[indexPath.section].subCategoryList[indexPath.row].innerSubCategoryList.enumerated(){
                    let btn = UIButton(frame: CGRect(x: 20, y: Ypos, width: Int(width-20), height: 40))
                    btn.tag = object.intId
                    btn.addTarget(self, action: #selector(clickOnInnerProduct(sender:)), for: .touchUpInside)
                    btn.setTitle(object.strName, for: .normal)
                    btn.setTitleColor(.black, for: .normal)
                    Ypos = Ypos + 40
                    cell.stackView.addArrangedSubview(btn)
            }
        }else{
            cell.ivArrow.image = UIImage(named: "Img-Down-Arrow")
            cell.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        }
        
        return cell
    }
    
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblCategory.frame.size.width, height: 40))
        let lblTitle = UILabel(frame: CGRect(x: 10, y: 0, width: self.tblCategory.frame.size.width-20, height: 40))
        lblTitle.text = arrCategories[section].strName
        lblTitle.backgroundColor = UIColor.clear
        let btnTitle = UIButton(frame: CGRect(x: 0, y: 0, width: self.tblCategory.frame.size.width, height: 40))
        btnTitle.tag = arrCategories[section].intId
        btnTitle.addTarget(self, action: #selector(clickOnMainCategory(sender:)), for: .touchUpInside)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnTitle)
        headerView.backgroundColor = UIColor(displayP3Red: 27.0/255.0, green: 100.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tblCategory.reloadData()
        if arrCategories[indexPath.section].subCategoryList[indexPath.row].isExpand == false{
            arrCategories[indexPath.section].subCategoryList[indexPath.row].isExpand = true
        }else{
            arrCategories[indexPath.section].subCategoryList[indexPath.row].isExpand = false
        }        
    }

}
