//
//  RecipeDetailViewController.swift
//  Informer
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var textDescription: UITextView!

    var _recipe: RecipeModelItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = _recipe {
            labelName?.text = recipe.name
            labelAuthor?.text = recipe.author
            textDescription?.text = recipe.description
            imageView?.image = UIImage(contentsOfFile: recipe.imagePath!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func setData(_ recipe: RecipeModelItem) {
        self._recipe = recipe
    }
    
}
