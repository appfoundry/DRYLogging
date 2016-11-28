//
//  BackupRollerSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class BackupRollerSpec : QuickSpec {
    override func spec() {
        describe("BackupRoller") {
            context("rolling a file on the document path") {
                let manager = FileManager.default
                var path:String!
                var pathFile1:String!
                var pathFile2:String!
                var pathFile3:String!
                var pathFile4:String!
                var documentPath:String!
                var roller:BackupRoller!
                
                beforeEach {
                    documentPath = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0])
                    path = documentPath.stringByAppendingPathComponent(path: "file.txt")
                    pathFile1 = documentPath.stringByAppendingPathComponent(path: "file1.txt")
                    pathFile2 = documentPath.stringByAppendingPathComponent(path: "file2.txt")
                    pathFile3 = documentPath.stringByAppendingPathComponent(path: "file3.txt")
                    pathFile4 = documentPath.stringByAppendingPathComponent(path: "file4.txt")
                    roller = BackupRoller(maximumNumberOfFiles: 4)
                }
                
                it("should rename file.txt to file1.txt") {
                    manager.createFile(atPath: path, contents: "content".data(using: .utf8), attributes: nil)
                    roller.rollFile(atPath: path)
                    expect(try? String(contentsOfFile: pathFile1)) == "content"
                }
                
                it("should rename file1.txt to file2.txt") {
                    manager.createFile(atPath: pathFile1, contents: "content".data(using: .utf8), attributes: nil)
                    roller.rollFile(atPath: path)
                    expect(try? String(contentsOfFile: pathFile2)) == "content"
                }
                
                it("should rename file2.txt to file3.txt") {
                    manager.createFile(atPath: pathFile2, contents: "content".data(using: .utf8), attributes: nil)
                    roller.rollFile(atPath: path)
                    expect(try? String(contentsOfFile: pathFile3)) == "content"
                }
                
                it("should delete file3.txt and move file2.txt to file3.txt") {
                    manager.createFile(atPath: pathFile2, contents: "content2".data(using: .utf8), attributes: nil)
                    manager.createFile(atPath: pathFile3, contents: "content3".data(using: .utf8), attributes: nil)
                    roller.rollFile(atPath: path)
                    expect(manager.fileExists(atPath: pathFile4)) == false
                    expect(try? String(contentsOfFile: pathFile3)) == "content2"
                }
                
                afterEach {
                    do {
                        for filePath in try manager.contentsOfDirectory(atPath: documentPath) {
                            try manager.removeItem(atPath: documentPath.stringByAppendingPathComponent(path: filePath))
                        }
                    } catch {
                        fail("could not remove files in document path \(documentPath): \(error)")
                    }
                }
            }
        }
    }
}
