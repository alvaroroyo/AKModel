//
//  AKWebServiceManager.swift
//  piojos
//
//  Created by Alvaro Royo on 10/4/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit

class AKWebServiceManager {
    
    private let queue:OperationQueue!
    
    init(queue:OperationQueue) {
        self.queue = queue
    }
    
    func requestOperation(type:AKWebServiceOperationType, path:String!, parameters:[String:Any]?, body:Data?, headers:[String:String]?, timeOut:TimeInterval?, _queue:OperationQueue?, completionBlock:((Bool,Data?,Int) -> Swift.Void)?){
        
        let operation = AKWebServiceOperation.init(type: type, path: path, parameters: parameters, headers: headers)
        
        if(body != nil){
            operation.body = body
        }
        
        if completionBlock != nil { operation.customCompletionBlock = completionBlock }
        
        if(timeOut != nil) {
            
            if timeOut! < 10 {
                print("AKWebServiceManager -> timeOut may be to short. (\(timeOut!.description))")
            }
            
            operation.timeOut = timeOut!
        }
        
        if(_queue != nil){
            _queue!.addOperation(operation)
        }else{
            self.queue.addOperation(operation)
        }
        
    }
    
}
