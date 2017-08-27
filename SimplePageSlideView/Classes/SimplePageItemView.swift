//
//  SimplePageItemView.swift
//  Pods
//
//  Created by ChenWeizhen on 26/01/2017.
//
//

import Foundation

enum Direction {
    case up
    case down
}

protocol SimplePageItemViewDelegate: class {
    func itemView(willMoveTo direction: Direction)
}

class SimplePageItemView: UIView {
    fileprivate let triggerHeight: CGFloat = 50
    weak var delegate: SimplePageItemViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        //        scrollView.snp.makeConstraints { (make) in
        //            make.edges.equalToSuperview()
        //            make.width.height.equalToSuperview()
        //        }
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
            //            contentView.snp.makeConstraints({ (make) in
            //                make.width.edges.equalToSuperview()
            //            })
        }
    }
}

extension SimplePageItemView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < -triggerHeight {
            delegate?.itemView(willMoveTo: .up)
        }
        
        if offsetY > scrollView.contentSize.height - bounds.height + triggerHeight {
            delegate?.itemView(willMoveTo: .down)
        }
    }
}
