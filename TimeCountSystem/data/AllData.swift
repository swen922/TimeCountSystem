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
    
    static var colorsChartR : [BarColor] = []
    static var colorsChartG : [BarColor] = []
    static var colorsChartB : [BarColor] = []
    static var colorsCharts : [[BarColor]] = []
    
    
    
    static func generateBarColors() {
        
        colorsCharts.removeAll()
        colorsChartR.removeAll()
        colorsChartG.removeAll()
        colorsChartB.removeAll()
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.colorsChartBase[c], green: AllConst.halfChartPercent, blue: AllConst.brightChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.colorsChartLight[c], green: AllConst.mediumChartPercent, blue: AllConst.lightChartPercent, alpha: 1)
            colorsChartR.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.colorsChartBase[c], green: AllConst.brightChartPercent, blue: AllConst.halfChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.colorsChartLight[c], green: AllConst.lightChartPercent, blue: AllConst.mediumChartPercent, alpha: 1)
            colorsChartR.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.halfChartPercent, green: AllConst.colorsChartBase[c], blue: AllConst.brightChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.mediumChartPercent, green: AllConst.colorsChartLight[c], blue: AllConst.lightChartPercent, alpha: 1)
            colorsChartG.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.brightChartPercent, green: AllConst.colorsChartBase[c], blue: AllConst.halfChartPercent, alpha: 1)
            let colorLight = NSColor(red: AllConst.lightChartPercent, green: AllConst.colorsChartLight[c], blue: AllConst.mediumChartPercent, alpha: 1)
            colorsChartG.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        

        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.halfChartPercent, green: AllConst.brightChartPercent, blue: AllConst.colorsChartBase[c], alpha: 1)
            let colorLight = NSColor(red: AllConst.mediumChartPercent, green: AllConst.lightChartPercent, blue: AllConst.colorsChartLight[c], alpha: 1)
            colorsChartB.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        for c in 0...(AllConst.colorsChartBase.count - 1) {
            let colorDark = NSColor(red: AllConst.brightChartPercent, green: AllConst.halfChartPercent, blue: AllConst.colorsChartBase[c], alpha: 1)
            let colorLight = NSColor(red: AllConst.lightChartPercent, green: AllConst.mediumChartPercent, blue: AllConst.colorsChartLight[c], alpha: 1)
            colorsChartB.append(BarColor(baseColor: colorDark, lightenColor: colorLight))
        }
        
        colorsCharts.append(colorsChartR)
        colorsCharts.append(colorsChartG)
        colorsCharts.append(colorsChartB)
        
    }
    
}
