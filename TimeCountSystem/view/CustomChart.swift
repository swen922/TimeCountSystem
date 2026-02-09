//
//  CustomChart.swift
//  TimeCountSystem
//
//  Created by swen on 10.02.2026.
//

import Foundation
import Cocoa


class CustomChart {

    var chartParent : NSView
    var chartType : ChartType = .BARCHART
    var barsColor : NSColor?
    var colorZone : ColorZone = .BASE
    var timelineTitle : String?
    var valueTitle : String?
    
    var maxSum : CGFloat = 0 // for PartChart only
    var spacing : CGFloat = 0
    var roundCorners : CGFloat = 0
    var barStroke : CGFloat = 0

    // counts inside this class
    var items : [ChartItem] = []
    var currentMax : CGFloat = 0
    var currentSum : CGFloat = 0 // for PartChart only
    var parentWidth : CGFloat = 0
    var parentHeight : CGFloat = 0
    
    var usedColorsLight : [BarColor] = []
    var colorArray : Int = 0
    
    var countingChart : CustomChart?
    var mainChart : CustomChart?
    var isMainChart : Bool = false
    
    init?(inputParent: NSView, inputType : ChartType, inputModels : [ChartItemModel], inputColor : NSColor?, inputColorZone : ColorZone, inputSum : CGFloat?, inputSpacing : CGFloat, inputRoundness : CGFloat, inputStroke : CGFloat, inputChart : CustomChart?, inputMain : Bool) {
                
        if inputModels.count <= 0 {
            return nil
        }
        
        self.chartParent = inputParent
        self.chartType = inputType
        self.barsColor = inputColor
        self.colorZone = inputColorZone
        
        items.removeAll()
        for v in chartParent.subviews {
            v.removeFromSuperview()
        }
  
        self.roundCorners = inputRoundness
        self.barStroke = inputStroke
        self.spacing = inputSpacing
        
        isMainChart = inputMain
        if isMainChart {
            self.countingChart = inputChart
        } else {
            self.mainChart = inputChart
        }
        
        if let s = inputSum {
            self.maxSum = s
        }
        
        var values : [CGFloat] = []
        for model in inputModels {
            values.append(model.myValue)
        }
        
        self.parentWidth = chartParent.frame.width
        self.parentHeight = chartParent.frame.height
        self.currentMax = values.max()!
        self.currentSum = values.reduce(0, { partialResult, num in
            return partialResult + num
        })

        fillBars(inputModels)
    }
    
    
    func fillBars(_ inputModels : [ChartItemModel]) {
        if inputModels.count > 0 {
                        
            items.removeAll()
            colorArray = Int.random(in: 0...(AllData.colorsCharts.count - 1))
            
            var prevousRight : CGFloat = 0
            
            for i in 0...(inputModels.count - 1) {
                let box = Bar()
                self.chartParent.addSubview(box)
                
                let sizes = countBarSizes(inputCount: inputModels.count, inputPosition: i, inputValue: inputModels[i].myValue)
                var boxLeft = sizes[0]
                                
                if chartType == .PARTCHART {
                    boxLeft = prevousRight
                    prevousRight = prevousRight + sizes[1] + spacing
                }
                
                var nonNilColor : BarColor?
                if let color = self.barsColor {
                    nonNilColor = BarColor(baseColor: color, lightenColor: color)
                }
                else {
                    if let counting = countingChart, let color = counting.getBarColorForID(inputID: inputModels[i].projectID) {
                        nonNilColor = color
                    }
                    else {
                        nonNilColor = getcolorFromArray()
                    }
                }
                
                let delay = (chartType == .PARTCHART ? CGFloat(i) * AllConst.animDurationPart : nil)
                let barSize : RectSize = RectSize(left: boxLeft, posY: 0, width: sizes[1], height: sizes[2])
        
                let item = ChartItem(chartParent: chartParent, inputChart: self, inputBar: box, inputModel: inputModels[i], inputSize: barSize, inputColor: nonNilColor!, inputDelay: delay)
                box.chartItem = item
                items.append(item)
            }
        }
    }
    
