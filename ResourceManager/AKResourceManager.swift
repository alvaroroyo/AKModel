//
//  AKResourceManager.swift
//  piojos
//
//  Created by Alvaro Royo on 10/4/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit

class AKResourceManager {

    var managerServiceQueue: OperationQueue!
    private var webServiceManager:AKWebServiceManager!
    
    init(){
        self.managerServiceQueue = OperationQueue()
        self.managerServiceQueue.maxConcurrentOperationCount = 2
        
        self.webServiceManager = AKWebServiceManager.init(queue: self.managerServiceQueue)
    }
    
    //MARK: Disk methods
    
    func writeFile(data:Data!, path:String!, fileName:String!){
        
        AKDiskManager.writeFile(data: data, path: path, fileName: fileName)
        
    }
    
    func readFile(_ path:String!) -> Data? {
        
        return AKDiskManager.readFile(path: path)
        
    }
    
    func removeFile(_ path:String!){
        
        AKDiskManager.removeFile(path: path)
        
    }
    
    //MARK: Web Service Methods
    
    /**
     Request service Function
     
     - Parameters:
        - type: Type of the operation
            - GET
            - POST
        - path: String path of the service URL
            ```
            https://www.example.com
            ```
        - parameters: URL parameters
        - completion:
            - Bool: Success
            - Data?: Service Response
            - Int: Status code. If service has an error it's returned -1
     */
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, completion:((Bool,Data?,Int)->Swift.Void)?){
        
        request(type: type, path: path, parameters: parameters, headers: nil, body: nil, completion: completion)
        
    }
    
    /**
     Request service Function
     
     - Parameters:
        - type: Type of the operation
            - GET
            - POST
        - path: String path of the service URL
            ```
            https://www.example.com
            ```
        - parameters: URL parameters
        - headers: Headers for the service. Example:
            ```
            ["Content-Type":"application/json"]
            ```
        - body: Body for service as Data
        - completion:
            - Bool: Success
            - Data?: Service Response
            - Int: Status code. If service has an error it's returned -1
     */
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, headers:[String:String]?, body:Data?, completion:((Bool,Data?,Int)->Swift.Void)?){
        
        request(type: type, path: path, parameters: parameters, headers: headers, body: body, timeOut: nil, queue: nil, completion: completion)
        
    }
    
    /**
     Request service Function
     
     - Parameters:
        - type: Type of the operation
            - GET
            - POST
        - path: String path of the service URL
            ```
            https://www.example.com
            ```
        - parameters: URL parameters
        - headers: Headers for the service. Example:
            ```
            ["Content-Type":"application/json"]
            ```
        - body: Body for service as Data
        - timeOut: Service time out. I timeOut is lower than 10 a warning is printed in console.
        - queue: Custom Queue. If queue is nil the service is pushed to a default queue
        - completion:
            - Bool: Success
            - Data?: Service Response
            - Int: Status code. If service has an error it's returned -1
     */
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, headers:[String:String]?, body:Data?, timeOut:TimeInterval?, queue:OperationQueue?, completion:((Bool,Data?,Int)->Swift.Void)?){
        
        self.webServiceManager.requestOperation(type: type, path: path, parameters: parameters, body: body, headers: headers, timeOut: timeOut, _queue: queue, completionBlock: completion)
        
    }
    
}
