//
//  Category.swift
//  Todoey
//
//  Created by Karan Kumar on 16/9/2019.
//  Copyright © 2019 Bright Blockchain Financial Solutions. All rights reserved.
//

import Foundation
import RealmSwift

//REALM STEP 2: set-up category

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>() //like creating an empty 'array' of the instance Item
}
