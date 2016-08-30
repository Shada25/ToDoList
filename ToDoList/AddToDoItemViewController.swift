//
//  AddToDoItemViewController.swift
//  ToDoList
//
//  Created by BT-Training on 30/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UITableViewController {
    
    weak var addToDoItemViewController: AddItemViewControllerDelegate?
    var dataModel = [Checklist]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChecklist()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func cancel(){
        dismissViewControllerAnimated(true, completion: nil)
        print("cancel")
    }
    
    func addItem(item: Checklist) {
        dataModel.append(item)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addToDoItemSegue"{
            if let navigationController = segue.destinationViewController as? UINavigationController{
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    addItemViewController.addItemViewControllerDelegate = self //point 5
                }
            }
        }else{
            print("error")
        }
    }
    

    func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("ToDoList.plist")
    }
    func saveChecklists(){
        let data = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWithMutableData: data)
        archiever.encodeObject(dataModel, forKey: "ToDoList")
        archiever.finishEncoding()
        data.writeToFile(dataFilePath(), atomically:  true)
    }
    func loadChecklist(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unachiver = NSKeyedUnarchiver(forReadingWithData: data)
                defer{
                    unachiver.finishDecoding()
                }
                self.dataModel = unachiver.decodeObjectForKey("ToDoList") as! [Checklist]
            }
        }
    }
    
}

//point4
extension AddToDoItemViewController: AddItemViewControllerDelegate{
    
    func addItemViewControllerDidCancel(controller: AddItemViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: Checklist){
        addItem(item)
        controller.dismissViewControllerAnimated(true, completion: nil)
        saveChecklists()
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: Checklist){
        if let index = dataModel.indexOf({todoList in
            return todoList === item
        }){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        saveChecklists()
    }
}


extension AddToDoItemViewController{ //:UITableViewdataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toDoItems", forIndexPath: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        let todoList = self.dataModel[indexPath.row]
        label.text = todoList.title
        cell.accessoryType = todoList.done ? .Checkmark: .None
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        saveChecklists()
    }
}

extension AddToDoItemViewController{ //: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todoList = self.dataModel[indexPath.row]
        todoList.done = !todoList.done
        tableView.reloadData()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        saveChecklists()
    }
    
}




