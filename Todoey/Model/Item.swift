//
//  Item.swift
//  Todoey
//
//  Created by OLUNUGA Mayowa on 21/07/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

class Item : Codable{
    var title: String?
    var isDone: Bool = false
    
    init(title:String) {
        self.title = title
    }
    
    init(title:String, isDone : Bool) {
        self.title = title
        self.isDone = isDone
    }
    
}
