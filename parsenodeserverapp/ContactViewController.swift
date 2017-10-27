//
//  ContactViewController.swift
//  parsenodeserverapp
//
//  Created by Garrett Barker on 10/25/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit
import Parse

class ContactViewController: UIViewController {
    @IBOutlet var firstName: UITextField!
    
    var myUser: String = ""
    var contact = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(!contact.isEmpty){
            firstName.text = contact[0]["name"] as! String
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        let saveBTN = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.save, target:self,
                                      action: #selector(saveButtonTapped(_:)))
        let deleteBTN = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.trash, target:self,
                                        action: #selector(deleteButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [saveBTN, deleteBTN]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        
        if(!contact.isEmpty){
            let query = PFQuery(className:"Contacts")
            query.getObjectInBackground(withId: contact[0].objectId!) {
                (update, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let update = update {
                        update["name"] = self.firstName.text
                        update.saveInBackground {
                            (success: Bool, error: Error?) in
                            if (success) {
                                // The object has been saved.
                                print(success)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                // There was a problem, check error.description
                                print("save failed")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }else{
            let newContact = PFObject(className:"Contacts")
            newContact["name"] = firstName.text!
            newContact["userId"] = myUser
            newContact.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    print(success)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // There was a problem, check error.description
                    print("save failed")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton){
        if(!contact.isEmpty){
            let query = PFQuery(className:"Contacts")
            query.getObjectInBackground(withId: contact[0].objectId!) {
                (update, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let update = update {
                        update.deleteInBackground() {
                            (success: Bool, error: Error?) in
                            if (success) {
                                // The object has been saved.
                                print(success)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                // There was a problem, check error.description
                                print("save failed")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
