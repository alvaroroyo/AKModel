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
    
    func readFile(path:String!) -> Data? {
        
        return AKDiskManager.readFile(path: path)
        
    }
    
    func removeFile(path:String!){
        
        AKDiskManager.removeFile(path: path)
        
    }
    
    //MARK: Web Service Methods
    
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, completion:((Bool,Data?)->Swift.Void)?){
        
        request(type: type, path: path, parameters: parameters, headers: nil, body: nil, completion: completion)
        
    }
    
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, headers:[String:String]?, body:Data?, completion:((Bool,Data?)->Swift.Void)?){
        
        request(type: type, path: path, parameters: parameters, headers: headers, body: body, timeOut: nil, queue: nil, completion: completion)
        
    }
    
    func request(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, headers:[String:String]?, body:Data?, timeOut:TimeInterval?, queue:OperationQueue?, completion:((Bool,Data?)->Swift.Void)?){
        
        self.webServiceManager.requestOperation(type: type, path: path, parameters: parameters, body: body, headers: headers, timeOut: timeOut, _queue: queue, completionBlock: completion)
        
    }
    
}
