//
//  NetworkContext.swift
//  Miras
//
//  Created by Murad Jamal on 1/11/16.
//  Copyright © 2016 Thiqah. All rights reserved.
//

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
    
    
    func request(endPoint: EndPoint, parameters:[String: Any]?, pageIndex: Int?, handleError: Bool, completion:  ((Bool, Any?) -> Void)? ){
    
        var parameters = parameters
        if let _ = parameters, let pageIndex = pageIndex
        {
            parameters?["pageIndex"] = pageIndex
        }
        
        sendRequest(endPoint: endPoint, parameters: parameters, handleError: handleError,
                           completion: { (success: Bool, response: Any?) -> Void in
                                                
                                                if success  {
                                                    
                                                    let wsResponse = response as! DataResponse<Any>
                                                    
                                                    if let wsData = wsResponse.data {
                                                        
                                                        let json = JSON(data: wsData)
                                                        completion?(true, json)
                                                    }
                                                    else { //no data from web service
                                                        
//                                                        let noInfoError = RemoteErrorHandler.sharedInstance.getGeneralErrorInfo()
//                                                        completion?(false, noInfoError)
                                                    }
                                                }
                                                else {
                                                    
                                                    completion?(false, response)
                                                }
                                                
        });
    }
    
   
    
    private func sendRequest (endPoint: EndPoint, parameters:[String: Any]?, handleError: Bool, completion:  ((Bool, Any?) -> Void)? ) {
        
        if endPoint.httpMethod == .post {
        
            sessionManager.request(Router.post(endPoint, parameters)).validate().responseJSON { [weak self] response in
                switch response.result {
                case .success:
                    
                    if let completion = completion {
                        
                        //print("Raw Request \(String(bytes: response.request!.httpBody!, encoding: String.Encoding.utf8  ))")
                        
                        completion (true, response)
                    }
                case .failure(let error):
                    
                    if let completion = completion {
                        
                        if handleError {
                            
//                            let errorInfo =  self?.remoteErrorHandler.getErrorInfo(response: response, error: (error as NSError))
//                            completion(false, errorInfo)
                            
                        }
                        else {
                            
                            completion(false, nil)
                        }
                        
                    }
                }
            }

        }
        else if endPoint.httpMethod == .get {
            let xx = Router.get(endPoint, parameters)
            sessionManager.request(xx).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    if let completion = completion {
                        
                        completion (true, response)
                    }
                    
                    
                case .failure(let error):
                    
                    if let completion = completion {
                        
                        if handleError == true {
                            
//                            let errorInfo =  RemoteErrorHandler.sharedInstance.getErrorInfo(response: response, error: (error as NSError))
//                            completion(false, errorInfo)
                            
                        }
                        else {
                            
                            completion(false, nil)
                        }
                        
                    }
                    
                    
                }
            }
            
        }
        
        else if endPoint.httpMethod == .put {
            
            sessionManager.request(Router.put(endPoint, parameters)).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    if let completion = completion {
                        
                        completion (true, response)
                    }
                    
                    
                case .failure(let error):
                    
                    if let completion = completion {
                        
                        if handleError == true {
                            
//                            let errorInfo =  RemoteErrorHandler.sharedInstance.getErrorInfo(response: response, error: (error as NSError))
//                            completion(false, errorInfo)
                            
                        }
                        else {
                            
                            completion(false, nil)
                        }
                        
                    }
                }
            }
            
        }
        
        else if endPoint.httpMethod == .delete {
            
            sessionManager
                .request(Router.delete(endPoint, parameters)).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    if let completion = completion {
                        
                        completion (true, response)
                    }
                    
                    
                case .failure(let error):
                    
                    if let completion = completion {
                        
                        if handleError == true {
                            
//                            let errorInfo =  RemoteErrorHandler.sharedInstance.getErrorInfo(response: response, error: (error as NSError))
//                            completion(false, errorInfo)
                            
                        }
                        else {
                            
                            completion(false, nil)
                        }
                        
                    }
                }
            }
            
        }

        
        
        
    }
    
    enum Router: URLRequestConvertible {
        
        static let baseURLString = baseURLStr
        
        case get(EndPoint, [String: Any]?)
        case post(EndPoint, [String: Any]?)
        case put(EndPoint, [String: Any]?)
        case delete(EndPoint, [String: Any]?)
        
        func asURLRequest() throws -> URLRequest {
            var method: HTTPMethod {
                switch self {
                case .get:
                    return .get
                case .post:
                    return .post
                case .put:
                    return .put
                case .delete:
                    return .delete
                }
            }
            
            let params: ([String: Any]?) = {
                switch self {
                case .get(_, let newObject):
                    return (newObject)
                    
                case .post(_, let newObject):
                    return (newObject)
                    
                case .put(_, let newObject):
                    return (newObject)
                    
                case .delete(_, let newObject):
                    return (newObject)
                
                }
            }()
            
            
            let url:URL = {
                
                
                // build up and return the URL for each endpoint
                let relativePath:String?
                switch self {
                    
                case .get(let endPoint, _):
                    
                    relativePath = "/\(endPoint.address.rawValue)"
                    
                case .post(let endPoint, _):
                    relativePath = "/\(endPoint.address.rawValue)"
                    
                case .put(let endPoint, _):
                    relativePath = "/\(endPoint.address.rawValue)"
                    
                case .delete(let endPoint, _):
                    relativePath = "/\(endPoint.address.rawValue)"
                   
                }
                
                var url = URL(string: Router.baseURLString)!
                if let relativePath = relativePath {
                    url = url.appendingPathComponent(relativePath)
                }
                return url
            }()
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Accept")
            
            
            //additional headers

            switch self {
                
            case
             .get(let endPoint, _),
             .post(let endPoint, _),
             .put(let endPoint, _),
             .delete(let endPoint, _):
                
                if let headers = endPoint.headers {
                    
                    for header in headers {
                        
                        urlRequest.setValue(header.values.first!, forHTTPHeaderField: header.keys.first!)
                    }
                }
                
            }
            
            var encoding:ParameterEncoding!
            
            
            if method == .get{
                 encoding = URLEncoding.default
            }else{
                 encoding = JSONEncoding.default
            }
            
            return try encoding.encode(urlRequest, with: params)
        }
    }
    
}
