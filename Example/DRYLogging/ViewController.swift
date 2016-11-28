//
//  ViewController.swift
//  DRYLogging
//
//  Created by Michael Seghers on 03/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import UIKit
import DRYLogging

/**
 Demo view controller to show case logging of different levels. Make sure to activate the appropriate log level 
 to see the messages appear on the console!
 
 You could configure the log level in the viewDidLoad, but better is to configure the log level of the logger named
 "viewcontroller" in the app delegate, seperating config from code. Consult the DRYLogging documentation for more info!
 */
class ViewController: UIViewController {
    
    let logger:Logger = LoggerFactory.logger(named: "viewcontroller.DRYViewController")

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.trace("Controller view did load")
    }
    
    @IBAction func logTrace(_ sender: Any) {
        logger.trace("Logging a trace message")
    }
    
    @IBAction func logDebug(_ sender: Any) {
        logger.debug("Logging a debug message")
    }
    
    @IBAction func logInfo(_ sender: Any) {
        logger.info("Logging an info message")
    }
    
    @IBAction func logWarn(_ sender: Any) {
        logger.warn("Logging a warning message")
    }

    @IBAction func logError(_ sender: Any) {
        logger.error("Logging an error message")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logger.warn("Memory warning!")
    }

}
