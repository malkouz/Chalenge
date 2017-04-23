//
//  RemoteDataSource.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation
import SwiftyJSON
class RemoteDataSource: NSObject, DataSourceProtocol {
    func getShops (completion: ((NSError?, [ShopModel]?) -> Void)?  ){
        let endPoint = EndPoint(address: .getShops, headers: nil, httpMethod: .get)
        
        RemoteContext.shared.request(endPoint: endPoint, parameters: nil, handleError: true) { (success, data) in
            if success{
                if let json = data as? JSON{
                
                    let models = DataParser().parseShops(json: json)
                    completion?(nil, models)
                }
            }else{
                completion?(data as? NSError, nil)
            }
        }
    }
    
    func getBrances (completion: ((NSError?, [BranchModel]?) -> Void)?  ){
        
    }
}