    func recountBars() {
        
        self.parentWidth = chartParent.frame.width
        self.parentHeight = chartParent.frame.height
         
        if items.count > 0 {
            
            var prevousRight : CGFloat = 0
            
            for i in 0...(items.count - 1) {
                let item = items[i]
                let sizes = countBarSizes(inputCount: items.count, inputPosition: i, inputValue: item.myValue)
                
                var boxLeft = sizes[0]
                if chartType == .PARTCHART {
                    boxLeft = prevousRight
                    prevousRight = prevousRight + sizes[1] + spacing
                }
                
                let barSize : RectSize = RectSize(left: boxLeft, posY: 0, width: sizes[1], height: sizes[2])
                item.recountBarAndTitle(inputBarSize: barSize)
            }
        }
    }
    
    func countBarSizes(inputCount : Int, inputPosition : Int, inputValue : CGFloat) -> [CGFloat] {
        var boxWidth = (chartType == .BARCHART ? countBarChartWidth(inputCount) : (chartType == .PARTCHART ? countPartChartWidth(inputValue) : 0) )
        var boxHeight = (chartType == .BARCHART ? countBarChartHeght(inputValue) : (chartType == .PARTCHART ? parentHeight : parentHeight))
        let boxLeft = (chartType == .BARCHART ? countBarChartLeft(inputPosition, boxWidth) : (chartType == .PARTCHART ? 0 : 0) )
        boxWidth = (boxWidth < 2 ? 2 : boxWidth)
        boxHeight = (boxHeight < 2 ? 2 : boxHeight)
        return [boxLeft, boxWidth, boxHeight]
    }
    
    func countBarChartLeft(_ boxPos : Int, _ boxWidth : CGFloat) -> CGFloat {
        return CGFloat(boxPos) * (self.spacing + boxWidth)
    }
    
    func countBarChartWidth(_ barsCount : Int) -> CGFloat {
        return (parentWidth - (spacing * CGFloat(barsCount - 1)))  / CGFloat(barsCount)
    }
    
    func countBarChartHeght(_ value : CGFloat) -> CGFloat {
        let barsMax = (maxSum == 0 ? parentHeight : (maxSum < currentMax ? maxSum / currentMax * parentHeight : parentHeight) )
        let height = value / currentMax * barsMax
        return height
    }
    
    func countPartChartWidth(_ value : CGFloat) -> CGFloat {
        let max = (maxSum > 0 ? maxSum : currentSum)
        return value / max * parentWidth
    }
    
    func getcolorFromArray() -> BarColor {
        let colors = AllData.colorsCharts[colorArray]
        colorArray += 1
        colorArray = (colorArray < AllData.colorsCharts.count ? colorArray : 0)
        
        let barColor = colors[Int.random(in: 0...(colors.count - 1))]
        
        return barColor
    }
    
    func getBarColorForID(inputID : Int?) -> BarColor? {
        if let id = inputID {
            for item in items {
                if let result = item.getBarColor(id) {
                    return result
                }
            }
        }
        return nil
    }
    
    func acceptBar(_ inputBar : NSBox, inputID : Int?) {
        if let id = inputID {
            for item in items {
                if id == item.projectID {
                    item.acceptBar(inputBar)
                    break
                }
            }
        }
    }
    
    
}


class ChartItem {
    
    var myParent : NSView
    var myChart : CustomChart
    
    var myBar : NSBox
    var myValue : CGFloat = 0
    var myBarColor : BarColor
    
    var projectID : Int?
    
    var titleField : NSTextField?
    var timelineField : NSTextField?
    
    var myTitle : String = ""
    var myTimeline : String = ""
    
    var titlePosition : TextPosition?
    var timelinePosition : TextPosition?
    
    var titlePosY : CGFloat?
    var timelinePosY : CGFloat?
    
