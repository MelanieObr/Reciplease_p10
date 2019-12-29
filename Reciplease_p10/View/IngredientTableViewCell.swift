//
//  IngredientTableViewCell.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Method to configure ingredient's cell
    func configure(ingredient: String) {
        ingredientLabel.text = "- \(ingredient)"
        ingredientLabel.textColor = .white
    }
}
