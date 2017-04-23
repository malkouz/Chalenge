//
//  DataSource.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation

final class DataSource: NSObject, DataSourceProtocol {
    
    lazy var remoteDataSource:DataSourceProtocol = RemoteDataSource()
    lazy var localDataSource:DataSourceProtocol = LocalDataSource()

    // Can't init is singleton
    private override init() { }
    
    //MARK: Shared Instance
    
    static let shared: DataSourceProtocol = DataSource()

    
    func getShops (completion: ((NSError?, [ShopModel]?) -> Void)?  ){
        localDataSource.getShops { [weak self] (error, models) in
            if let models = models{
                if models.count > 0{
                completion?(error, models)
                    return
                }
            }
                self?.remoteDataSource.getShops { (error, models) in
                    LocalContext.shared.saveContext()
                    completion?(error, models)
                }
            
        }
    }
    
    func getBrances (completion: ((NSError?, [BranchModel]?) -> Void)?  ){
        localDataSource.getBrances { (error, models) in
            completion?(error, models)
        }
    }
}
