//
//  DFInsetEdges.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

public struct DFInsetEdges: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension DFInsetEdges {
    
    static let left = DFInsetEdges(rawValue: 1 << 0)
    static let top = DFInsetEdges(rawValue: 1 << 1)
    static let right = DFInsetEdges(rawValue: 1 << 2)
    static let bottom = DFInsetEdges(rawValue: 1 << 3)
    
    static let all: DFInsetEdges = [.left, .top, .right, .bottom]
    static let none: DFInsetEdges = []
}
