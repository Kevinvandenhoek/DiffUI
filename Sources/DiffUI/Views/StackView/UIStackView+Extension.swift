//
//  UIStackView+Extension.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit

public extension UIStackView {
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach({
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }
    
    func addArrangedSubviews(_ arrangedSubviews: UIView...) {
        arrangedSubviews.forEach({ addArrangedSubview($0) })
    }
    
    func addArrangedSubviews(_ arrangedSubviews: [UIView]) {
        arrangedSubviews.forEach({ addArrangedSubview($0) })
    }
    
    func addArrangedSubviews(_ arrangedSubviews: [UIView], separatorBuilder buildSeparator: () -> UIView) {
        for (index, arrangedSubview) in arrangedSubviews.enumerated() {
            addArrangedSubview(arrangedSubview)
            if index < arrangedSubviews.count - 1 {
                addArrangedSubview(buildSeparator())
            }
        }
    }
    
    func set(elements: Element...) {
        removeArrangedSubviews()
        elements.forEach({ add(element: $0) })
    }
    
    func set(elements: [Element]) {
        removeArrangedSubviews()
        elements.forEach({ add(element: $0) })
    }
    
    func add(elements: Element...) {
        elements.forEach({ add(element: $0) })
    }
    
    func add(elements: [Element]) {
        elements.forEach({ add(element: $0) })
    }
    
    func add(element: Element, at index: Int? = nil) {
        switch element {
        case .view(let view, let trailingSpace, let insets, let alignment):
            let viewToInsert: UIView
            if let insets = insets {
                viewToInsert = DFViewContainer(with: view, insets: insets, alignment: containerAlignment(for: alignment), hidesWhenContainedViewHides: true)
            } else if let alignment = alignment {
                viewToInsert = DFViewContainer(with: view, alignment: containerAlignment(for: alignment), hidesWhenContainedViewHides: true)
            } else {
                viewToInsert = DFViewContainer(with: view)
            }
            if let index = index {
                insertArrangedSubview(viewToInsert, at: index)
            } else {
                addArrangedSubview(viewToInsert)
            }
            if let trailingSpace = trailingSpace {
                if #available(iOS 11.0, *) {
                    setCustomSpacing(trailingSpace, after: viewToInsert)
                } else if let viewContainer = viewToInsert.superview as? DFViewContainer {
                    viewContainer.insets.bottom += trailingSpace
                }
            }
        case .space(let amount):
            if let index = index {
                insertArrangedSubview(DFSpacer(amount), at: index)
            } else {
                addArrangedSubview(DFSpacer(amount))
            }
        case .scrollViewFiller(let minimumHeight, let maximumHeight, let view):
            if let index = index {
                insertArrangedSubview(DFScrollViewFiller(minimumHeight: minimumHeight, maximumHeight: maximumHeight, containedView: view), at: index)
            } else {
                addArrangedSubview(DFScrollViewFiller(minimumHeight: minimumHeight, maximumHeight: maximumHeight, containedView: view))
            }
        }
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, elements: [Element] = []) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        set(elements: elements)
    }
}

public extension UIStackView {
    
    enum Element: Equatable {
        case view(_ view: UIView, trailingSpace: CGFloat? = nil, insets: UIEdgeInsets? = nil, alignment: CrossAxisAlignment? = nil)
        case space(_ amount: CGFloat)
        
        /// Use only 1 of these per scroll view
        case scrollViewFiller(minimumHeight: CGFloat, maximumHeight: CGFloat? = nil, view: UIView? = nil)
        
        public enum CrossAxisAlignment {
            case start
            case end
            case center
            case stretch
        }
    }
    
    private func containerAlignment(for alignment: Element.CrossAxisAlignment?) -> DFViewContainer.Alignment {
        guard let alignment = alignment else { return .stretch }
        switch alignment {
        case .start:
            return axis == .horizontal ? .top : .left
        case .end:
            return axis == .horizontal ? .bottom : .right
        case .center:
            return axis == .horizontal ? .centerVertically : .centerHorizontally
        case .stretch:
            return .stretch
        }
    }
}

extension UIStackView: DFVisibilityAnimatable {
    
    public func set(visible: Bool, animated: Bool) {
        arrangedSubviews.set(visible: visible, animated: animated)
    }
}
#endif
