//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

let suits = ["♥", "♣", "♦", "♠"]

let values = ["A", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "J", "Q", "K"]

var deck = suits.flatMap() {
    (suit: String) in
    return values.map() {
        (value: String) in
        return value + suit
    }
}

deck = random.shuffled(deck)

(deck[0], deck[1])
