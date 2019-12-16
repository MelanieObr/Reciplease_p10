//
//  ErrorCases.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation


//MARK: - Enumeration to manage errors
enum ErrorCases: Error {
    case invalidRequest
    case errorDecode
    case errorNetwork
}
