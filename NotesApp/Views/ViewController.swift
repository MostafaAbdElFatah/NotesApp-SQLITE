//
//  ViewController.swift
//  NotesApp
//
//  Created by Mostafa AbdEl Fatah on 10/27/18.
//  Copyright © 2018 Mostafa AbdEl Fatah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var note:Note?
    @IBOutlet weak var noteTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        if let text = note?.note {
            noteTextView.text = text
        }
    }
    
    @IBAction func saveToDatabase(_ sender: Any) {
        
        guard let noteText = noteTextView.text else {
            return
        }
        if note == nil {
            Sqlite.save(note: noteText)
        }else {
            note?.note = noteTextView.text
            Sqlite.update(note: note!)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
}

