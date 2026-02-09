//
//  WorkTime.swift
//  TimeCountSystem
//
//  Created by swen on 09.02.2026.
//

import Foundation

struct WorkTime :  Equatable, Hashable  {
    var projectID : Int
    var dateString : String
    var designerID : Int
    
    var time : Int = 0
    
    var year : Int
    var month : Int
    var weekNumber : Int
    
    init(inputProjectID: Int, date: Date, inputDesignerID: Int, inputTime: Double) {
        self.projectID = inputProjectID
        self.dateString = Util.parseDateForSave(date)
        self.designerID = inputDesignerID
        self.time = Util.convertDoubleToInt(inputTime)
        
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.weekNumber = calendar.component(.weekOfYear, from: date)
    }
    
    static func == (lhs: WorkTime, rhs: WorkTime) -> Bool {
        lhs.projectID == rhs.projectID &&
        lhs.designerID == rhs.designerID &&
        lhs.dateString == rhs.dateString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(projectID)
        hasher.combine(designerID)
        hasher.combine(dateString)
    }
}
