//
//  Constants.swift
//  TimeCountSystem
//
//  Created by swen on 10.02.2026.
//

import Foundation
import Cocoa

class AllConst {
    
    static let pathSeparator = NSBrowser().pathSeparator
    static let folderInApplicationSupport = "TimeCountSystem"
    static let folderVersion1_2 = "version1.2"
    static let folderVersion2 = "version2"
    
    static let mainName = "Main"
    static let vc_empty = "vc_empty"
    static let vc_login = "vc_login"
    static let vc_admin = "vc_admin"
    static let vc_manager = "vc_manager"
    static let vc_designer = "vc_designer"

    static let notif_load_controller = "notif_load_controller"

    static let arg_key_source = "arg_key_source"
    static let arg_key_destination = "arg_key_destination"
    
    
    // CustomChart
    static let animDurationPart : CGFloat = 0.3
    static let animDurationBar : CGFloat = 0.5
    static let bottomPosition : CGFloat = -35
    static let textRectHeight : CGFloat = 25
    
    static let textColor1 : NSColor = NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)

    static let maxBarWidth : CGFloat = 120
    static let minimumBarWidth : CGFloat = 20
    static let maxFontSize : CGFloat = 18
    static let maxSizeCoeff : CGFloat = 3
    static let upScaleBarCoeff1 : CGFloat = 1.2
    static let upScaleBarCoeff2 : CGFloat = 1.25
    
    static let clickPause : CGFloat = 0.3
    static let barEnlargeDuration : CGFloat = 0.5
    static let barEnlargedDuration : CGFloat = 3
    static let barContractDuration : CGFloat = 1
    static let barCancelDuration : CGFloat = 0.5
    static let barMovingDuration : CGFloat = 0.5
    
    //static let colorsChartBase : [CGFloat] = [8/256, 16/256, 24/256, 32/256, 40/256, 48/256, 56/256, 64/256, 72/256, 80/256, 88/256, 96/256, 104/256, 112/256, 120/256, 128/256]
    static let colorsChartBase : [CGFloat] = [40/256, 44/256, 48/256, 52/256, 56/256, 60/256, 64/256, 68/256, 72/256, 76/256, 80/256, 84/256, 88/256, 92/256, 96/256, 100/256]
    static let colorsChartLight : [CGFloat] = [160/256, 164/256, 168/256, 172/256, 176/256, 180/256, 184/256, 188/256, 192/256, 196/256, 200/256, 204/256, 208/256, 212/256, 216/256, 220/256]
    static let halfChartPercent : CGFloat = 128/256
    static let mediumChartPercent : CGFloat = 192/256
    static let brightChartPercent : CGFloat = 224/256
    static let lightChartPercent : CGFloat = 240/256
}
