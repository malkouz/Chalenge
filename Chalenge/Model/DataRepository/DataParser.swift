

import SwiftyJSON

class DataParser {
    
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
