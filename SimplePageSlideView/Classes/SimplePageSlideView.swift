//
//  SimplePageSlideView.swift
//  Pods
//
//  Created by ChenWeizhen on 26/01/2017.
//
//

import UIKit


protocol SlideContainerViewDataSource: class {
    func itemView(in containerView: SlideContainerView, willMoveTo direction: Direction) -> UIView?
}

class SlideContainerView: UIView {
    weak var dataSource: SlideContainerViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainScrollView)
        mainScrollView.addSubview(v1)
        mainScrollView.addSubview(v2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        slideItemView(willMoveTo: .down)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        mainScrollView.frame = bounds
        mainScrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * 2)
        
        v1.frame.origin = CGPoint(x: 0, y: 0)
        v1.frame.size = bounds.size
        v2.frame.origin = CGPoint(x: 0, y: bounds.height)
        v2.frame.size = bounds.size
        
        mainScrollView.setContentOffset(current.frame.origin, animated: true)
    }
    
    func slideTo(direction: Direction) {
        slideItemView(willMoveTo: direction)
    }
    
    func reload(current: UIView, scrollTarget: UIView? = nil) {
        self.current.contentView = current
        layoutIfNeeded()
        setNeedsLayout()
        
        let scrollView = self.current.scrollView
        guard scrollView.contentSize.height > scrollView.frame.height else {return}
        
        if let scrollTarget = scrollTarget {
            let rect = scrollTarget.convert(scrollTarget.bounds, to: scrollView)
            self.current.scrollView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: true)
        }
    }
    
    fileprivate lazy var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = false
        return sv
    }()
    fileprivate lazy var current: SimplePageItemView = SimplePageItemView()
    fileprivate lazy var v1: SimplePageItemView = SimplePageItemView()
    fileprivate lazy var v2: SimplePageItemView = SimplePageItemView()
}

extension SlideContainerView {
    func slideItemView(willMoveTo direction: Direction) {
        guard let nextItemView = self.dataSource?.itemView(in: self, willMoveTo: direction) else { return }
        
        if direction == .up {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: bounds.height), animated: false)
            v2.contentView = current.contentView
            v1.contentView = nextItemView
            current = v1
        } else {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            v1.contentView = current.contentView
            v2.contentView = nextItemView
            current = v2
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
