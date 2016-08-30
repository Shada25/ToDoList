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
        
        /* ON REMPLACE PAR LOADCHECKLIST */
        
//        dataModel.append(Checklist(withTitle: "Promener le chien"))
//        dataModel.append(Checklist(withTitle: "Brosser mes dents"))
//        dataModel.append(Checklist(withTitle: "Apprendre à developper une app"))
//        dataModel.append(Checklist(withTitle: "Dormir"))
//        dataModel.append(Checklist(withTitle: "S'entrainer pour le beer bong"))
        
        loadChecklist()
        print("documents directory: \(documentsDirectory())")
        print("data file path: \(dataFilePath())")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addItem(item: Checklist) {
        //ajouetr cette element dans le data model !! important
        dataModel.append(item)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) //automatic reprend le meme animation que dans le storyboard si on sait pas lequel est utilisé
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItemSegue"{
            if let navigationController = segue.destinationViewController as? UINavigationController{
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    addItemViewController.addItemViewControllerDelegate = self //point 5
                }
            }
        }else if segue.identifier == "editItemSegue"{
            if let navigationController = segue.destinationViewController as? UINavigationController{
                if let addItemViewController = navigationController.topViewController as? AddItemViewController{
                    if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell){
                        addItemViewController.addItemViewControllerDelegate = self
                        addItemViewController.checklistToEidt = dataModel[indexPath.row]
                    }
                }
            }
        }
    }
    
    // persistance des donnees
    func documentsDirectory() -> String{
        //NSSearchPathForDirectoriesInDomains : permet de chercher plusieurs dosier qui correspond à la requete
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0] // on veut un seul
    }
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklist.plist")
    }
    func saveChecklists(){
        let data = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWithMutableData: data) // serialiser qui va encoder les donnee en clé-valeur
        archiever.encodeObject(dataModel, forKey: "Checklist")
        archiever.finishEncoding()
        data.writeToFile(dataFilePath(), atomically:  true)
    }
    func loadChecklist(){
        //chercher le chemin on a stocké
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unachiver = NSKeyedUnarchiver(forReadingWithData: data)
                defer{
                    unachiver.finishDecoding()
                }
                self.dataModel = unachiver.decodeObjectForKey("Checklist") as! [Checklist]
                //unachiver.finishDecoding()
            }
        }
    }
    
}

//point4
extension ChecklistViewController: AddItemViewControllerDelegate{
    
    func addItemViewControllerDidCancel(controller: AddItemViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: Checklist){
        addItem(item)
        controller.dismissViewControllerAnimated(true, completion: nil)
        saveChecklists()
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: Checklist){
        if let index = dataModel.indexOf({checklist in
            return checklist === item
        }){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        saveChecklists()
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
        //cell.accessoryType = checkList.done ? .Checkmark: .None
        return cell
    }
    
    // pour le button delete lors qu'on glisse la ligne
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        saveChecklists()
    }
}

extension ChecklistViewController{ //: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checkList = self.dataModel[indexPath.row]
        checkList.done = !checkList.done
        
        tableView.reloadData()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        saveChecklists()
    }
    
}












