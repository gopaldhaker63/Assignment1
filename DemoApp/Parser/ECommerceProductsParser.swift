//
//  ECommerceProductsParser.swift
//  SAT
//
//  Created by Avinay on 17/05/19.
//  Copyright © 2019 Avinay. All rights reserved.
//

import UIKit

class ECommerceProductsParser: NSObject {
    
    /// Completion Handler for passing result to back
    //typealias APICompletionHandler = ((_ data:ECommerceProducts?,_ success:Bool,_ message:String?)->())
    typealias APICompletionHandler = ((_ data:ECommerceProducts?,_ success:Bool,_ message:String?)->())
    
    private var request:URLRequest!
    
    func callAPI(_ data: [String : Any]?, completion: @escaping APICompletionHandler) {
        
        let strURL = "https://stark-spire-93433.herokuapp.com/json"
//        let strURL = "http://192.168.0.10/~avinay/demo.json"
        
        request = URLRequest(url: URL(string:strURL)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error == nil){
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        if(data != nil){
                            self.parseData(data: data!, completion: completion)
                        }else{
                            DispatchQueue.main.async {
                                completion(nil,false,"Failed to get response")
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion(nil,false,"Failed to get response")
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil,false,"Failed to get response")
                }
            }
        }
        dataTask.resume()
    }
    
    func parseData(data: Data, completion: @escaping APICompletionHandler) {
        let eCommerceProducts : ECommerceProducts?
        do {
            eCommerceProducts = try JSONDecoder().decode(ECommerceProducts.self, from: data)
            completion(eCommerceProducts,true,"Parsed Sucessful")
        } catch  {
            completion(nil,false,"Failed to get response")
        }
    }
    
}

