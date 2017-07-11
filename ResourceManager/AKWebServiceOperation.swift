//
//  AKWebServiceOperation.swift
//  piojos
//
//  Created by Alvaro Royo on 10/4/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit

enum AKWebServiceOperationType {
    case NONE
    case GET
    case POST
}

class AKWebServiceOperation: Operation {

    private var path:String!
    private var parameters:[String:Any]? = nil
    private var headers:[String:String]? = nil
    private var type:AKWebServiceOperationType = AKWebServiceOperationType.NONE
    private var request:URLRequest!
    
    var body:Data? = nil
    var timeOut:TimeInterval = 60
    var customCompletionBlock:((Bool,Data?,Int) -> Swift.Void)? = nil
    
    init(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, headers:[String:String]?){
        super.init()
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.type = type
    }
    
    override func main(){
        
        setURL()
        
        self.request = URLRequest.init(url: URL.init(string: self.path)!)
        
        self.request.timeoutInterval = self.timeOut
        
        switch self.type {
        case .GET:
            self.request.httpMethod = "GET"
            break
        case .POST:
            self.request.httpMethod = "POST"
            break
        case .NONE:
            return
        }
        
        if(self.body != nil){
            self.request.httpBody = self.body
        }
        
        setHeaders()
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let dataTask = URLSession.shared.dataTask(with: self.request) { (responseData, urlResponse, error) in
            
            if(error != nil){
                
                print("Error en ServiceOperation: %@",error!)
                if self.customCompletionBlock != nil { self.customCompletionBlock!(false,nil,-1) }
                
            }else{
                
                let httpResponse = urlResponse as! HTTPURLResponse
                let status = httpResponse.statusCode
                
                if self.customCompletionBlock != nil { self.customCompletionBlock!(true,responseData!,status) }
                
            }
            
            semaphore.signal()
            
        }
        dataTask.resume()
        
        semaphore.wait()
        
    }
    
    //MARK: Private funcs
    
    private func setHeaders(){
        
        if(self.headers != nil){
        
            var contentType = false
            
            for key in Array(self.headers!) {
                
                if !contentType {
                    
                    contentType = key.key == "Content-Type"
                    
                }
                
                self.request.setValue(key.value, forHTTPHeaderField: key.key)
                
            }
            
        }
        
    }
    
    private func setURL(){
        
        if(self.parameters != nil){
            
            let keys = Array(self.parameters!)
            
            for i in 0...keys.count {
                
                let key = keys[i]
                
                if(i == 0){
                    self.path = self.path.appending(String(format: "?%@=%@", key.key,key.value as! CVarArg))
                }else{
                    self.path = self.path.appending(String(format: "&%@=%@", key.key,key.value as! CVarArg))
                }
                
            }
            
        }
        
    }
    
}
