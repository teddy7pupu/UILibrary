//
//  MainViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

class MainViewController: BaseViewController {

    // UI element
    private let mainView = MainView()

    // property
    private let mainModels: [MainModel] = [
        MainModel(vc: KeyboardPickerDemoViewController(), name: "Picker View"),
        MainModel(vc: InfiniteLoopDemoViewController(), name: "輪播"),
        MainModel(vc: ThanosButtonDemoViewController(), name: "薩諾斯按鈕"),
        MainModel(vc: NestedScrollViewController(), name: "巢狀式 scroll view")
    ]

    // Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension MainViewController {
        
    func configer() {
        
        view = mainView
        
        title = "Teddy"
        
        mainView.table.delegate = self
        mainView.table.dataSource = self
    }
}

// MARK: - Action

private extension MainViewController {

}

// MARK: - Getter

private extension MainViewController {

}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.pushViewController(mainModels[indexPath.row].vc)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: MainCell.self, for: indexPath)
        cell.configer(data: mainModels[indexPath.row].name)
        return cell
    }
}
