//
//  TestDates.swift
//  TimeCountSystem
//
//  Created by swen on 11.02.2026.
//

import Foundation

class TestDates {
    var samples : [DateToString] = []
        
    var startValue : Date?
    var increment : Int = 0
    var count : Int = 0
    
    var currentValue : Date?
    
    init(startValue: Date, increment: Int, count: Int) {
        self.startValue = startValue
        self.increment = increment
        self.count = count
        
        self.currentValue = startValue
    }
    
    func testDatesToString() {
        
        print("TestDatesToString . start test !")
        
        currentValue = startValue
        
        for i in 1...count {
            samples.append(DateToString(id: i, value: currentValue!))
            currentValue = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: currentValue!)
        }
        
        for i in 0...(count - 1) {
            let q = DispatchQueue(label: "", attributes: .concurrent)
            q.asyncAfter(wallDeadline: .now() + Double.random(in: 0...0.1)) {
                self.samples[i].resultValue = Util.parseDateForSave(self.samples[i].value)
            }
        }
    }
    
    func checkTestDatesToString() {
        for i in 0...(count - 1) {
            print("check value = \(samples[i].value), resultValue = \(samples[i].resultValue)")
            
            if samples[i].resultValue != Util.parseDateForSave(samples[i].value) {
                print("ERROR !!! ")
            }
        }
    }
    
    
}


struct DateToString {
    var id : Int
    var value : Date
    var resultValue : String = ""
    
    init(id: Int, value: Date) {
        self.id = id
        self.value = value
    }
}
