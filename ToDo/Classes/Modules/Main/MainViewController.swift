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
        "Дедлайн: \(DateFormatter.dateFormate.string(from: deadlineDate))"
    }
    let isCompleted: Bool
}

final class MainViewController: ParentViewController {
    private var data: [MainDataItem] = []
    private var error: Error?
    private weak var emptyVC: EmptyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        Task {
            await loadToDos()
        }
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.allowsMultipleSelection = true
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
    
    private func loadToDos() async {
        do {
            let todosResponse = try await NetworkManager.shared.fetchTodoList()
            self.data = todosResponse.map { MainDataItem(id: $0.id, title: $0.title, deadlineDate: $0.date, isCompleted: $0.isCompleted) }
            error = nil
        } catch let fetchError {
            error = fetchError
        }
        DispatchQueue.main.async {
            self.reload()
        }
    }
    
    private func reload() {
        if let error = error {
            let customError: EmptyViewController.Error = error is NetworkError ? .noConnection : .otherError
            
            emptyVC?.state = .error(customError)
            emptyVC?.action = { [weak self] in
                Task {
                    await self?.loadToDos()
                }
            }
            emptyView.isHidden = false
        } else {
            emptyVC?.state = .empty
            emptyVC?.action = { [weak self] in
                self?.performSegue(withIdentifier: "new-item", sender: nil)
            }
            emptyView.isHidden = !data.isEmpty
            if !data.isEmpty {
                collectionView.reloadData()
            }
        }
    }
    
    @IBAction func didTapCreateButton(_ sender: PrimaryButton) {
        performSegue(withIdentifier: "new-item", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.destination {
        case let destination as EmptyViewController:
            emptyVC = destination
        case let destination as NewItemViewController:
            destination.delegate = self
        default:
            break
        }
    }
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet var createButton: PrimaryButton!
    @IBOutlet private var emptyView: UIView!
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
        let selectedItem = data[indexPath.row]
        Task {
            do {
                _ = try await NetworkManager.shared.markCompletion(todoId: selectedItem.id)
                await loadToDos()
            } catch {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {
        Task {
            await loadToDos()
        }
    }
}
