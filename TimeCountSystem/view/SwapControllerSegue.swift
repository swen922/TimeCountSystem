//
//  SwapControllersSegue.swift
//  TimeCountSystem
//
//  Created by swen on 10.02.2026.
//

import Cocoa

class SwapControllerSegue: NSStoryboardSegue {
    
    override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
    }
    
    
    override func perform() {
        let source = self.sourceController as! NSViewController
        let destination = self.destinationController as! NSViewController
        
        //print("source size = \(source.view.frame.width) x \(source.view.frame.height) ")
        //print("destination size = \(destination.view.frame.width) x \(destination.view.frame.height) ")
        
        if let parentController = source.parent! as NSViewController? {
            parentController.insertChild(destination, at: 1)

            let targetSize = destination.view.frame.size
            let targetWidth = destination.view.frame.size.width
            let targetHeight = destination.view.frame.size.height
            
            source.view.wantsLayer = true
            destination.view.wantsLayer = true
            
            parentController.transition(from: source, to: destination, options: .crossfade)
            
            source.view.animator().setFrameSize(targetSize)
            destination.view.animator().setFrameSize(targetSize)
            
            let currenFrame = parentController.view.window?.frame
            let currentRect = NSRectToCGRect(currenFrame!)
            
            let diffW = (currentRect.width - targetWidth) / 2
            let diffH = (currentRect.height - targetHeight) / 2
            
            let newWindowRect = NSMakeRect(currentRect.origin.x  + diffW, currentRect.origin.y  + diffH, targetWidth, targetHeight)
            
            parentController.view.window?.setFrame(newWindowRect, display: true)
        }
        
    }

}
