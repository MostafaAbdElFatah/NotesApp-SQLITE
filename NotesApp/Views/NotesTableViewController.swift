//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by Mostafa AbdEl Fatah on 10/27/18.
//  Copyright © 2018 Mostafa AbdEl Fatah. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {

    var notes:[Note] = []

    override func viewDidLoad() {
        Sqlite.opendb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = false
        notes.removeAll()
        notes.append(contentsOf: Sqlite.getNotes())
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteTableViewCell
        // Configure the cell...
        cell.colorImageView.backgroundColor = UIColor.randomColor()
        cell.dateLabel.text = self.notes[indexPath.row].dateid
        cell.noteLabel.text = self.notes[indexPath.row].note
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Sqlite.delete(note: self.notes[indexPath.row])
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        let vc  = mainStoryboard.instantiateViewController(withIdentifier: "editeNote") as! ViewController
        vc.note = self.notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        return indexPath
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
