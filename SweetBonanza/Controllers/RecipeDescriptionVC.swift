//
//  RecipeDescriptionVC.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class RecipeDescriptionVC: UIViewController {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeCookingLabel: UILabel!
    
    let mealNames: [String] = ["Chocolate cupcake decorated with white glaze", "Chocolate candy", "Chocolate cupcake", "Chocolate biscuit with creamy cream", "Strawberry in chocolate", "‘Strawberry Paradise’ cake", "marshmallow cookies", "marshmallow cookies", "Strawberry cake", "White chocolate candy"]
    let ingredients: [String] = [
    """
egg
cup sugar
cup melted butter
cup flour
cup cocoa powder
teaspoon of baking powder
the amount of chocolate as you wish
""", """
Milk chocolate
Chocolate forms
Candy vessel
Different scenery
""", """
egg
cup sugar
cup melted butter
cup flour
cup cocoa powder
teaspoon of baking powder
the amount of chocolate as you wish
""", """
flour
Chocolate
sugar
eggs
baking powder
cream
vanilla extract
""", """
Strawberry
Chocolate
""", """
eggs
A glass of sugar
glasses of milk
A glass of flour
tablespoons of cocoa powder
A teaspoon of baking powder
A pinch of salt
""", """
Cookies (for example, cracker)
Marshmallow
Chocolate (milk, dark or white)
""", """
Cookies (for example, cracker)
Marshmallow
Chocolate (milk, dark or white)
""", """
eggs
A glass of sugar
glasses of milk
A glass of flour
tablespoons of cocoa powder
A teaspoon of baking powder
A pinch of salt
""", """
white chocolate
Chocolate forms
Candy vessel
Different scenery
"""
    ]
    
    let cookingInstructions: [String] = [
    """
Heat the oven up to 180 degrees
Mix dry ingredients
Beat eggs with sugar
Combine dry and wet ingredients
Distribute the dough into molds
Bake until cooked
Cool and decorate
""", """
Melt the shocolod on hot water
Cool it by the moment
Form candy shapes
Cool completely
Decorate
""", """
Heat the oven up to 180 degrees
Mix dry ingredients
Beat eggs with sugar
Combine dry and wet ingredients
Distribute the dough into molds
Bake until cooked
Cool and decorate
""", """
Biscuit: Mix dry ingredients, whisk eggs with sugar, add melted butter and dry ingredients. Bake.
Cream: Beat the cream with sugar and vanilla to persistent peaks.
Harvest: cut a hat in a biscuit, grind with cream
""", """
Wash strawberries
Melt the chocolate
Dip the strawberry in chocolate
Allow the chocolate to dry
""", """
For a more lush biscuit, you can sift flour before use.
To make the cream more stable, you can add a cream lock to it.
Different types of chocolate (milk, dark) can be used for glaze.
""", """
Preparation: Heat the oven to average temperature.
Sandwich assembly: Put a piece of  marshmallow on cooking half.
Baking: Place the sandwiches on a baking sheet and bake in the oven until Marshmallow melts and becomes golden.
""", """
Preparation: Heat the oven to average temperature.
Sandwich assembly: Put a piece of  marshmallow on cooking half.
Baking: Place the sandwiches on a baking sheet and bake in the oven until Marshmallow melts and becomes golden.
""", """
For a more lush biscuit, you can sift flour before use.
To make the cream more stable, you can add a cream lock to it.
Different types of chocolate (milk, dark) can be used for glaze.
""", """
Melt the shocolod on hot water
Cool it by the moment
Form candy shapes
Cool completely
Decorate
"""
    ]
    var index: Int?
    let currentLevel = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.level) as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        defineUI()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leftTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if index! > 0 {
            index! -= 1
            defineUI()
        }
    }
    
    @IBAction func rightTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if index! < currentLevel {
            index! += 1
            defineUI()
        }
    }
    
    func defineUI() {
        if let index = index {
            if index <= currentLevel {
                recipeImageView.image = UIImage(named: "recipe\(index)")
                recipeNameLabel.text = mealNames[index]
                recipeIngredientsLabel.text = ingredients[index]
                recipeCookingLabel.text =  cookingInstructions[index]
            }
        }
    }
}
