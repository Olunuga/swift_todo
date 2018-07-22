//
//  Item.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 22/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
