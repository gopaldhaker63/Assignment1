//
//  SoryByListVC.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

protocol SoryByListDelegate{
    func selectedSortingMethod(_ id: Int)
}

class SoryByListVC: UIViewController {
    
    @IBOutlet weak var constraintHeightAlertView: NSLayoutConstraint!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var alertView: UIView!
    @IBOutlet var tblSortBy: UITableView!
    
    var delegate:SoryByListDelegate!
    
    var eCommerceProducts:ECommerceProducts!
    
    var arrSoryBy:[String] = []
    
    var buttonHandler:((_ sender:UIButton)->())!
    
    private var tapGesture:UITapGestureRecognizer!

    //MARK: - UIViewController Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 8.0
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 3, height: 3)
        alertView.layer.shadowOpacity = 0.2
        alertView.layer.shadowRadius = 4.0
        alertView.clipsToBounds = true
        
        for ranking in eCommerceProducts.rankings {
            self.arrSoryBy.append(ranking.ranking)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTapGesture()
        self.tblSortBy.separatorColor = UIColor.gray
        
    }
    
    override func viewDidLayoutSubviews(){
        
        var height  = arrSoryBy.count * 40
        
        if height > 300{
            height = 300
            self.tblSortBy.isScrollEnabled = true
        }else{
            self.tblSortBy.isScrollEnabled = false
        }
        
        constraintHeightAlertView.constant = CGFloat(height)
        tblSortBy.reloadData()
    }
    
    //MARK: - IBAction Methods -
    @IBAction func btnClosePressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    //MARK: - Private Methods -
    
    /// This method used to add custom alert view into window
    ///
    /// - Parameter type: AlertType
    func presentCustomAlert(){
        self.view.frame = UIScreen.main.bounds
        AppDelegate.shared.window?.addSubview(self.view!)
    }
    
    /// This method is used to add tapgesture on backgroundview
    private func addTapGesture(){
        if tapGesture != nil{
            viewContainer.removeGestureRecognizer(tapGesture)
            tapGesture = nil
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.viewContainer.isUserInteractionEnabled = true
        self.viewContainer.addGestureRecognizer(tapGesture)
    }
    
    /// This method used to handle tap gesture
    ///
    /// - Parameter gesture: gesture
    @objc func handleTap(gesture:UITapGestureRecognizer){
        let location = gesture.location(in: self.tblSortBy)
        let indexPath = self.tblSortBy.indexPathForRow(at: location)
        if indexPath != nil{
            delegate.selectedSortingMethod((indexPath?.row)!)
        }
        self.view.removeFromSuperview()
        
    }

}

extension SoryByListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSoryBy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortByListCell") as! SortByListCell
        cell.lblSortByTitle.text =  "\(arrSoryBy[indexPath.row])"
        cell.lblSortByTitle.font = UIFont.systemFont(ofSize: 16.0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
