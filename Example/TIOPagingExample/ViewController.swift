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
    let tableView = TIOPagingTableView()
    var cancel = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        onBind()
        
    }
    
    
    func onBind() {
        tableView.refreshPublisher.sink { _ in
            self.onRefresh()
        }.store(in: &cancel)
        
        tableView.loadMorePublisher.sink { _ in
            self.onLoadMore()
        }.store(in: &cancel)
    }
    
    func onRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.endRefreshing()
        }
    }
    func onLoadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.endLoadMoreWithNoData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

