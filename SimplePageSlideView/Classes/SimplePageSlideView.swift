//
//  SimplePageSlideView.swift
//  Pods
//
//  Created by ChenWeizhen on 26/01/2017.
//
//

import UIKit

public protocol SimplePageSlideViewDataSource: class {
    func itemView(in containerView: SimplePageSlideView, willMoveTo direction: Direction) -> UIView?
}

public class SimplePageSlideView: UIView {
    public weak var dataSource: SimplePageSlideViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainScrollView)
        [v1, v2].forEach {
            $0.itemViewDelegate = self
            mainScrollView.addSubview($0)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        itemView(willMoveTo: .down)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        mainScrollView.frame = bounds
        mainScrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * 2)
        
        v1.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
        v2.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height), size: bounds.size)
        
        mainScrollView.setContentOffset(current.frame.origin, animated: true)
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

public extension SimplePageSlideView {
    public func slideTo(direction: Direction) {
        itemView(willMoveTo: direction)
    }
    
    public func reload(current: UIView, scrollTarget: UIView? = nil) {
        self.current.contentView = current
        layoutIfNeeded()
        setNeedsLayout()
        
        let scrollView = self.current
        guard scrollView.contentSize.height > scrollView.frame.height else {return}
        
        if let scrollTarget = scrollTarget {
            let rect = scrollTarget.convert(scrollTarget.bounds, to: scrollView)
            scrollView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: true)
        }
    }
}

extension SimplePageSlideView: SimplePageItemViewDelegate {
    func itemView(willMoveTo direction: Direction) {
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
