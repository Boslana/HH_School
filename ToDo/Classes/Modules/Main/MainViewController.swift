//
//  MainViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 31.10.2023.
//

import Dip
import UIKit

final class MainViewController: ParentViewController {
    @Injected private var networkManager: MainManager!

    private let refreshControl = UIRefreshControl()
    private var data: [TodoItemResponseBody] = []
    private var sections: [(date: Date, items: [TodoItemResponseBody])] = []
    private var selectedItem: TodoItemResponseBody?
    private var selectedDate: Date? {
        didSet {
            collectionView.reloadData()
            restoreSelectedDate()
        }
    }

    private var statefulView: StatefullView? {
        view as? StatefullView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl

        setupUI()
        loadToDos()
    }

    private func setupUI() {
        statefulView?.delegate = self

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: #selector(didTapProfileButton))

        collectionView.register(MainDateCell.self, forCellWithReuseIdentifier: MainDateCell.reuseID)
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.allowsMultipleSelection = true

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            }
        })

        createButton.setTitle(L10n.Main.button, for: .normal)
        createButton.setup(mode: .large)
    }

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var createButton: PrimaryButton!

    @IBAction private func didTapCreateButton(_: PrimaryButton) {
        navigateToNewItem()
    }

    private func loadToDos(shouldUpdateStatefulViewState: Bool = true, shouldEndRefreshing: Bool = false) {
        Task {
            if shouldUpdateStatefulViewState {
                statefulView?.state = .loading
            }
            do {
                self.data = try await networkManager.fetchTodoList()
                sections = data
                    .reduce(into: [(date: Date, items: [TodoItemResponseBody])]()) { partialResult, item in
                        if let index = partialResult.firstIndex(where: { $0.date.withoutTimeStamp == item.date.withoutTimeStamp }) {
                            partialResult[index].items.append(item)
                        } else {
                            partialResult.append((date: item.date, items: [item]))
                        }
                    }
                    .sorted(by: { $0.date <= $1.date })

                if let selectedDate, !sections.contains(where: { $0.date == selectedDate }) {
                    self.selectedDate = nil
                }

                self.statefulView?.state = self.data.isEmpty ? .empty() : .data
                self.collectionView.reloadData()
                restoreSelectedDate()
            } catch {
                self.statefulView?.state = .empty(error: error)
            }

            if shouldEndRefreshing {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    private func restoreSelectedDate() {
        if let selectedDate, let selectedDateIndex = sections.firstIndex(where: { $0.date == selectedDate }) {
            let dateIndexPath = IndexPath(row: selectedDateIndex, section: 0)
            collectionView.selectItem(at: dateIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }

    private func scrollToLastItem() {
        let itemCount = collectionView.numberOfItems(inSection: 1)

        guard itemCount > 0 else {
            return
        }

        let lastItemIndex = IndexPath(item: itemCount - 1, section: 1)
        collectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as NewItemViewController:
            destination.delegate = self
            destination.selectedItem = selectedItem
            destination.selectedDate = selectedDate
            selectedItem = nil
        default:
            break
        }
    }

    private func navigateToNewItem() {
        performSegue(withIdentifier: "new-item", sender: nil)
    }

    @objc
    private func didTapProfileButton() {
        performSegue(withIdentifier: "profile", sender: nil)
    }

    @objc
    private func didPullToRefresh(_: Any) {
        loadToDos(shouldUpdateStatefulViewState: false, shouldEndRefreshing: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sections.count
        default:
            if let selectedDate {
                return sections.first(where: { $0.date == selectedDate })?.items.count ?? 0
            }
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainDateCell.reuseID, for: indexPath) as? MainDateCell {
                let yearOfDate = sections[indexPath.row].date
                let isCurrentYear = Calendar.current.isDate(yearOfDate, equalTo: Date(), toGranularity: .year)
                let dateFormatter = isCurrentYear ? DateFormatter.dMMM : DateFormatter.dMMMyyyy

                cell.setup(title: dateFormatter.string(from: sections[indexPath.row].date))
                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
                let item: TodoItemResponseBody?
                if let selectedDate {
                    item = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
                } else {
                    item = data[indexPath.row]
                }
                if let item {
                    let cellData = MainItemCell.Data(from: item)
                    cell.setup(data: cellData)
                }

                cell.delegate = self
                return cell
            }
        }
        fatalError("\(#function)error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let pathes = (0 ..< collectionView.numberOfItems(inSection: 0)).map { IndexPath(row: $0, section: 0) }
            pathes.forEach { path in
                if path != indexPath {
                    collectionView.deselectItem(at: path, animated: true)
                }
            }
            selectedDate = sections[indexPath.row].date
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
            if let selectedDate {
                selectedItem = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
            } else {
                selectedItem = data[indexPath.row]
            }
            navigateToNewItem()
        }
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedDate = nil
        default:
            break
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_: NewItemViewController, action: ItemAction, date: Date?) {
        loadToDos()
        switch action {
        case .add:
            if selectedDate == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scrollToLastItem()
                }
            } else if let newDate = date, let selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: newDate) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scrollToLastItem()
                }
            }
        case .delete:
            break
        }
    }
}

extension MainViewController: MainItemCellDelegate {
    func didTapRadioButton(on id: String) {
        guard let index = data.firstIndex(where: { $0.id == id }) else {
            return
        }

        let isCompleted = data[index].isCompleted

        Task {
            do {
                _ = try await networkManager.markCompletion(todoId: id)
                if let newIndex = data.firstIndex(where: { $0.id == id }) {
                    data[newIndex].isCompleted = !isCompleted
                    if selectedDate == nil {
                        collectionView.reloadItems(at: [IndexPath(row: newIndex, section: 1)])
                    }
                }
                for (index, section) in sections.enumerated() {
                    if let newIndex = section.items.firstIndex(where: { $0.id == id }) {
                        sections[index].items[newIndex].isCompleted = !isCompleted
                        if selectedDate != nil {
                            collectionView.reloadItems(at: [IndexPath(row: newIndex, section: 1)])
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbar(message: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        loadToDos(shouldUpdateStatefulViewState: false)
    }

    func statefullViewDidTapEmptyButton(_: StatefullView) {
        navigateToNewItem()
    }

    func statefullView(_: StatefullView, addChild controller: UIViewController) {
        addChild(controller)
    }

    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController) {
        controller.didMove(toParent: self)
    }
}
