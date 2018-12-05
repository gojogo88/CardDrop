//
//  DataRequest.swift
//  CardDrop
//
//  Created by Brian Advent on 08.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation

enum GetDataRequest<Type> {
    case success([Type])
    case failure
}


struct DataRequest<Type> where Type : Decodable{
    let dataURL:URL
    
    init(dataSource:String) {
        guard let dataPathString = Bundle.main.path(forResource: dataSource, ofType: "plist") else {fatalError()}
        let dataURL = URL(fileURLWithPath: dataPathString)
        
        self.dataURL = dataURL
    }
    
    func getData (completion: @escaping (GetDataRequest<Type>) -> Void) {
        
        do {
            let data = try Data(contentsOf: dataURL)
            let resources = try PropertyListDecoder().decode([Type].self, from: data)
            completion(.success(resources))
        }catch{
            print(error.localizedDescription)
            completion(.failure)
        }
    }
}
