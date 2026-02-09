//
//  ViewController.swift
//  TimeCountSystem
//
//  Created by swen on 09.02.2026.
//

import Cocoa

class HostController: NSViewController {
    
    let mainStoryboard : NSStoryboard = NSStoryboard(name: AllConst.mainName, bundle: nil)
    var currentController : NSViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        initStaticData()
        initPaths()
    }

    override func viewDidAppear() {
        initWindow()
        delayedLoadNext(0.1)
        //loadController(identSource: Constants.vc_empty, identDest: Constants.vc_manager)
    }
    
    func initWindow() {
        view.window?.isMovableByWindowBackground = true
    }
    
    func initPaths() {
        AllData.pathToClientBase = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].relativePath + AllConst.pathSeparator + AllConst.folderInApplicationSupport
        print("AllData.pathToClientBase = \(AllData.pathToClientBase)")
        
        print("file exists = \(FileManager.default.fileExists(atPath: AllData.pathToClientBase))")
    }
    
    func initStaticData() {
        Util.initFormatters()
        AllData.generateBarColors()
        
        print("AllData.colorsChartR.count = \(AllData.colorsChartR.count)")
    }
    
    func delayedLoadNext(_ delay : CGFloat) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay) {
            self.loadController(identSource: AllConst.vc_empty, identDest: AllConst.vc_manager)
        }
    }
    
    func loadController(identSource : String, identDest : String) {
        let source = mainStoryboard.instantiateController(withIdentifier: identSource) as? NSViewController
        let destination = mainStoryboard.instantiateController(withIdentifier: identDest) as? NSViewController
        
        if let source = source, let destination = destination {
            for chld in self.children {
                chld.view.removeFromSuperview()
                chld.removeFromParent()
            }
            
            self.insertChild(source, at: 0)
            self.view.addSubview(source.view) /// Обязательно!!!
            //self.view.frame = source.view.frame
            
            let mySegue = SwapControllerSegue(identifier: "", source: source, destination: destination)
            mySegue.perform()
            currentController = destination
        }
    }


}

