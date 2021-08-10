//
//  NestedScrollViewController.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/10.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit

class NestedScrollViewController: BaseViewController {
    
    private lazy var nestedScrollView: NestedScrollView = {
        let view = NestedScrollView()
        view.topView = topView
        view.subViewControllers = controllers
        return view
    }()
    
    private var topView = TopView()
    
    private let firstVC: NestedSubScrollViewController = {
        let vc = NestedSubScrollViewController()
        vc.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return vc
    }()
    
    private let secVC = NestedSubScrollViewController()
    
    private let thirdVC = NestedSubScrollViewController()
    
    private lazy var controllers = [
        ControllerDetail(titleName: "firstTab", vc: firstVC),
        ControllerDetail(titleName: "secTab", vc: secVC),
        ControllerDetail(titleName: "thirdTab", vc: thirdVC)]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        activeHandler()
    }
    
    private func setupUI() {
        
        view.addSubview(nestedScrollView)
        nestedScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.left.bottom.equalToSuperview()
        }
        
        view.backgroundColor = .white
    }
    
    private func activeHandler() {
        
        firstVC.changeTitleHandler = { [weak self] titleStr in
            
            guard let self = self else { return }
            self.onChangeTitle(index: 0, titleStr: titleStr)
        }
        
        secVC.changeTitleHandler = { [weak self] titleStr in
            
            guard let self = self else { return }
            self.onChangeTitle(index: 1, titleStr: titleStr)
        }
        
        thirdVC.changeTitleHandler = { [weak self] titleStr in
            
            guard let self = self else { return }
            self.onChangeTitle(index: 2, titleStr: titleStr)
        }
    }
    
    private func onChangeTitle(index: Int, titleStr: String) {
        
        controllers[index].titleName = titleStr
    }
}


// MARK: topView

extension NestedScrollViewController {
    
    class TopView: UIView {
        
        private let titleLbl: UILabel = {
            
            let lbl = UILabel()
            lbl.text = "標題"
            lbl.numberOfLines = 0
            return lbl
        }()
        
        init() {
            
            super.init(frame: .zero)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(30)
                make.height.equalTo(100)
            }
            
            backgroundColor = .yellow
        }
    }
}
