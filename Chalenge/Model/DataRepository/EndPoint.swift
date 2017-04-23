

import Foundation
import Alamofire

var baseURLStr = "https://api.myjson.com/bins"
    


enum RemoteAddress: String  {
    
    case getShops = "https://api.myjson.com/bins/zjn2r"

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

