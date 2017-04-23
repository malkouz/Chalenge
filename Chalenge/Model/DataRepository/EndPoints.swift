//
//  EndPoints.swift
//  BalaghV2
//
//  Created by Mobile Dev on 2/23/17.
//  Copyright © 2017 Mobile Dev. All rights reserved.
//

import Foundation
import Alamofire

var baseURLStr = "http://10.10.63.12:150/api"
    


enum RemoteAddress: String  {
    
    case Login = "UserManagment/Login"
    case GetDashboardInfo = "Miscellaneous/GetDashboardInfo"
  
    
    case Logout = "UserManagement/SignOut"
    case UserProfile = "UserManagment/GetMyProfile"
    
    case GetGeneralActivitiesDomains = "ECR/GetGeneralActivitiesDomains"
    case GetSpecialActivitiesDomains = "ECR/GetSpecialActivitiesDomains"
    case GetActivitiesDomains = "ECR/GetActivitiesDomains"
    case GetCRTypes = "ECR/GetCRTypes"
    case GetActivityTypes = "ECR/GetActivityTypes"
    case GetMyCRs = "ECR/GetMyCRs"
    case CheckTradeNameAvailabilty = "TradeName/CheckTradeNameAvailabilty"
    case ReserveSpecialTradeName = "TradeName/ReserveSpecialTradeName"

}

struct EndPoint {
    
    var address: RemoteAddress
    var httpMethod: HTTPMethod
    var headers: [[String:String]]?
    
    init(address: RemoteAddress, headers: [[String:String]]?, httpMethod: HTTPMethod) {
        
        self.address = address
        self.httpMethod = httpMethod
        
        if let headers = headers {
            self.headers = headers
        }
    }
    
}

