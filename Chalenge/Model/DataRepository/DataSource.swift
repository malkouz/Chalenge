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

}
