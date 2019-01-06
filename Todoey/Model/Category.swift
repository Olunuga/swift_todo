//
//  Category.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 22/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
 @objc dynamic var name : String = ""
 @objc dynamic var color : String = ""
 let items = List<Item>()
}
