//
//  Util.swift
//  TimeCountSystem
//
//  Created by swen on 09.02.2026.
//

import Foundation

let DATE_FORMAT_SAVE = "yyyy.MM.dd"
let DATE_FORMAT_UI = "dd.MM.yyyy"
let DATE_FORMAT_TIME = "yyyy.MM.dd HH:mm:ss.SSS"

let NUMBER_FORMAT_DOUBLE_TO_INT = ""

let queueUpdateLabel = "UPDATE_QUEUE"

class Util {
    
    static let utilQueue = DispatchQueue(label: queueUpdateLabel, attributes: .concurrent)
    
    static let formatterDoubleOne = NumberFormatter()
    static let dateFormatterToSave = DateFormatter()
    
    
    static func initFormatters() {
        formatterDoubleOne.numberStyle = .decimal
        formatterDoubleOne.maximumFractionDigits = 1
        
        dateFormatterToSave.dateFormat = DATE_FORMAT_SAVE
    }
    
    static func parseDateForSave(_ inputDate : Date) -> String {
        return dateFormatterToSave.string(from: inputDate)
    }
    

    
    
    static func convertDoubleToInt(_ inputDouble : Double) -> Int {
        let tmp = inputDouble * 10
        return Int(tmp.rounded(.toNearestOrEven))
    }
    

    static func getStringWithPathSeparators(_ parts : [String]) -> String {
        if parts.count > 1 {
            var result = parts[0]
            for i in 1...(parts.count - 1) {
                result = result + AllConst.pathSeparator + parts[i]
            }
            return result
        }
        else if parts.count == 1 {
            return parts[0]
        }
        return ""
    }
    
}



