//
//  Sqlite.swift
//  NotesApp
//
//  Created by Mostafa AbdEl Fatah on 10/27/18.
//  Copyright © 2018 Mostafa AbdEl Fatah. All rights reserved.
//

import Foundation
import SQLite3

struct Sqlite {
    
    static var db: OpaquePointer?
    
    static func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("noetes_db.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        //let sql = "CREATE TABLE IF NOT EXISTS notes ( dateid TEXT NOT NULL, note TEXT, PRIMARY KEY(date) );"
        let sql = "CREATE TABLE IF NOT EXISTS \(Constants.table_name) ( "
            + "\(Constants.dateid_Filed) TEXT NOT NULL PRIMARY KEY,"
            + "\(Constants.note_Filed) TEXT );"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    static func save(note:String){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let dateid = formatter.string(from: date)
        
        //**/
        let queryString = "INSERT INTO \(Constants.table_name) "
            + "VALUES ('\(dateid)','\(note)');"

        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
         
        /*
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO \(Constants.table_name) VALUES ('?','?')"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, dateid, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, note, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }*/
    
        
    }
    
    static func getNotes() -> [Note] {
        var notes:[Note] = []
        
        //this is our select query
        let queryString = "SELECT * FROM \(Constants.table_name);"
        //statement pointer
        var stmt:OpaquePointer?
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let dateid = String(cString: sqlite3_column_text(stmt, 0))
            let note = String(cString: sqlite3_column_text(stmt, 1))
            
            //adding values to list
            notes.append(Note(dateid: dateid, note: note))
        }
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        return notes
    }
    
    static func delete(note:Note){
        let queryString = "DELETE FROM \(Constants.table_name) "
            + "WHERE  \(Constants.dateid_Filed) = '\(note.dateid)';"
        
        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    static func update(note:Note){
        let queryString = "UPDATE \(Constants.table_name) "
            + "SET \(Constants.note_Filed) = '\(note.note)' "
            + "WHERE  \(Constants.dateid_Filed) = '\(note.dateid)';"
        
        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
}
