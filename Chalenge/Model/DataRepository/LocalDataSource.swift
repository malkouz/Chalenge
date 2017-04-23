//
//  LocalDataSource.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation

class LocalDataSource: NSObject, DataSourceProtocol {

    func getShops (completion: ((NSError?, [ShopModel]?) -> Void)?  ){
        
        if let models = LocalContext.shared.getRecords(ShopModel.self) as? [ShopModel]{
            completion?(nil, models)
        }else{
            let error = NSError()
            completion?(error, nil)
        }
    }
    
    func getBrances (completion: ((NSError?, [BranchModel]?) -> Void)?  ){
        if let models = LocalContext.shared.getRecords(BranchModel.self) as? [BranchModel]{
            completion?(nil, models)
        }else{
            let error = NSError()
            completion?(error, nil)
        }
    }
}
