//
//  Walker.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 8/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

// TODO: This should be nested but Swift b5 can't deal with that quite yet.
public struct _State <T> {
    var depth : Int = 0
    var stack : [T] = []

    func filler(_ string:String = " ") -> String {
        return String(count:self.depth, repeatedValue:Character(string))
    }
}

public struct Walker <T> {

    typealias State = _State <T>
    typealias Children = (node:T) -> [T]?
    typealias StatelessVisitor = (node:T, depth:Int) -> Void
    typealias StatefulVisitor = (node:T, state:State) -> Void

    let childrenBlock : Children!

    init(childrenBlock:Children) {
        self.childrenBlock = childrenBlock
    }

    func walk(node:T, visitor:StatefulVisitor) {
        self.walk(node, state:State(), visitor:visitor)
    }

    func walk(node:T, state:State, visitor:StatefulVisitor) {
        visitor(node:node, state:state)
        if let children = self.childrenBlock(node:node) {
        
            for child in children {
                let newState = State(depth:state.depth + 1, stack:state.stack + [child])
                walk(child, state:newState, visitor:visitor)
            }
        }
    }

    func walk(node:T, visitor:StatelessVisitor) {
        self.walk(node, depth:0, visitor:visitor)
    }

    func walk(node:T, depth:Int, visitor:StatelessVisitor) {
        visitor(node:node, depth:depth)
        if let children = self.childrenBlock(node:node) {
        
            for child in children {
                walk(child, depth:depth + 1, visitor:visitor)
            }
        }
    }
}

/*

// MARK: Example

// MARK: Types
class Node <T> {
    var value : T
    var children : [Node <T>] = []
    
    init(_ value:T) {
        self.value = value
    }
}

typealias StringNode = Node <String>

// MARK: Setup
let root = StringNode("Hello world")
root.children = [ StringNode("Child A"), StringNode("Child B") ]

// MARK: Walk
let walker = Walker <StringNode> () {
    node in
    return node.children
    }

walker.walk(root) {
    (node:StringNode, depth:Int) in
    println("\(depth): \(node)")
    }
    
walker.walk(root) {
    (node:StringNode, state:_State <StringNode>) in
    let filler = state.filler("\t")
    println("\(filler)\(node)\(state.stack)")
    }
   

*/