    var titleCoeff : CGFloat = 1
    var timelineCoeff : CGFloat = 1
    
 
    init(chartParent : NSView, inputChart : CustomChart, inputBar : NSBox, inputModel : ChartItemModel, inputSize : RectSize, inputColor : BarColor, inputDelay : CGFloat?) {
        
        myParent = chartParent
        myChart = inputChart
        
        myBar = inputBar
        myBar.boxType = .custom
        
        myValue = inputModel.myValue
        myBarColor = inputColor
    
        projectID = inputModel.projectID

        myBar.fillColor = (myChart.colorZone == .BASE ? myBarColor.baseColor : myBarColor.lightenColor)
        myBar.cornerRadius = myChart.roundCorners
        myBar.borderWidth = myChart.barStroke
        myBar.frame = CGRect()
        
        var titleSize : RectSize?
        if let titleModel = inputModel.titleModel {
            myTitle = titleModel.text
            titleCoeff = titleModel.coeff
            titleCoeff = (titleCoeff < 0 ? 1 : (titleCoeff <= AllConst.maxSizeCoeff ? titleCoeff : AllConst.maxSizeCoeff) )
            titlePosition = titleModel.position
            
            initTextBlock(titleModel)
            
            titleSize = getTextRectSize(inputRect: inputSize, textType: .TITLE)
        }
        
        var timelineSize : RectSize?
        if let timelineModel = inputModel.timelineModel {
            myTimeline = timelineModel.text
            timelineCoeff = timelineModel.coeff
            timelineCoeff = (timelineCoeff < 0 ? 1 : (timelineCoeff <= AllConst.maxSizeCoeff ? timelineCoeff : AllConst.maxSizeCoeff) )
            timelinePosition = timelineModel.position
            
            initTextBlock(timelineModel)
            
            timelineSize = getTextRectSize(inputRect: inputSize, textType: .TIMELINE)
        }
        
        countBarForUpScale(inputSize)
        
        setSizeAndLeftAnimated(chartType: myChart.chartType, inputBarSize: inputSize, inputTitleSize: titleSize, inputTimelineSize: timelineSize, inputDelay: inputDelay)
    }
    
