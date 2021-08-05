//
//  NestedScrollViewController.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/9.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit

class NestedSubScrollViewController: UIViewController, NestedSrollable {
        
    var scrollView: UIScrollView {
        return tableView
    }

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        return table
    }()
    
    var dataSource = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"]
    
    var childScrollViewDidScrollHandler: ((UIScrollView) -> Void)?
    
    var changeTitleHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDelegate

extension NestedSubScrollViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        childScrollViewDidScrollHandler?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row != (dataSource.count - 1) { return }

        dataSource += dataSource

        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let headerTitle = "select \(indexPath.row)"
        changeTitleHandler?(headerTitle)
    }
}

// MARK: - UITableViewDataSource

extension NestedSubScrollViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell
            else { return UITableViewCell() }
        
        cell.textLabel?.text = "#\(indexPath.row)"
        return cell
    }
}

// MARK: - UITableViewCell

extension NestedSubScrollViewController {
    
    class Cell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }

        required init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
    }
}
