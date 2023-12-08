//
//  MainViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 31.10.2023.
//

import UIKit

final class MainViewController: ParentViewController {
    private var data: [TodoItemResponseBody] = []
    private var sections: [(date: Date, items: [TodoItemResponseBody])] = []
    private var selectedItem: TodoItemResponseBody?
    private var selectedDate: Date? {
        didSet {
            collectionView.reloadSections(IndexSet(integer: 1))
        }
    }

    private var statefulView: StatefullView? {
        view as? StatefullView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadToDos()
    }

    private func setupUI() {
        statefulView?.delegate = self

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)

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

    private func loadToDos() {
        Task {
            statefulView?.state = .loading
            do {
                self.data = try await NetworkManager.shared.fetchTodoList()
                sections = data
                    .reduce(into: [(date: Date, items: [TodoItemResponseBody])]()) { partialResult, item in
                        if let index = partialResult.firstIndex(where: { $0.date.withoutTimeStamp == item.date.withoutTimeStamp }) {
                            partialResult[index].items.append(item)
                        } else {
                            partialResult.append((date: item.date, items: [item]))
                        }
                    }
                    .sorted(by: { $0.date <= $1.date })

                self.statefulView?.state = self.data.isEmpty ? .empty() : .data
                self.collectionView.reloadData()
            } catch {
                self.statefulView?.state = .empty(error: error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as NewItemViewController:
            destination.delegate = self
            destination.selectedItem = selectedItem
            selectedItem = nil
        default:
            break
        }
    }

    private func navigateToNewItem() {
        performSegue(withIdentifier: "new-item", sender: nil)
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
                cell.setup(title: DateFormatter.dMMM.string(from: sections[indexPath.row].date))
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
                    cell.setup(item: item)
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
            selectedItem = data[indexPath.row]
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
    func didSelect(_: NewItemViewController) {
        loadToDos()
    }
}

extension MainViewController: MainItemCellDelegate {
    func didTapRadioButton(on cell: MainItemCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        var selectedItem = data[indexPath.row]
        Task {
            do {
                _ = try await NetworkManager.shared.markCompletion(todoId: selectedItem.id)
                selectedItem.isCompleted.toggle()
                data[indexPath.row] = selectedItem
                collectionView.reloadItems(at: [indexPath])
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: L10n.NetworkError.alertTitle, massage: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        loadToDos()
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
