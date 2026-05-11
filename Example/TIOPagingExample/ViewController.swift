//
//  ViewController.swift
//  TIOPagingExample
//
//  Created by QuangAnh on 8/5/26.
//

import UIKit
import TIOPagingKit
import Combine
class ViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var collectionView: TIOPagingCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 12
        
        layout.minimumInteritemSpacing = 12
        
        layout.sectionInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 32,
            height: 120
        )
        
        let view = TIOPagingCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        view.backgroundColor = .white
        
        view.delegate = self
        
        view.dataSource = self
        
        view.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        
        return view
    }()
    
    private var cancelBag =
        Set<AnyCancellable>()
    
    private var items: [Int] =
        Array(0..<20)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        bind()
    }
}

// MARK: - Configure

private extension ViewController {
    
    func configure() {
        
        title = "CollectionView"
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            
            collectionView.leftAnchor.constraint(
                equalTo: view.leftAnchor
            ),
            
            collectionView.rightAnchor.constraint(
                equalTo: view.rightAnchor
            ),
            
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}

// MARK: - Bind

private extension ViewController {
    
    func bind() {
        
        collectionView.refreshPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                
                self?.onRefresh()
            }
            .store(in: &cancelBag)
        
        collectionView.loadMorePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                
                self?.onLoadMore()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Action

private extension ViewController {
    
    func onRefresh() {
        
        print("Refresh")
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {
            
            self.items =
                Array(0..<20)
            
            self.collectionView.reloadData()
            
            self.collectionView.endRefreshing()
            
            self.collectionView.resetLoadMore()
        }
    }
    
    func onLoadMore() {
        
        print("Load More")
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {
            
            let currentCount =
                self.items.count
            
            let newItems =
                Array(
                    currentCount..<(currentCount + 20)
                )
            
            self.items.append(
                contentsOf: newItems
            )
            
            self.collectionView.reloadData()
            
            if self.items.count >= 60 {
                
                self.collectionView
                    .endLoadMoreWithNoData()
                
            } else {
                
                self.collectionView
                    .endLoadMore()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController:
    UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        
        cell.backgroundColor = .red
        
        cell.layer.cornerRadius = 16
        
        cell.layer.masksToBounds = true
        
        let tag = 999
        
        let titleLabel: UILabel
        
        if let label = cell.contentView.viewWithTag(tag)
            as? UILabel {
            
            titleLabel = label
            
        } else {
            
            let label = UILabel()
            
            label.tag = tag
            
            label.font = .boldSystemFont(
                ofSize: 20
            )
            
            label.textColor = .white
            
            cell.contentView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                
                label.centerXAnchor.constraint(
                    equalTo: cell.contentView.centerXAnchor
                ),
                
                label.centerYAnchor.constraint(
                    equalTo: cell.contentView.centerYAnchor
                )
            ])
            
            titleLabel = label
        }
        
        titleLabel.text =
            "\(items[indexPath.item])"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController:
    UICollectionViewDelegate {
    
}
