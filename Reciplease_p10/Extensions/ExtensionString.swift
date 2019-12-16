//
//  ExtensionString.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation

//MARK: - Extension String

extension String {
    /// Check if a string contains at least one element
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }
}