    func countBarForUpScale(_ inputSize : RectSize) {
        barWidth = inputSize.width
        barHeight = inputSize.height
        barWidthScaled1 = barWidth * AllConst.upScaleBarCoeff1
        barHeightScaled1 = barHeight * AllConst.upScaleBarCoeff1
        barWidthScaled2 = barWidth * AllConst.upScaleBarCoeff2
        barHeightScaled2 = barHeight * AllConst.upScaleBarCoeff2
        barOrigin = CGPoint(x: inputSize.left, y: 0)
        
        let xMoved1 = barOrigin.x + ((barWidth - barWidthScaled1) / 2)
        let yMoved1 = barOrigin.y + ((barHeight - barHeightScaled1) / 2)
        let xMoved2 = barOrigin.x + ((barWidth - barWidthScaled2) / 2)
        let yMoved2 = barOrigin.y + ((barHeight - barHeightScaled2) / 2)
        barOriginMoved1 = CGPoint(x: xMoved1, y: yMoved1)
        barOriginMoved2 = CGPoint(x: xMoved2, y: yMoved2)
    }
    

    
    func getTextRectSize(inputRect : RectSize, textType : TextType) -> RectSize {
        let counts = getTextFieldSizes(inputRect.width)
        
        let coeff = (textType == .TITLE ? self.titleCoeff : self.timelineCoeff)
        let fontSizeCoeff = getFontSizeCoeff(inputRect.width)
        let position = (textType == .TITLE ? self.titlePosition : self.timelinePosition)
        let diff = AllConst.textRectHeight - (AllConst.textRectHeight * coeff * fontSizeCoeff)
        let posY = position == .BOTTOM ? AllConst.bottomPosition + diff : inputRect.height
        
        let result = RectSize(left: counts[0], posY: posY, width: counts[1], height: AllConst.textRectHeight * coeff * fontSizeCoeff)
        return result
    }
    
    
    func initTextBlock(_ textModel : TextBlockModel) {

        var textField : NSTextField?
        if textModel.textType == .TITLE {
            self.titleField = NSTextField(string: textModel.text)
            textField = self.titleField
        }
        else {
            self.timelineField = NSTextField(string: textModel.text)
            textField = self.timelineField
        }
        
        myBar.addSubview(textField!)

        textField!.lineBreakMode = .byWordWrapping
        textField!.usesSingleLineMode = false
        
        textField!.stringValue = textModel.text
        
        textField!.frame = CGRect()
        textField!.alignment = .center
        textField!.textColor = AllConst.textColor1
                
        //textField!.backgroundColor = NSColor(red: 1, green: 1, blue: 0, alpha: 1)
        textField!.isBezeled = false   // TODO false
        textField!.drawsBackground = false
    }
    
    
    func setSizeAndLeftAnimated(chartType : ChartType, inputBarSize : RectSize, inputTitleSize : RectSize?, inputTimelineSize : RectSize?, inputDelay : CGFloat?) {

        let barWidth = (chartType == .BARCHART ? inputBarSize.width : 0)
        let barHeight = (chartType == .BARCHART ? 0 : inputBarSize.height)
        let zeroedBarSize : RectSize = RectSize(left: inputBarSize.left, posY: inputBarSize.posY, width: barWidth, height: barHeight)
        
        var zeroedTitleSize : RectSize?
        if let titleSize : RectSize = inputTitleSize {
            let titleWidth = barWidth == 0 ? 0 : titleSize.width
            let titleHeight = (barHeight == 0 ? 0 : titleSize.height)
            zeroedTitleSize = RectSize(left: titleSize.left, posY: titleSize.posY, width: titleWidth, height: titleHeight)
        }
        
        var zeroedTimelineSize : RectSize?
        if let timelineSize : RectSize = inputTimelineSize {
            let timelineWidth = barWidth == 0 ? 0 : timelineSize.width
            let timelineHeight = barHeight == 0 ? 0 : timelineSize.height
            zeroedTimelineSize = RectSize(left: timelineSize.left, posY: timelineSize.posY, width: timelineWidth, height: timelineHeight)
        }
        
        setBarAndTitle(barSize: zeroedBarSize, inputTitleSize: zeroedTitleSize, inputTimelineSize: zeroedTimelineSize, onCreate: true)
        
        let aDur = (chartType == .BARCHART ? AllConst.animDurationBar : AllConst.animDurationPart)
        
        if let delay = inputDelay {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay) {
                self.animateBarAndTitle(inputBarSize: inputBarSize, inputTitleSize: inputTitleSize, inputTimelineSize: inputTimelineSize, aDur)
            }
        }
        else {
            animateBarAndTitle(inputBarSize: inputBarSize, inputTitleSize: inputTitleSize, inputTimelineSize: inputTimelineSize, aDur)
        }
    }
    

    func recountBarAndTitle(inputBarSize : RectSize) {
        var titleSize : RectSize?
        if let _ = titleField {
            titleSize = getTextRectSize(inputRect: inputBarSize, textType: .TITLE)
        }
        
        var timelineSize : RectSize?
        if let _ = timelineField {
            timelineSize = getTextRectSize(inputRect: inputBarSize, textType: .TIMELINE)
        }
        
        countBarForUpScale(inputBarSize)
        
        setBarAndTitle(barSize: inputBarSize, inputTitleSize: titleSize, inputTimelineSize: timelineSize, onCreate: false)
    }
    
    
    func setBarAndTitle(barSize : RectSize, inputTitleSize : RectSize?, inputTimelineSize : RectSize?, onCreate : Bool) {
        myBar.frame.origin = CGPoint(x: barSize.left, y: 0)
        myBar.frame.size = CGSize(width: barSize.width, height: barSize.height)

        if let textField = self.titleField, let titleSize = inputTitleSize, let position = self.titlePosition {
            textField.frame.origin = CGPoint(x: titleSize.left, y: titleSize.posY)
            textField.frame.size = CGSize(width: titleSize.width, height: titleSize.height)
            countTextField(textField: textField, textType: .TITLE, textPosition: position, inputWidth: titleSize.width, onCreate: onCreate)
        }
        
        if let textField2 = self.timelineField, let timelineSize = inputTimelineSize, let position = self.timelinePosition {
            textField2.frame.origin = CGPoint(x: timelineSize.left, y: timelineSize.posY)
            textField2.frame.size = CGSize(width: timelineSize.width, height: timelineSize.height)
            countTextField(textField: textField2, textType: .TIMELINE, textPosition: position, inputWidth: timelineSize.width, onCreate: onCreate)
        }
    }
    
    
    func animateBarAndTitle(inputBarSize : RectSize, inputTitleSize : RectSize?, inputTimelineSize : RectSize?, _ animDuration : CGFloat) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = animDuration
            self.myBar.animator().frame.size = CGSize(width: inputBarSize.width, height: inputBarSize.height)
        }
        
        if let timelineSize = inputTimelineSize, let textField2 = self.timelineField {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + (animDuration * 1.1) ) {
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = animDuration
                    textField2.animator().frame.size = CGSize(width: timelineSize.width, height: timelineSize.height)
                }
            }
        }

        if let titleSize = inputTitleSize, let textField = self.titleField {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + (animDuration * 2.2) ) {
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = animDuration
                    textField.animator().frame.size = CGSize(width: titleSize.width, height: titleSize.height)
                }
            }
        }
    }
    
    
    func getTextFieldSizes(_ inputWidth : CGFloat) -> [CGFloat] {
        return [(inputWidth * 0.05) - 5, inputWidth * 0.9]
    }
    
    
    func countTextField(textField : NSTextField, textType : TextType, textPosition : TextPosition, inputWidth : CGFloat, onCreate : Bool) {
        if onCreate {
            textField.stringValue = (textType == .TITLE ? self.myTitle : self.myTimeline)
            let coeff = (textType == .TITLE ? self.titleCoeff : self.timelineCoeff)
            textField.font = .boldSystemFont(ofSize: AllConst.maxFontSize * coeff)
        }
        else {
            if inputWidth >= AllConst.minimumBarWidth {
                let coeff = (textType == .TITLE ? self.titleCoeff : self.timelineCoeff)
                textField.stringValue = (textType == .TITLE ? self.myTitle : self.myTimeline)
                var fontSize = AllConst.maxFontSize * getFontSizeCoeff(inputWidth)
                fontSize = fontSize * coeff
                textField.font = .boldSystemFont(ofSize: fontSize)
            }
            else {
                textField.stringValue = ""
                textField.font = .boldSystemFont(ofSize: 1)
            }
        }
    }
    
    
    func getFontSizeCoeff(_ inputWidth : CGFloat) -> CGFloat {
        var coeff = inputWidth / AllConst.maxBarWidth
        coeff = (coeff <= 1 ? coeff : 1)
        return coeff
    }
    
    
    func getBarColor(_ inputID : Int) -> BarColor? {
        if let id = self.projectID {
            if id == inputID {
                return self.myBarColor
            }
        }
        return nil
    }
    
    var canBreath : Bool = true
    var isClosing : Bool = false
    
    var barWidth : CGFloat = 1
    var barHeight : CGFloat = 1
    var barOrigin : CGPoint = CGPoint()
    
    var barWidthScaled1 : CGFloat = 1
    var barHeightScaled1 : CGFloat = 1
    var barWidthScaled2 : CGFloat = 1
    var barHeightScaled2 : CGFloat = 1
    
    var barOriginMoved1 : CGPoint = CGPoint()
    var barOriginMoved2 : CGPoint = CGPoint()
    
    
    /// Block code. Enlarge copy of NSBox and copy WorkTime to Main chart
    
    var movedBar = NSBox()
    
    func initMovedBar() {
        movedBar = NSBox()
        myParent.addSubview(movedBar)
        movedBar.boxType = .custom
        movedBar.fillColor = myBar.fillColor
        movedBar.cornerRadius = myBar.cornerRadius
        movedBar.borderWidth = myBar.borderWidth
        movedBar.frame.origin = myBar.frame.origin
        movedBar.frame.size = myBar.frame.size
    }
    
    
    func enlargeContextual() {
        
        if let _ = myChart.mainChart { // acts for counting Chart only!!!
            initMovedBar()
            movedBar.alphaValue = 1

            NSAnimationContext.runAnimationGroup { context in
                context.duration = AllConst.barEnlargeDuration
                self.movedBar.animator().frame.size = CGSize(width: barWidthScaled1, height: barHeightScaled1)
                self.movedBar.animator().frame.origin = barOriginMoved1
            } completionHandler: {
                self.breathing()
            }
        }
    }
    
    
    func breathing() {
        if !canBreath {return}
        NSAnimationContext.runAnimationGroup { context3 in
            context3.duration = AllConst.barEnlargedDuration
            self.movedBar.animator().frame.size = CGSize(width: self.barWidthScaled2, height: self.barHeightScaled2)
            self.movedBar.animator().frame.origin = self.barOriginMoved2
        } completionHandler: {
            if !self.canBreath {return}
            NSAnimationContext.runAnimationGroup { context4 in
                context4.duration = AllConst.barEnlargedDuration
                self.movedBar.animator().frame.size = CGSize(width: self.barWidthScaled1, height: self.barHeightScaled1)
                self.movedBar.animator().frame.origin = self.barOriginMoved1
            } completionHandler: {
                self.breathing()
            }
        }
    }
    
    func closeContextual() {
        canBreath = false
        
        if isClosing {return}
        isClosing = true
    
        NSAnimationContext.runAnimationGroup { context4 in
            context4.duration = AllConst.barCancelDuration
            self.movedBar.animator().frame.size = CGSize(width: self.barWidth, height: self.barHeight)
            self.movedBar.animator().frame.origin = self.barOrigin
        } completionHandler: {
            self.movedBar.alphaValue = 0
            self.movedBar.frame.size = CGSize(width: 0, height: 0)
            self.movedBar.removeFromSuperview()
            //self.canClick = true
            self.canBreath = true
            self.isClosing = false
        }
    }
    
    func enlargeBar() {
        
        if let _ = myChart.mainChart { // acts for counting Chart only!!!
            
            if movedBar.frame.size.width > barWidth {
                sendBar()
            }
            else {
                initMovedBar()
                movedBar.alphaValue = 1
        
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = AllConst.barEnlargeDuration
                    self.movedBar.animator().frame.size = CGSize(width: barWidthScaled1, height: barHeightScaled1)
                    self.movedBar.animator().frame.origin = barOriginMoved1
                } completionHandler: {
                    NSAnimationContext.runAnimationGroup { context3 in
                        context3.duration = AllConst.barEnlargedDuration
                        self.movedBar.animator().frame.size = CGSize(width: self.barWidthScaled2, height: self.barHeightScaled2)
                        self.movedBar.animator().frame.origin = self.barOriginMoved2
                    } completionHandler: {
                        NSAnimationContext.runAnimationGroup { context4 in
                            context4.duration = AllConst.barContractDuration
                            self.movedBar.animator().frame.size = CGSize(width: self.barWidth, height: self.barHeight)
                            self.movedBar.animator().frame.origin = self.barOrigin
                        } completionHandler: {
                            self.movedBar.alphaValue = 0
                            self.movedBar.frame.size = CGSize(width: 0, height: 0)
                            self.movedBar.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    
    func sendBar() {
        if let mainChart = self.myChart.mainChart {
            /// TODO operation with time
            movedBar.removeFromSuperview()
            mainChart.acceptBar(movedBar, inputID: self.projectID)
        }
    }
    
    
    func acceptBar(_ inputBar : NSBox) {
        
        inputBar.alphaValue = 0
        
        movedBar = NSBox()
        myParent.addSubview(movedBar)
        movedBar.boxType = .custom
        movedBar.fillColor = inputBar.fillColor
        movedBar.cornerRadius = inputBar.cornerRadius
        movedBar.borderWidth = inputBar.borderWidth
        movedBar.frame.origin = inputBar.frame.origin
        movedBar.frame.size = inputBar.frame.size
        movedBar.alphaValue = 1
        
        let diffY : CGFloat = 120
        
        movedBar.frame.origin = CGPoint(x: movedBar.frame.origin.x, y: movedBar.frame.origin.y + diffY)
                
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup { context2 in
                context2.duration = AllConst.barMovingDuration
                context2.allowsImplicitAnimation = true
                self.movedBar.animator().frame.origin = self.myBar.frame.origin
                self.movedBar.animator().frame.size = self.myBar.frame.size
                self.movedBar.animator().fillColor = self.myBar.fillColor
            } completionHandler: {
                self.movedBar.removeFromSuperview()
                self.movedBar.alphaValue = 0
            }
        }
        
    }
    
    
}



struct ChartItemModel {
    var myValue : CGFloat
   
    var titleModel : TextBlockModel?
    var timelineModel : TextBlockModel?
    
    var projectID : Int?
    
    init(inputValue: CGFloat, inputTitleModel: TextBlockModel?, inputTimelineModel : TextBlockModel?, inputID : Int?) {
        self.myValue = inputValue
        
        self.titleModel = inputTitleModel
        self.timelineModel = inputTimelineModel
        
        self.projectID = inputID
        
        if titleModel != nil && timelineModel != nil {
            if titleModel!.position == timelineModel!.position {
                titleModel!.position = .TOP
                timelineModel!.position = .BOTTOM
            }
        }
    }
}



struct TextBlockModel {
    let text : String
    let textType : TextType
    var coeff : CGFloat = 1
    var position : TextPosition
}

struct RectSize {
    let left : CGFloat
    let posY : CGFloat
    let width : CGFloat
    let height : CGFloat
}

struct BarColor : Equatable, Hashable {
    let baseColor : NSColor
    let lightenColor : NSColor
    
    static func == (lhs: BarColor, rhs: BarColor) -> Bool {
        lhs.baseColor == rhs.baseColor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(baseColor)
    }
}


enum ChartType {
    case BARCHART
    case PARTCHART
}

enum TextPosition {
    case TOP
    case BOTTOM
}

enum ColorZone {
    case BASE
    case LIGHTEN
}

enum TextType {
    case TITLE
    case TIMELINE
}


class Bar : NSBox {
    
    var chartItem : ChartItem?
    var rightClicked : Bool = false

    
    override func mouseDown(with event: NSEvent) {
        if rightClicked {return}
        
        if let _ = chartItem?.myChart.mainChart {  // acts for counting Chart only!!!
            self.chartItem?.enlargeBar()
        }
    }
    
    
    override func rightMouseDown(with event: NSEvent) {
        
        if let _ = chartItem?.myChart.mainChart { // acts for counting Chart only!!!
            
            if rightClicked {return}
            rightClicked = true
            
            self.chartItem?.enlargeContextual()
                    
            let menu = AcceptTimeMenu(title: AllStrings.contextMenuAgreeTimeTitle)
            menu.delegate = menu
            menu.myBar = self
            let itemAccept = NSMenuItem(title: AllStrings.contextMenuItemAgree, action: #selector(acceptItem), keyEquivalent: "")
            let itemCancel = NSMenuItem(title: AllStrings.cancel, action: #selector(cancelAccept), keyEquivalent: "")
            menu.addItem(itemAccept)
            menu.addItem(itemCancel)
            
            NSMenu.popUpContextMenu(menu, with: event, for: self)
        }
    }
    
    
    @objc
    func acceptItem() {
        //print("add item! ")
        chartItem?.sendBar()
        menuClosed()
        /// TODO accept
    }
    
    @objc
    func cancelAccept() {
        //print("cancel to add item ")
        menuClosed()
    }
    
    func menuClosed() {
        chartItem?.closeContextual()
        rightClicked = false
    }

}

class AcceptTimeMenu : NSMenu, NSMenuDelegate {
    
    var myBar : Bar?
    
    func menuDidClose(_ menu: NSMenu) {
        //print("menu closed ............. ")
        myBar?.menuClosed()
    }
    
    
}
