//
//  DataParsers.swift
//  MOH
//
//  Created by Moayad Al kouz on 3/28/17.
//  Copyright © 2017 Mobile Dev. All rights reserved.
//

import SwiftyJSON

class DataParser {
    
    
    /*
     "shops" : [
     {
     "address" : "Riyadh - Road 1",
     "longitude" : 46.74393475055695,
     "branchNumber" : 1,
     "image" : "https:\/\/s1-cdn.hm.com\/hm.com\/ecom-image-static\/1.67.0-5\/desktop\/logotype.png",
     "latitude" : 24.66080796834796,
     "branches" : [
     {
     "address" : "Riyadh - Road 2",
     "longitude" : 46.77153132855892,
     "latitude" : 24.72388429738599
     },
     {
     "address" : "Riyadh - Road 3",
     "longitude" : 46.69434875249863,
     "latitude" : 24.57310913749005
     },
     {
     "address" : "Riyadh - Road 4",
     "longitude" : 46.7075466143433,
     "latitude" : 24.62105864137005
     }
     ],
     "name" : "H & M",
     "desc" : "H&M's business concept is to offer fashion and quality at the best price in a sustainable way."
     }
     ]

     
     */
    
    func parseShops(json: JSON) -> [ShopModel]?{
        var shops = [ShopModel]()
        for item in json["shops"].arrayValue  {
            let model = ShopModel(context: LocalContext.shared.managedObjectContext)
            model.address = item["address"].stringValue
            model.longitude = item["longitude"].doubleValue
            model.id = item["branchNumber"].int16Value
            model.imageURL = item["image"].stringValue
            model.latitude = item["latitude"].doubleValue
            model.name = item["name"].stringValue
            model.desc = item["desc"].stringValue
            
            for branchItem in item["branches"].arrayValue{
                let branch = BranchModel(context: LocalContext.shared.managedObjectContext)
                branch.address = branchItem["address"].stringValue
                branch.longitude = branchItem["longitude"].doubleValue
                branch.latitude = branchItem["latitude"].doubleValue
                branch.shopId = model.id
            }
            
            
            shops.append(model)
        }
        //print("JSON :: ", json)
        return shops
    }
    
    
}
