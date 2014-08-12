//
//  main.swift
//  Testbed
//
//  Created by Jonathan Wight on 8/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

import SwiftUtilities

//// MARK: Types
//class Node <T> {
//    var value : T
//    var children : [Node <T>] = []
//    
//    init(_ value:T) {
//        self.value = value
//    }
//}
//
//typealias StringNode = Node <String>
//
//// MARK: Setup
//let root = StringNode("Hello world")
//root.children = [ StringNode("Child A"), StringNode("Child B") ]
//
//// MARK: Walk
//let walker = Walker <StringNode> () {
//    node in
//    return node.children
//    }
//
//walker.walk(root) {
//    (node:StringNode, depth:Int) in
//    println("\(depth): \(node)")
//    }
//    
//walker.walk(root) {
//    (node:StringNode, state:_State <StringNode>) in
//    let filler = state.filler("\t")
//    println("\(filler)\(node)\(state.stack)")
//    }
//   
