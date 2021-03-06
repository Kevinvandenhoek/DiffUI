//
//  DFScrollView.swift
//  DiffUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit
import EasyPeasy

open class DFScrollView: UIScrollView, UpdatableView {
    
    // MARK: Open properties
    open var axis: DFAxis = .vertical {
        didSet { stackView.axis = axis; viewContainer.easy.reload() }
    }
    open var views: [View] = [] {
        didSet { stackView.set(elements: views) }
    }
    open var adjustContentForSafeAreaEdges: DFInsetEdges = .all {
        didSet { setInsetsWithSafeAreaEdgesThatAreProvided() }
    }
    open var insets: UIEdgeInsets = .zero {
        didSet { setInsetsWithSafeAreaEdgesThatAreProvided() }
    }
    open override var delaysContentTouches: Bool {
        didSet { didManuallySetDelaysContentTouches = true }
    }
    
    // MARK: Private properties
    private lazy var viewContainer: DFViewContainer = makeViewContainer()
    private lazy var stackView: UIStackView = makeStackView()
    
    private let isKeyboardAvoiding: Bool
    private var contentSizeObservation: NSKeyValueObservation?
    
    private var didManuallySetDelaysContentTouches = false
    
    // MARK: Lifecycle
    required public init?(coder aDecoder: NSCoder) {
        self.isKeyboardAvoiding = false
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        self.isKeyboardAvoiding = false
        super.init(frame: frame)
        setup()
    }
    
    init(isKeyboardAvoiding: Bool, endsEditingWhenTapped: Bool = true) {
        self.isKeyboardAvoiding = isKeyboardAvoiding
        super.init(frame: .zero)
        setup()
        if endsEditingWhenTapped {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
            tap.cancelsTouchesInView = false
            addGestureRecognizer(tap)
        }
    }
    
    deinit {
        guard isKeyboardAvoiding else { return }
        NotificationCenter.default.removeObserver(self)
    }
    
    @available(iOS 11.0, *)
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setInsetsWithSafeAreaEdgesThatAreProvided()
    }
    
    func setupKeyboardAvoiding() {
        // TODO: Implement
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isKeyboardAvoiding else { return }
//        tpKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
}

// MARK: Updatable
public extension DFScrollView {
    
    func update(with viewModel: ViewModel?) {
        self.views = viewModel?.views ?? self.views
        self.insets = viewModel?.insets ?? self.insets
        self.axis = viewModel?.axis ?? self.axis
        self.adjustContentForSafeAreaEdges = viewModel?.adjustContentForSafeAreaEdges ?? self.adjustContentForSafeAreaEdges
    }
}

// MARK: Actions
@objc private extension DFScrollView {
    
    func didTapScrollView() {
        parentViewController?.view.endEditing(true)
    }
}

// MARK: Private update methods
private extension DFScrollView {
    
    func setInsetsWithSafeAreaEdgesThatAreProvided() {
        viewContainer.insets = insets + tfSafeAreaInsets.filtered(by: adjustContentForSafeAreaEdges)
    }
    
    private func makeView(for viewModel: ViewModel) -> UIView {
        let stackView = UIStackView()
        stackView.axis = viewModel.axis
        stackView.spacing = 0
        stackView.set(elements: viewModel.views)
        return stackView
    }
}

// MARK: Private setup methods
private extension DFScrollView {
    
    func setup() {
        setScrollIndicatorsHidden(true)
        backgroundColor = .clear
        fill(with: viewContainer)
        viewContainer.easy.layout(
            CenterX().when({ [weak self] in self?.axis == .vertical }),
            Width(*1).like(self, .width).when({ [weak self] in self?.axis == .vertical }),
            CenterY().when({ [weak self] in self?.axis == .horizontal }),
            Height(*1).like(self, .width).when({ [weak self] in self?.axis == .horizontal })
        )
        if #available(iOS 11.0, *) { contentInsetAdjustmentBehavior = .never }
        if isKeyboardAvoiding { setupKeyboardAvoiding() }
        contentSizeObservation = observe(\.contentSize, changeHandler: { [weak self] _, _ in
            guard let self = self, !self.didManuallySetDelaysContentTouches else { return }
            self.delaysContentTouches = self.canScrollVertically
            self.didManuallySetDelaysContentTouches = false
        })
    }
    
    func makeViewContainer() -> DFViewContainer {
        let viewContainer = DFViewContainer(with: stackView)
        return viewContainer
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView(axis, spacing: 0, elements: views)
        return stackView
    }
}

public extension DFScrollView {
    
    typealias View = UIStackView.Element
    
    /**
     - parameter content: The view(s) to stack in the scrollView
     - parameter axis: The direction in which the scrollView will stack it's content. Content will be stretched across the perpendicular axis.
     - parameter insets: The insets of the content within the scrollView. These will be accumulated with the given safe area insets from edges included in adjustContentForSafeAreaEdges. Defaults to .pageDefault, which is what almost every page in the app uses.
     - parameter adjustContentForSafeAreaEdges: The safe area edges to which the content will adjust (with contentInset). Defaults to .all, which is generally what you want for a regular layout.
     */
    struct ViewModel: Equatable {
        let views: [View]
        let axis: DFAxis
        let insets: UIEdgeInsets
        let adjustContentForSafeAreaEdges: DFInsetEdges
        
        init(views: [UIStackView.Element], axis: DFAxis = .vertical, insets: UIEdgeInsets = .zero, adjustContentForSafeAreaEdges: DFInsetEdges = .all) {
            self.views = views
            self.axis = axis
            self.insets = insets
            self.adjustContentForSafeAreaEdges = adjustContentForSafeAreaEdges
        }
        
        func with(views: [View]) -> ViewModel {
            return ViewModel(
                views: views,
                axis: axis,
                insets: insets,
                adjustContentForSafeAreaEdges: adjustContentForSafeAreaEdges
            )
        }
    }
}
#endif
