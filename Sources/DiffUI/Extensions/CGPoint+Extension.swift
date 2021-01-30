//
//  CGPoint+Extension.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

#if os(iOS) || os(tvOS)
import CoreGraphics

extension CGPoint: DFVectorRepresentable {
    
    public var asVector: Self.Vector { [x, y] }
    
    public static func from(vector: Self.Vector) -> CGPoint {
        return CGPoint(
            x: vector[safe: 0] ?? 0,
            y: vector[safe: 1] ?? 0
        )
    }
}
#endif
