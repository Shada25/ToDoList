//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by BT-Training on 29/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit



protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(controller: AddItemViewController)
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem: Checklist)
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem: Checklist)
}



class AddItemViewController: UITableViewController {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // on fait un weak var car les deux viewcontrollers sont lié ensemble via un lien fort avec le Delegate.. ce qui posera des problèmes
    // donc pour eviter la fuite en memoire on cree un lien faible vers de la class enfant vers le class parent et pas l'inverse mais
    // il faut pas oublier au protocol qu'il soit implementé que par des "class" car un protocol peut etre implementé par une class ou une structure
    // et une structure ne peut pas avoir un var "weak"
    weak var addItemViewControllerDelegate: AddItemViewControllerDelegate?
    
    
    var checklistToEidt:Checklist!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklistToEidt = self.checklistToEidt{
            textField.text = checklistToEidt.title
            self.title = "Edit Item"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(){
        if let addItemViewControllerDelegate = self.addItemViewControllerDelegate {
            addItemViewControllerDelegate.addItemViewControllerDidCancel(self) // point 3
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(){
        let title = self.textField.text
        
        let trimmedTitle = title?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if trimmedTitle?.characters.count == 0 {
            let alert = UIAlertController(title: "Oops!", message: "Title can't be empty", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil) // closure
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }else{
            if let addItemViewControllerDelegate = self.addItemViewControllerDelegate{
                
                if let checklistToEidt = self.checklistToEidt{ // si on a une checklist to edit
                    checklistToEidt.title = trimmedTitle!
                    addItemViewControllerDelegate.addItemViewController(self, didFinishEditingItem: checklistToEidt)// point 3 for edit
                }else{
                    let checklist = Checklist(withTitle: trimmedTitle!)
                    addItemViewControllerDelegate.addItemViewController(self, didFinishAddingItem: checklist)// point 3
                }
            }
        }
        
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) //important !!
        textField.becomeFirstResponder()//pour afficher le clavier
        doneButton.enabled = textField.text!.characters.count > 0
    }
}

// UITableViewControllerDataSource
extension AddItemViewController{
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}


extension AddItemViewController: UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let newText = (oldText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        // on accepte pas de tapper les espaces mais le button "terminé" dans le clavier est toujours activé car c lié au storyboars et non pas au code
        let trimmedText = newText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        doneButton.enabled = trimmedText.characters.count > 0
        
        return true
    }
}







