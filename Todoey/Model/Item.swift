//
//  Item.swift
//  Todoey
//
//  Created by Karan Kumar on 4/9/2019.
//  Copyright © 2019 Bright Blockchain Financial Solutions. All rights reserved.
//

import Foundation
import RealmSwift

//replaced with CoreData
//
//class Item: Codable {
//    var title : String = ""
//    var done : Bool = false
//}

//REALM STEP 3: Add Object

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //reverse linkage... to link back to Category.swift
}
