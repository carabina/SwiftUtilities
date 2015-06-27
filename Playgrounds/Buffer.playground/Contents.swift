//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

public struct DispatchDataBuffer <T> {

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return count }
    public subscript (i: Int) -> T {
        get {
            return baseAddress[i]
        }
    }

    public init(start: UnsafePointer<T>, count: Int) {
        self.init()
    }

//    func generate() -> UnsafeBufferPointerGenerator<T>

    public var baseAddress:UnsafePointer <T>  {
        get {

            // TODO: Needs to be mutating. Wont work!
//            data = dispatch_data_create_map(data, nil, nil)

            return nil
        }
    }

    public var count:Int {
        return dispatch_data_get_size(data) / DispatchDataBuffer <T>.elementSize
    }

    // MARK: -

    public var data:dispatch_data_t

    public static var elementSize:Int {
        return max(sizeof(T), 1)
    }

    init() {
        data = dispatch_data_create(nil, 0, nil, nil)
    }
}

extension DispatchDataBuffer: BufferType {
}

let data = DispatchDataBuffer <Void> ()
data
