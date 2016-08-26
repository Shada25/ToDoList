//
//  ViewController.swift
//  ToDoList
//
//  Created by BT-Training on 26/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var dataModel = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.append(Checklist(withTitle: "Promener le chien"))
        dataModel.append(Checklist(withTitle: "Brosser mes dents"))
        dataModel.append(Checklist(withTitle: "Apprendre à developper une app"))
        dataModel.append(Checklist(withTitle: "Dormir"))
        dataModel.append(Checklist(withTitle: "s'entrainer pour le beer bong"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




extension ChecklistViewController{ //:UITableViewdataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count // nombre des elements dans le liste
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = UITbaleViewCell() // dans ce cas là on gere les cellule en memoire par nous meme
        // laisser le tableView de gerer ces cellule en memoire(son cache de cellule)
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        let checkList = self.dataModel[indexPath.row]
        label.text = checkList.title
        cell.accessoryType = checkList.done ? .Checkmark: .None
        return cell
    }
}

extension ChecklistViewController{ //: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checkList = self.dataModel[indexPath.row]
        checkList.done = !checkList.done
        
        tableView.reloadData()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}












