//
//  UtilImage.swift
//  EbayTask
//
//  Created by Matthew Lewis on 7/26/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import Foundation
import UIKit

class UtilHelper {
    
    func getImage(urlImageString : String) -> UIImage?{
        
        guard let url = URL(string:"http://i.ebayimg.com/00/s/NjAwWDYwMA==/z/1i4AAOSwnDxUeLns/$_24.JPG?s")else {
            
            return nil
        }
        let data =  try! Data(contentsOf: url)
        let image  = UIImage(data: data)
        return image
        
    }
    
    
    func getIEbayImages(url : String , response : (AnyObject) -> ()){
        
        guard let url = URL(string:url)else {
            return
        }
        let data =  try! Data(contentsOf: url)
        
        do {
            
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                let dict = parsedData as? NSDictionary
                let images = dict?.object(forKey: "images")
            
        
        }catch let error as NSError {
            print("Details of JSON parsing error:\n \(error)")
        }
        
        
    }
    
}
