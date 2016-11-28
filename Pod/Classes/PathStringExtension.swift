//
//  PathStringExtension.swift
//  Pods
//
//  Created by Michael Seghers on 30/10/2016.
//
//

import Foundation

extension String {
    
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        return (self as NSString).appendingPathExtension(ext)
    }
}
