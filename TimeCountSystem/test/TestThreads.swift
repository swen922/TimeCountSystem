//
//  TestThreads.swift
//  TimeCountSystem
//
//  Created by swen on 11.02.2026.
//

import Foundation

class TestThreads {
    
    var checked : [Double : Int] = [:]
    
    var samples : [DoubleToInt] = []
    var updatedSamples : [DoubleToInt] = []
        
    var startValue : Double = 0
    var increment : Double = 0
    var count : Int = 0
    
    var currentValue : Double = 0
    
    init(startValue: Double, increment: Double, count: Int) {

        self.startValue = startValue
        self.increment = increment
        self.count = count
        
        self.currentValue = startValue
    }
    
    
    func testDoubleToInt() {
        
        print("TestThreads . start test !")
        
        currentValue = startValue
        
        for i in 1...count {
            samples.append(DoubleToInt(id: i, value: currentValue))
            currentValue += increment
        }
        
        for i in 0...(count - 1) {
            
            let value = self.samples[i].value

            let q = DispatchQueue(label: "", attributes: .concurrent)
            q.asyncAfter(wallDeadline: .now() + Double.random(in: 0...0.01)) {
                self.testDoubleToIntInside(value)
            }
        }
    }
    
    func testDoubleToIntInside(_ value : Double) {
        let newValue = Util.convertDoubleToInt(value)
        print("value = \(value), newValue = \(newValue)")
        
        if Double(newValue) / value != 10 {
            print("ERROR!!  ! - ! - !  value = \(value), newValue = \(newValue)")
        }
    }
    
    func checkTestDoubleToInt() {
        for i in 0...(count - 1) {
            print("check value = \(samples[i].value), resultValue = \(samples[i].resultValue)")
            
            //print("check value = \(samples[i].value), check newValue = \(checked[samples[i].value])")
            
            if checked[samples[i].value]! / Int(samples[i].value) != 10 {
                print("ERROR !!! ")
            }
        }
    }
    
}

struct DoubleToInt {
    var id : Int
    var value : Double
    var resultValue : Int = 0
    
    init(id: Int, value: Double) {
        self.id = id
        self.value = value
    }
}
