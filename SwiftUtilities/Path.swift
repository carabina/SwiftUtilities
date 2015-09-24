//
//  Path.swift
//  Dterm 2
//
//  Created by Jonathan Wight on 8/6/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public struct Path {
    public let path: String
    public init(_ path: String) {
        self.path = path
    }

    public init(_ URL: NSURL) {
        self.path = URL.path!
    }
    public var url: NSURL {
        return NSURL(fileURLWithPath: path)
    }
}

// MARK: -

extension Path: CustomStringConvertible {
    public var description: String {
        return path
    }
}

// MARK: -

public extension Path {

    var components: [String] {
        return (path as NSString).pathComponents
    }

//    var parents: [Path] {
//    }

    var parent: Path? {
        return Path((path as NSString).stringByDeletingLastPathComponent)
    }

    var name: String {
        return (path as NSString).lastPathComponent
    }

    var pathExtension: String {
        return (path as NSString).pathExtension
    }

    var stem: String {
        return ((path as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    }

    func withName(name: String) -> Path {
        return parent! + name
    }

    func withPathExtension(pathExtension: String) -> Path {
        if pathExtension.isEmpty {
            return self
        }
        return withName(stem + "." + pathExtension)
    }

    func withStem(stem: String) -> Path {
        return (parent! + stem).withPathExtension(pathExtension)
    }
}

// MARK: -

public extension Path {
    static var applicationSupportDirectory: Path {
        let url = try! NSFileManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        return Path(url)
    }

    static var applicationSpecificSupportDirectory: Path {
        let bundle = NSBundle.mainBundle()
        let bundleIdentifier = bundle.bundleIdentifier!
        let path = applicationSupportDirectory + bundleIdentifier
        if path.exists == false {
            try! path.createDirectory(withIntermediateDirectories: true)
        }
        return path
    }
}

// MARK: -

public func + (lhs: Path, rhs: String) -> Path {
    let URL = lhs.url.URLByAppendingPathComponent(rhs)
    return Path(URL)
}

//func += (inout lhs: Path, rhs: String) -> Path {
//    let url = lhs.url.URLByAppendingPathComponent(rhs)
//    lhs = Path(url)
//    return lhs
//}

// MARK: -

public enum FileType {
    case Regular
    case Directory
}

// MARK: -

public extension Path {

    static var currentDirectory: Path {
        get {
            return Path(NSFileManager().currentDirectoryPath)
        }
        set {
            NSFileManager().changeCurrentDirectoryPath(newValue.path)
        }
    }
}

public extension Path {

    var exists: Bool {
        return url.checkResourceIsReachableAndReturnError(nil)
    }

    func getAttributes() throws -> [String : AnyObject] {
        let attributes = try NSFileManager().attributesOfItemAtPath(path)
        return attributes
    }

    var fileType: FileType! {
        switch try! getAttributes()[NSFileType] as! String {
            case NSFileTypeDirectory:
                return .Directory
            case NSFileTypeRegular:
                return .Regular
            default:
                return nil
        }
    }

    var isDirectory: Bool {
        return fileType == .Directory
    }

    func iter(@noescape closure: Path -> Void) {
        let enumerator = NSFileManager().enumeratorAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: nil)
        for url in enumerator! {
            closure(Path(url as! NSURL))
        }
    }


}

public extension Path {

    var permissions: Int {
        return try! getAttributes()[NSFilePosixPermissions] as! Int
    }

    func chmod(permissions: Int) throws {
        try NSFileManager().setAttributes([NSFilePosixPermissions: permissions], ofItemAtPath: path)
    }

}

// MARK: -

public extension Path {

    func createDirectory(withIntermediateDirectories withIntermediateDirectories: Bool = false, attributes: [String: AnyObject]? = nil) throws {
        try NSFileManager().createDirectoryAtPath(path, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }

}

public extension Path {
    func move(destination: Path) throws {
        try NSFileManager().moveItemAtURL(url, toURL: destination.url)
    }

    func remove() throws {
        try NSFileManager().removeItemAtPath(path)
    }
}

// MARK: -

public extension Path {
    func rotate() throws {
        if exists == false {
            return
        }
        var index = 1
        var newPath = self
        while true {
            if newPath.exists == false {
                try move(newPath)
                return
            }
            newPath = withStem(stem + " \(index)")
            ++index
        }
    }
}

public extension Path {
    var attributes: FileAttributes {
        return FileAttributes(path)
    }
}

public struct FileAttributes {

    private let path: String

    init(_ path: String) {
        self.path = path
    }

    private var url: NSURL {
        return NSURL(fileURLWithPath: path)
    }

    public var exists: Bool {
        return url.checkResourceIsReachableAndReturnError(nil)
    }

    public func getAttributes() throws -> [String : AnyObject] {
        let attributes = try NSFileManager().attributesOfItemAtPath(path)
        return attributes
    }

    public var fileType: FileType! {
        switch try! getAttributes()[NSFileType] as! String {
            case NSFileTypeDirectory:
                return .Directory
            case NSFileTypeRegular:
                return .Regular
            default:
                return nil
        }
    }

    public var isDirectory: Bool {
        return fileType == .Directory
    }

    public func iter(@noescape closure: Path -> Void) {
        let enumerator = NSFileManager().enumeratorAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: nil)
        for url in enumerator! {
            closure(Path(url as! NSURL))
        }
    }

    public var length: Int {
        return try! getAttributes()[NSFileSize] as! Int
    }

}



