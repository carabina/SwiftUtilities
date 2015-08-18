//
//  AssociatedObjects+Private.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation

// MARK: Associated Objects

public func getAssociatedObject(object: AnyObject, key: UnsafePointer<Void>) -> AnyObject? {
    return objc_getAssociatedObject(object, key)
}

public func setAssociatedObject(object: AnyObject, key: UnsafePointer<Void>, value: AnyObject) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

// TODO: Rename ObjCBox?
class StructWrapper: NSObject {
    var wrapped: Any
    init(wrapped: Any) {
        self.wrapped = wrapped
    }
}

public func getAssociatedWrappedObject(object: AnyObject, key: UnsafePointer<Void>) -> Any? {
    let wrapper = objc_getAssociatedObject(object, key) as! StructWrapper?
    if let wrapper = wrapper {
        return wrapper.wrapped
    }
    else {
        return nil
    }
}

public func setAssociatedWrappedObject(object: AnyObject, key: UnsafePointer<Void>, value: Any) {
    let wrapper = StructWrapper(wrapped: value)
    objc_setAssociatedObject(object, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}


public func getAssociatedWrappedObject <T> (object: AnyObject, key: UnsafePointer<Void>, defaultValue: T) -> T {
    let wrapper = objc_getAssociatedObject(object, key) as! StructWrapper?
    if let wrapper = wrapper {
        return wrapper.wrapped as! T
    }
    else {
        return defaultValue
    }
}

public func setAssociatedWrappedObject <T> (object: AnyObject, key: UnsafePointer<Void>, value: T) {
    let wrapper = StructWrapper(wrapped: value)
    objc_setAssociatedObject(object, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
