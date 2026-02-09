//
//  Project.swift
//  TimeCountSystem
//
//  Created by swen on 09.02.2026.
//

import Foundation

class Project : Equatable, Hashable {
    
    var idNumber : Int
    
    var company : String = ""
    var manager : String = ""
    var description : String = ""
    var dateCreation : Date = Date()
    var dateCreationString : String = ""
    var comment : String = ""
    var folderPath : String = ""
    var tags : String = ""
    
    var isArchive : Bool = false
    
    var workSum : Int = 0
    var work : [WorkTime] = []
    
    var PONumber : String = ""
    var budget : Int?
    
    init(idNumber: Int, company: String, manager: String, description: String, date: Date) {
        self.idNumber = idNumber
        self.company = company
        self.manager = manager
        self.description = description
        self.dateCreation = date
        self.dateCreationString = Util.parseDateForSave(date)
    }

    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.idNumber == rhs.idNumber
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idNumber)
    }
    
}
