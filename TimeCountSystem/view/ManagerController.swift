//
//  ManagerController.swift
//  TimeCountSystem
//
//  Created by swen on 10.02.2026.
//

import Cocoa

class ManagerController: NSViewController, NSWindowDelegate {
    
    var workTimeChart : CustomChart?
    var partChartLight : CustomChart?
    var partChartDark : CustomChart?
    
    @IBOutlet weak var chartParent: NSView!
    @IBOutlet weak var partChartLightParent: NSView!
    @IBOutlet weak var partChartDarkParent: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
        
        chartParent.layer?.backgroundColor = CGColor(red: 0.8, green: 1, blue: 1, alpha: 1)
        
        initCustomChart()
        
        initPartCharts()
    }
    
    
    func initCustomChart() {
        var models : [ChartItemModel] = []
        for i in 1...3 {
            let value = CGFloat.random(in: 2...12)
            let titleModel = TextBlockModel(text: "pixels \(value.rounded())", textType: .TITLE, coeff: 1.3, position: .TOP)
            let legendModel = TextBlockModel(text: "i = \(i)", textType: .TIMELINE, coeff: 1.2, position: .BOTTOM)
            let model = ChartItemModel(inputValue: value, inputTitleModel: titleModel, inputTimelineModel: legendModel, inputID: nil)
            models.append(model)
        }
        workTimeChart = CustomChart(inputParent: chartParent, inputType: .BARCHART, inputModels: models, inputColor: NSColor(red: 1, green: 0.5, blue: 0, alpha: 1), inputColorZone: .BASE, inputSum: nil, inputSpacing: 30, inputRoundness: 5, inputStroke: 0, inputChart: nil, inputMain: true)
        
        print("generateChars . end . models count = \(models.count)")
    }
    
    func initPartCharts() {
        var modelsLight : [ChartItemModel] = []
        for i in 1...5 {
            let value = CGFloat.random(in: 0.5...1.4)
            let titleModel = TextBlockModel(text: "part1 \(value.rounded())", textType: .TITLE, coeff: 1, position: .TOP)
            let legendModel = TextBlockModel(text: "p1 = \(i)", textType: .TIMELINE, coeff: 1, position: .BOTTOM)
            let model = ChartItemModel(inputValue: value, inputTitleModel: titleModel, inputTimelineModel: legendModel, inputID: i)
            modelsLight.append(model)
        }
        partChartLight = CustomChart(inputParent: partChartLightParent, inputType: .PARTCHART, inputModels: modelsLight, inputColor: nil, inputColorZone: .LIGHTEN, inputSum: nil, inputSpacing: 0, inputRoundness: 0, inputStroke: 0, inputChart: nil, inputMain: false)
        
        
        var modelsDark : [ChartItemModel] = []
        for i in 1...5 {
            let value = CGFloat.random(in: 0.5...1.4)
            let titleModel = TextBlockModel(text: "part2 \(value.rounded())", textType: .TITLE, coeff: 1, position: .TOP)
            let legendModel = TextBlockModel(text: "p2 = \(i)", textType: .TIMELINE, coeff: 1, position: .BOTTOM)
            let model = ChartItemModel(inputValue: value, inputTitleModel: titleModel, inputTimelineModel: legendModel, inputID: i)
            modelsDark.append(model)
        }
        partChartDark = CustomChart(inputParent: partChartDarkParent, inputType: .PARTCHART, inputModels: modelsDark, inputColor: nil, inputColorZone: .BASE, inputSum: nil, inputSpacing: 0, inputRoundness: 0, inputStroke: 0, inputChart: partChartLight, inputMain: true)
        
        partChartLight!.mainChart = partChartDark
    }
    
    
}

extension ManagerController {
    
    func windowDidResize(_ notification: Notification) {
        workTimeChart?.recountBars()
        partChartLight?.recountBars()
        partChartDark?.recountBars()
    }
}




