//
//  TIOPagingTableView.swift
//  TIOPagingKit
//
//  Created by QuangAnh on 8/5/26.
//

import UIKit
import Combine
import MJRefresh
open class TIOPagingTableView: UITableView {
    
    private let refreshSubject = PassthroughSubject<Void, Never>()
    private let loadMoreSubject = PassthroughSubject<Void, Never>()
    
    public var refreshPublisher: AnyPublisher<Void, Never> {
        refreshSubject.eraseToAnyPublisher()
    }
    
    public var loadMorePublisher: AnyPublisher<Void, Never> {
        loadMoreSubject.eraseToAnyPublisher()
    }
    
    public var isRefreshing: Bool {
        mj_header?.isRefreshing ?? false
    }
    
    public var isLoadingMore: Bool {
        mj_footer?.isRefreshing ?? false
    }
    
    public var refreshHeader: MJRefreshHeader? {
        didSet {
            setupRefreshHeader()
        }
    }
    
    public var refreshFooter: MJRefreshFooter? {
        didSet {
            setupRefreshFooter()
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    public func beginRefreshing() {
        mj_header?.beginRefreshing()
    }
    
    public func endRefreshing() {
        mj_header?.endRefreshing()
    }
    
    public func beginLoadMore() {
        mj_footer?.beginRefreshing()
    }
    
    public func endLoadMore() {
        mj_footer?.endRefreshing()
    }
    
    public func endLoadMoreWithNoData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    public func removeLoadMore() {
        mj_footer = nil
        refreshFooter = nil
    }
}

private extension TIOPagingTableView {

    func configure() {
        refreshHeader = TIORefreshAutoHeader()
        refreshFooter = TIORefreshAutoFooter()
    }

    func setupRefreshHeader() {
        mj_header = refreshHeader

        mj_header?.refreshingBlock = { [weak self] in
            self?.refreshSubject.send(())
        }
    }

    func setupRefreshFooter() {
        mj_footer = refreshFooter

        mj_footer?.refreshingBlock = { [weak self] in
            self?.loadMoreSubject.send(())
        }
    }
}
