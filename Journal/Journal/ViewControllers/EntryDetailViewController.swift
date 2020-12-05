//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jeff Kang on 12/5/20.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?
    var wasEdited = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
        moodSegmentedControl.setTitle("🙂", forSegmentAt: 0)
        moodSegmentedControl.setTitle("😐", forSegmentAt: 1)
        moodSegmentedControl.setTitle("☹️", forSegmentAt: 2)
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = titleTextField.text, !title.isEmpty, let entry = entry else { return }
            
            let moodIndex = moodSegmentedControl.selectedSegmentIndex
            
            let bodyText = bodyTextView.text
            
            entry.title = title
            entry.mood = Mood.allCases[moodIndex].rawValue
            entry.bodyText = bodyText
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context")
            }
        }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing
        
        let mood: Mood
        if let selectedMood = entry?.mood {
            mood = Mood(rawValue: selectedMood)!
        } else {
            mood = .neutral
        }
        moodSegmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        moodSegmentedControl.isUserInteractionEnabled = isEditing
        
        bodyTextView.text = entry?.bodyText
        bodyTextView.isUserInteractionEnabled = isEditing
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
