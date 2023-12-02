//
//  MainViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 31.10.2023.
//

import UIKit

struct MainDataItem {
    let id: String
    let title: String
    let deadlineDate: Date
    var deadlineString: String {
        "\(L10n.Main.deadlineDescription) \(DateFormatter.dateFormate.string(from: deadlineDate))"
    }
    let isCompleted: Bool
}

final class MainViewController: ParentViewController {
    private var data: [MainDataItem] = []
    private var selectedItem: MainDataItem?
    private var statefulView: StatefullView? {
        return view as? StatefullView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        Task {
            await loadToDos()
        }
    }
    
    private func setupUI() {
        statefulView?.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            return section
        })
        
        createButton.setTitle(L10n.Main.button, for: .normal)
        createButton.setup(mode: .large)
    }
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var createButton: PrimaryButton!
    
    @IBAction func didTapCreateButton(_ sender: PrimaryButton) {
        navigateToNewItem()
    }
    
    private func loadToDos() async {
        statefulView?.state = .loading
        do {
            let todosResponse = try await NetworkManager.shared.fetchTodoList()
            self.data = todosResponse.map { MainDataItem(id: $0.id, title: $0.title, deadlineDate: $0.date, isCompleted: $0.isCompleted) }
            DispatchQueue.main.async {
                self.statefulView?.state = self.data.isEmpty ? .empty() : .data
                self.collectionView.reloadData()
            }
        } catch let fetchError {
            DispatchQueue.main.async {
                self.statefulView?.state = .empty(error: fetchError)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
            cell.setup(item: data[indexPath.row])
            return cell
        }
        fatalError("\(#function)error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedItem = data[indexPath.row]
        navigateToNewItem()
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {
        Task {
            await loadToDos()
        }
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        Task {
            await loadToDos()
        }
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
