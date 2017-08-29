//
//  SimplePageItemView.swift
//  Pods
//
//  Created by ChenWeizhen on 26/01/2017.
//
//

import Foundation
import SnapKit

public enum Direction {
    case up
    case down
}

protocol SimplePageItemViewDelegate: class {
    func itemView(willMoveTo direction: Direction)
}

class SimplePageItemView: UIView {
    fileprivate let triggerHeight: CGFloat = 50
    weak var itemViewDelegate: SimplePageItemViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
//        delegate = self
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        let cs = [.top, .bottom, .leading, .trailing, .width, .height].map {
//            NSLayoutConstraint(item: scrollView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1.0, constant: 0)
//        }
//        cs.forEach {addConstraint($0)}
//        NSLayoutConstraint.activate(cs)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        return sv
    }()
    var contentView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            scrollView.addSubview(contentView)
           
            contentView.snp.makeConstraints({ (make) in
                make.width.edges.equalToSuperview()
            })

//            contentView.translatesAutoresizingMaskIntoConstraints = false
//            var cs = [.top, .bottom, .leading, .trailing, .width].map {
//                NSLayoutConstraint(item: contentView, attribute: $0, relatedBy: .equal, toItem: scrollView, attribute: $0, multiplier: 1.0, constant: 0)
//            }
//            cs.forEach {scrollView.addConstraint($0)}
//            NSLayoutConstraint.activate(cs)
        }
    }
}

extension SimplePageItemView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < -triggerHeight {
            itemViewDelegate?.itemView(willMoveTo: .up)
        }
        
        if offsetY > scrollView.contentSize.height - bounds.height + triggerHeight {
            itemViewDelegate?.itemView(willMoveTo: .down)
        }
    }
}
