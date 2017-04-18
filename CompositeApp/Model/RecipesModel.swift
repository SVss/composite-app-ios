//
//  RecipesModel.swift
//  Informer
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import Foundation
import SwiftyJSON

let DATA_PREFIX = "data/"
let DATA_FILE_NAME = "data.json"

class RecipeModelItem {
    var name: String
    var author: String
    var description: String
    var imagePath: String?
    
    init(name: String, author: String, description: String, imagePath: String) {
        self.name = name
        self.author = author
        self.description = description
        self.imagePath = Bundle.main.path(forResource: DATA_PREFIX + imagePath, ofType: "")
    }
}

class RecipesModel {
    var recipes = [RecipeModelItem]()
    
    init(_ jsonPath: String? = Bundle.main.path(forResource: DATA_PREFIX + DATA_FILE_NAME, ofType: "")) {
        print(jsonPath!)
        let jsonData = NSData(contentsOfFile:jsonPath!)
        let json = JSON(data: jsonData! as Data)
        
        let imagesPath = json["images_path"].string!
        
        for (_,subJson):(String, JSON) in json["recipes"] {
            let newRecipe = RecipeModelItem(
                name: subJson["name"].string!,
                author: subJson["author"].string!,
                description: subJson["desc"].string!,
                imagePath: imagesPath + subJson["img"].string!
            )
            print(newRecipe.name)
            recipes.append(newRecipe)
        }
    }
    
    public func count() -> Int{
        return recipes.count
    }
}
