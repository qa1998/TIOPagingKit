//
//  TIOPagingCollectionView.swift
//  TIOPagingKit
//
//  Created by QuangAnh on 8/5/26.
//

import UIKit
import Combine
import MJRefresh

open class TIOPagingCollectionView: UICollectionView {
    // MARK: - Publisher
    
    private let refreshSubject =
    PassthroughSubject<Void, Never>()
    
    private let loadMoreSubject =
    PassthroughSubject<Void, Never>()
    
    public var refreshPublisher:
    AnyPublisher<Void, Never> {
        
        refreshSubject.eraseToAnyPublisher()
    }
    
    public var loadMorePublisher:
    AnyPublisher<Void, Never> {
        
        loadMoreSubject.eraseToAnyPublisher()
    }
    
    // MARK: - State
    
    public var isRefreshing: Bool {
        mj_header?.isRefreshing ?? false
    }
    
    public var isLoadingMore: Bool {
        mj_footer?.isRefreshing ?? false
    }
    
    // MARK: - Refresh
    
    public var refreshHeader:
    MJRefreshHeader? {
        
        didSet {
            setupRefreshHeader()
        }
    }
    
    public var refreshFooter:
    MJRefreshFooter? {
        
        didSet {
            setupRefreshFooter()
        }
    }
    
    // MARK: - Init
    
    public override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )
        
        configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
}

// MARK: - Public

public extension TIOPagingCollectionView {
    
    func beginRefreshing() {
        mj_header?.beginRefreshing()
    }
    
    func endRefreshing() {
        mj_header?.endRefreshing()
    }
    
    func beginLoadMore() {
        mj_footer?.beginRefreshing()
    }
    
    func endLoadMore() {
        mj_footer?.endRefreshing()
    }
    
    func endLoadMoreWithNoData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetLoadMore() {
        mj_footer?.resetNoMoreData()
    }
    
    func removeLoadMore() {
        
        mj_footer = nil
        
        refreshFooter = nil
    }
}

// MARK: - Private

private extension TIOPagingCollectionView {
    
    func configure() {
        
        refreshHeader =
        TIORefreshAutoHeader()
        
        refreshFooter =
        TIORefreshAutoFooter()
    }
    
    func setupRefreshHeader() {
        
        mj_header = refreshHeader
        
        mj_header?.refreshingBlock = {
            [weak self] in
            
            self?.refreshSubject.send(())
        }
    }
    
    func setupRefreshFooter() {
        
        mj_footer = refreshFooter
        
        mj_footer?.refreshingBlock = {
            [weak self] in
            
            self?.loadMoreSubject.send(())
        }
    }
}
