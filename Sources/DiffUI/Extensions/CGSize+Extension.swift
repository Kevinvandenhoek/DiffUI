//
//  CGSize+Extension.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

#if os(iOS) || os(tvOS)
import CoreGraphics

extension CGSize {
    
    /// returns width / height
    var aspectRatio: CGFloat { return width / height }
    
    var asPoint: CGPoint { return CGPoint(x: width, y: height) }
    
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }
    
    static func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }
    
    func sizeThatFits(in size: CGSize) -> CGSize {
        let ratio = min(
            size.width / width,
            size.height / height
        )
        
        return CGSize(
            width: width * ratio,
            height: height * ratio
        )
    }
    
    static func xy(_ amount: CGFloat) -> CGSize {
        return CGSize(width: amount, height: amount)
    }
}

// MARK: VectorRepresentable
extension CGSize: DFVectorRepresentable {
    
    public var asVector: Vector { [width, height] }
    
    public static func from(vector: Vector) -> CGSize {
        return .init(
            width: vector[safe: 0] ?? 0,
            height: vector[safe: 1] ?? 0
        )
    }
}
#endif
