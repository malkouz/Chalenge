//
//  ShopsVM.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation

class ShopsVM: NSObject {

    var shops =  [ShopModel]()
    var branches = [BranchModel]()
    
    
    
    func getShops (completion: ((NSError?) -> Void)?  ){
        DataSource.shared.getShops { [weak self] (error, models) in
            if let models = models{
                self?.shops.append(contentsOf: models)
                
                self?.getBranches(completion: nil)
                
                completion?(nil)
            }else{
                completion?(error)
            }
        }
    }
    
    func getBranches (completion: ((NSError?) -> Void)?  ){
        DataSource.shared.getBrances { [weak self] (error, models) in
            if let models = models{
                self?.branches.append(contentsOf: models)
                completion?(nil)
            }else{
                completion?(error)
            }
        }
    }
    
    
    func getShopName() -> String{
        if shops.count > 0 {
        return shops[0].name!
        }
        return ""
    }
    
    func getShopDesc() -> String{
        if shops.count > 0 {
            return shops[0].desc!
        }
        return ""
    }
    
    func getShopImageURL() -> String?{
        if shops.count > 0 {
            return shops[0].imageURL!
        }
        return nil
    }
    
    func getBranchName(forIndex index: Int) -> String{
        if index >= branches.count{
            return ""
        }
        return branches[index].address!
    }
    
    
    func numberOfRows() -> Int{
        return branches.count
    }
}
