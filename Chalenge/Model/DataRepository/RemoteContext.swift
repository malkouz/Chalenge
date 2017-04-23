

import Alamofire
import SwiftyJSON

final class RemoteContext: NSObject {

    override init() {
        super.init()
        self.setupSessionManager()
    }
    
    
    
    static let shared : RemoteContext = {
        let instance = RemoteContext()
        instance.setupSessionManager()
        
        return instance
    }()
    
     var sessionManager:SessionManager!
    
     func setupSessionManager(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    func request(endPoint: EndPoint, parameters:[String: Any]?, handleError: Bool, completion:  ((Bool, Any?) -> Void)? ){
    
        
        sendRequest(endPoint: endPoint, parameters: parameters, handleError: handleError,
                           completion: { (success: Bool, response: Any?) -> Void in
                                                
                                                if success  {
                                                    
                                                    let wsResponse = response as! DataResponse<Any>
                                                    
                                                    if let wsData = wsResponse.data {
                                                        
                                                        let json = JSON(data: wsData)
                                                        completion?(true, json)
                                                    }
                                                }
                                                else {
                                                    
                                                    completion?(false, response)
                                                }
                                                
        });
    }
    
   
    
    private func sendRequest (endPoint: EndPoint, parameters:[String: Any]?, handleError: Bool, completion:  ((Bool, Any?) -> Void)? ) {
        
            sessionManager.request( buildURlRequest(endPoint: endPoint, params: parameters)).validate().responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let completion = completion {
                        completion (true, response)
                    }
                case .failure(let error):
                    
                    if let completion = completion {
                        
                        if handleError {
                            completion(false, error)
                        }
                        else {
                            completion(false, nil)
                        }
                        
                    }
                }
            }

        }



    private func buildURlRequest(endPoint: EndPoint, params: [String: Any]?) -> URLRequestConvertible{
        let relativePath =  endPoint.address.rawValue//baseURLStr.appendingFormat("/", endPoint.address.rawValue)
        let url = URL(string: relativePath)!
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Accept")
        
        if let headers = endPoint.headers {
            
            for header in headers {
                
                urlRequest.setValue(header.values.first!, forHTTPHeaderField: header.keys.first!)
            }
        }
        
        var encoding:ParameterEncoding!
        
        
        if endPoint.httpMethod == .get{
            encoding = URLEncoding.default
        }else{
            encoding = JSONEncoding.default
        }
        
        
        
        return try! encoding.encode(urlRequest, with: params)

    }
}
