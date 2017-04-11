//
//  AKDiskManager.swift
//  piojos
//
//  Created by Alvaro Royo on 10/4/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit

class AKDiskManager {

    class func writeFile(data:Data!, path:String!, fileName:String!){
        
        AKDiskManager.removeFile(path: path)
        
        do{
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            try data.write(to: URL(fileURLWithPath: path))
        } catch {
            
            print("Error al escribir el archivo: %@",path);
            
        }
        
    }
    
    class func readFile(path:String!) -> Data? {
        
        var data:Data? = nil
        
        if FileManager.default.fileExists(atPath: path) {
            
            do{
            
                data = try Data.init(contentsOf: URL(fileURLWithPath: path))
                
            } catch {
                print("Error al leer el fichero: %@", path)
            }
            
        }
        
        return data
        
    }
    
    class func removeFile(path:String!){
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) {
            
            do{
                try fileManager.removeItem(atPath: path)
            } catch {
                
                print("Error al borrar el fichero: %@",path);
                
            }
            
        }
        
    }
    
}
