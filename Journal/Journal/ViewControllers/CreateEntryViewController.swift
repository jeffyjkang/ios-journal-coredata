//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Jeff Kang on 11/29/20.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    var entryController: EntryController?

    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text, !title.isEmpty else { return }
        let bodyText = entryBodyTextView.text
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        entryController?.sendEntryToServer(entry: entry)
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
        moodSegmentedControl.setTitle("🙂", forSegmentAt: 0)
        moodSegmentedControl.setTitle("😐", forSegmentAt: 1)
        moodSegmentedControl.setTitle("☹️", forSegmentAt: 2)
        moodSegmentedControl.selectedSegmentIndex = 1
        entryTitleTextField.becomeFirstResponder()
    }


}

