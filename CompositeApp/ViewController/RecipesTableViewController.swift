//
//  RecipesTableViewController.swift
//  Informer
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
}

class RecipesTableViewController: UITableViewController {

    let recipesModel: RecipesModel = RecipesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesModel.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell

        let currentRecipe = recipesModel.recipes[indexPath.row]
        
        cell.labelName?.text = currentRecipe.name
        cell.labelAuthor?.text = currentRecipe.author
        cell.imagePreview?.image = UIImage(contentsOfFile: currentRecipe.imagePath!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetails" {
            let detailViewController = segue.destination as! RecipeDetailViewController
            let recipe = recipesModel.recipes[(self.tableView.indexPathForSelectedRow?.row)!]
            detailViewController.setData(recipe)
        }
    }
}
