# Usage

## Basic Example

```swift
import UIKit
import Combine
import TIOPagingKit

final class ViewController: UIViewController {

    private let tableView = TIOPagingTableView()

    private var cancellables = Set<AnyCancellable>()

    private var items = Array(0..<20)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bind()

        tableView.beginRefreshing()
    }
}

// MARK: - Setup

private extension ViewController {

    func setupTableView() {

        view.addSubview(tableView)

        tableView.frame = view.bounds

        tableView.delegate = self
        tableView.dataSource = self
    }

    func bind() {

        tableView.refreshPublisher
            .sink { [weak self] in
                self?.onRefresh()
            }
            .store(in: &cancellables)

        tableView.loadMorePublisher
            .sink { [weak self] in
                self?.onLoadMore()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension ViewController {

    func onRefresh() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            self.items = Array(0..<20)

            self.tableView.reloadData()

            self.tableView.resetNoMoreData()

            self.tableView.endRefreshing()
        }
    }

    func onLoadMore() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            let start = self.items.count
            let end = start + 20

            self.items.append(contentsOf: start..<end)

            self.tableView.reloadData()

            if self.items.count >= 100 {

                self.tableView.endLoadMoreWithNoMoreData()

            } else {

                self.tableView.endLoadMore()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = UITableViewCell()

        cell.textLabel?.text = "Item \(items[indexPath.row])"

        return cell
    }
}

extension ViewController: UITableViewDelegate {

}
```

---

# APIs

## Refresh

```swift
tableView.beginRefreshing()

tableView.endRefreshing()
```

## Load More

```swift
tableView.beginLoadMore()

tableView.endLoadMore()
```

## No More Data

```swift
tableView.endLoadMoreWithNoMoreData()

tableView.resetNoMoreData()
```

---

# Combine

## Refresh Publisher

```swift
tableView.refreshPublisher
```

## Load More Publisher

```swift
tableView.loadMorePublisher
```

---

# Custom Footer Title

```swift
let footer = MJRefreshAutoStateFooter()

footer.setTitle(
    "Bạn đã xem hết rồi 😄",
    for: .noMoreData
)

tableView.refreshFooter = footer
```

---

# Requirements

- iOS 13+
- Swift 5.9+
- UIKit

---

# License

TIOPagingKit is available under the MIT license.
