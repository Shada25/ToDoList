//
//  Ckecklist.swift
//  ToDoList
//
//  Created by BT-Training on 26/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import Foundation


class Checklist: NSObject, NSCoding{
    
    let titleKey = "Title"
    let doneKey = "Done"
    
    var title:String = ""
    var done:Bool = false
    
    
    init(withTitle:String){
        self.title = withTitle
        self.done = false
    }
    
    
    // init? means that it can returns nil
    required init?(coder aDecoder: NSCoder){
        super.init()
        title = aDecoder.decodeObjectForKey(titleKey) as! String // ca return un objet donc il faut caster
        done = aDecoder.decodeBoolForKey(doneKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeBool(done, forKey: doneKey)
    }
}