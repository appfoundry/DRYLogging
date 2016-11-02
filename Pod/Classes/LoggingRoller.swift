//
//  LoggingRoller.swift
//  Pods
//
//  Created by Michael Seghers on 29/10/2016.
//
//

import Foundation

/**
 *  A logging roller is responsible for rolling over files. The goal is to not make the logging
 *  system clutter the system with large files or too many log files.
 *
 *  @since 3.0
 */
public protocol LoggingRoller {
    func rollFile(atPath:String)
}
