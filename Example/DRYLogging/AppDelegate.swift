//
//  AppDelegate.swift
//  DRYLogging
//
//  Created by Michael Seghers on 28/10/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import UIKit
import DRYLogging

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var logger:Logger = LoggerFactory.logger(named: "ui.appdelegate")
    
    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.setupRootLogger()
        logger.logLevel = .trace
        logger.trace("awesome")
        
        return true
    }
    
    func setupRootLogger() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let formatter = ClosureBasedMessageFormatter(closure: {
            return "[\($0.level) - \(df.string(from: $0.date))] <T:\($0.threadName) - S:\($0.className) - M:\($0.methodName) - L:\($0.lineNumber)> - \($0.message)"
        })
        
        LoggerFactory.rootLogger.add(appender: ConsoleAppender(formatter: formatter))
    }
}
