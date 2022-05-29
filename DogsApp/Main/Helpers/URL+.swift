//
//  URL+.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import Foundation
import Combine
import UIKit

extension URL {
    
    func downloadImage(_ completion: @escaping (UIImage?, Error?) -> Void) {
        
        URLSession.shared.dataTask(
            with: self,
            completionHandler: { data, _, error in
                
                guard
                    error == nil,
                    let data = data,
                    let uiImage = UIImage(data: data)
                else {
                    completion(nil, error)
                    return
                }
                
                completion(uiImage, nil)
            }
        ).resume()
    }
}
