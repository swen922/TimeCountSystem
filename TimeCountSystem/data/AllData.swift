//
//  AllData.swift
//  TimeCountSystem
//
//  Created by swen on 10.02.2026.
//

import Foundation
import Cocoa

class AllData {
    
    
    static var pathToClientBase : String = ""
    
    static var colorsChartR1 : [BarColor] = []
    static var colorsChartR2 : [BarColor] = []
    static var colorsChartG1 : [BarColor] = []
    static var colorsChartG2 : [BarColor] = []
    static var colorsChartB1 : [BarColor] = []
    static var colorsChartB2 : [BarColor] = []
    static var colorsCharts : [[BarColor]] = []
    
    
    
    static func generateBarColors() {
        
        colorsCharts.removeAll()
        colorsChartR1.removeAll()
        colorsChartR2.removeAll()
        colorsChartG1.removeAll()
        colorsChartG2.removeAll()
        colorsChartB1.removeAll()
        colorsChartB2.removeAll()
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.colorsChartBase[c], green: AllConst.mediumChartPercent, blue: AllConst.brightChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.colorsChartLight[c], green: AllConst.mediumChartPercent, blue: AllConst.lightChartPercent, alpha: 1)
            colorsChartR1.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.colorsChartBase[c], green: AllConst.brightChartPercent, blue: AllConst.mediumChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.colorsChartLight[c], green: AllConst.lightChartPercent, blue: AllConst.mediumChartPercent, alpha: 1)
            colorsChartR2.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.mediumChartPercent, green: AllConst.colorsChartBase[c], blue: AllConst.brightChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.mediumChartPercent, green: AllConst.colorsChartLight[c], blue: AllConst.lightChartPercent, alpha: 1)
            colorsChartG1.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.brightChartPercent, green: AllConst.colorsChartBase[c], blue: AllConst.mediumChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.lightChartPercent, green: AllConst.colorsChartLight[c], blue: AllConst.mediumChartPercent, alpha: 1)
            colorsChartG2.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        

        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.mediumChartPercent, green: AllConst.brightChartPercent, blue: AllConst.colorsChartBase[c], alpha: 1)
            let colorLight = NSColor(red: AllConst.mediumChartPercent, green: AllConst.lightChartPercent, blue: AllConst.colorsChartLight[c], alpha: 1)
            colorsChartB1.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.brightChartPercent, green: AllConst.mediumChartPercent, blue: AllConst.colorsChartBase[c], alpha: 1)
            let colorLight = NSColor(red: AllConst.lightChartPercent, green: AllConst.mediumChartPercent, blue: AllConst.colorsChartLight[c], alpha: 1)
            colorsChartB2.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        colorsCharts.append(colorsChartR1)
        colorsCharts.append(colorsChartR2)
        colorsCharts.append(colorsChartG1)
        colorsCharts.append(colorsChartG2)
        colorsCharts.append(colorsChartB1)
        colorsCharts.append(colorsChartB2)
        
    }
    
}
