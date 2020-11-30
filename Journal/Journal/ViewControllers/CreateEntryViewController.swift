//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Jeff Kang on 11/29/20.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text, !title.isEmpty else { return }
        let bodyText = entryBodyTextView.text
        Entry(title: title, bodyText: bodyText)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        entryTitleTextField.becomeFirstResponder()
    }


}

