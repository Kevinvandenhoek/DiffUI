//
//  CGFloat+Extension.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

#if os(iOS) || os(tvOS)
import Foundation

public extension CGFloat {
    
    func rounded(decimals: Int) -> CGFloat {
        let decimalMultiplier = pow(10, CGFloat(decimals))
        return CGFloat(Int((self * decimalMultiplier).rounded(.toNearestOrAwayFromZero))) / decimalMultiplier
    }
}

extension CGFloat: DFVectorRepresentable {
    
    public var asVector: Vector { [self] }
    
    public static func from(vector: Vector) -> CGFloat {
        return vector[0]
    }
}
#endif
