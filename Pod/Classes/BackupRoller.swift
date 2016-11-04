//
//  BackupRoller.swift
//  Pods
//
//  Created by Michael Seghers on 29/10/2016.
//
//

import Foundation

/**
 *  File roller which moves log files, augmenting their index and limiting them to the maximumNumberOfFiles.
 *  The naming of the file follows the format [fileName][index].[extension] bassed on the file being rolled.
 *
 *  The following list shows an example of how rolling happens for a file named "default.log" and a maximum of 4 files
 *
 *  * 1st roll
 *  ** default.log becomes default1.log
 *  * 2nd roll
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *  * 3rd roll
 *  ** default2.log becomes default3.log
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *  * 4th roll
 *  ** default3.log is deleted
 *  ** default2.log becomes default3.log
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *
 *  @since 3.0
 */
public struct BackupRoller : LoggingRoller {
    /**
     *  The number of files that should be kept before starting to delete te oldest ones.
     */
    public let maximumNumberOfFiles: UInt
    
    
    /**
     *  Convenience initializer, setting the maximumNumberOfFiles to 5
     */
    public init() {
        self.init(maximumNumberOfFiles: 5)
    }
    
    
    /**
     *  Designated initializer, initializing a backup roller with the given maximumNumberOfFiles
     */
    public init(maximumNumberOfFiles: UInt) {
        self.maximumNumberOfFiles = maximumNumberOfFiles
    }
    
    public func rollFile(atPath path: String) {
        objc_sync_enter(self)
        let fileName = path.lastPathComponent.stringByDeletingPathExtension
        let ext = path.pathExtension
        let directory = path.stringByDeletingLastPathComponent
        
        let operation = BackupRollerOperation(fileName: fileName, ext: ext, directory: directory, lastIndex: self.maximumNumberOfFiles - 1)
        operation.performRolling()
        
        objc_sync_exit(self)
    }
}

/**
 * Private helper class to perform the actual rolling
 */
private struct BackupRollerOperation {
    let fileName:String
    let ext:String
    let directory:String
    let lastIndex:UInt
    let fileManager:FileManager = FileManager.default
    
    func performRolling() {
        self.deleteLastFileIfNeeded()
        
        for index in stride(from: lastIndex, to: 0, by: -1) {
            self.moveFileToNextIndex(fromIndex: index)
        }
    }
    
    private func deleteLastFileIfNeeded() {
        let lastFile = self.file(atIndex:self.lastIndex)
        if self.fileManager.fileExists(atPath: lastFile) {
            do {
                try self.fileManager.removeItem(atPath: lastFile)
            } catch {
                print("Unable to delete last file: \(error)")
            }
        }
    }
    
    private func moveFileToNextIndex(fromIndex index:UInt) {
        let potentialExistingRolledFile = self.file(atIndex: index)
        if self.fileManager.fileExists(atPath: potentialExistingRolledFile) {
            let newPath = self.file(atIndex: index + 1)
            do {
                try self.fileManager.moveItem(atPath: potentialExistingRolledFile, toPath: newPath)
            } catch {
                print("Couldn't move file from \(potentialExistingRolledFile) to \(newPath): \(error)")
            }
        }
    }
    
    private func file(atIndex index:UInt) -> String {
        return self.directory.stringByAppendingPathComponent(path: "\(self.fileName)\(index == 0 ? "" : String(index)).\(self.ext)")
    }
    
    
}