//
//  NestedScrollView.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/9.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit
import HMSegmentedControl

class NestedScrollView: UIView {
    
    private var parentScrollView: UIScrollView {
        return parentTableView
    }
    
    private lazy var parentTableView: GestureRecognizerTable = {
        let table = GestureRecognizerTable()
        table.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.alwaysBounceVertical = true
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var hmsSegment: HMSegmentedControl = {
        let segment = HMSegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        segment.sectionTitles = subViewControllers.map { $0.titleName }
        segment.backgroundColor = .white
        segment.selectionIndicatorColor = .black
        segment.selectionIndicatorHeight = 2
        segment.selectionStyle = .fullWidthStripe
        segment.selectionIndicatorLocation = .bottom
        segment.selectedTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        segment.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.brown
        ]
        
        return segment
    }()
    
    private let containerView = UIView()
    
    private var childScrollView: UIScrollView {
        if subViewControllers.isEmpty { return UIScrollView() }
        let scrollView = subViewControllers[Int(hmsSegment.selectedSegmentIndex)].vc.scrollView
        return scrollView
    }
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()
    
    var topView: UIView? {
        didSet {
            parentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    var subViewControllers = [ControllerDetail]() {
        didSet {
            actionHandler()
            onUpdateSectionTitle()
            pageViewController.reloadInputViews()
            pageViewController.setViewControllers(
                [self.subViewControllers[currentIndex].vc],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
        
    private var currentIndex = Int()
    
    private var canParentViewScroll = true
    
    private var canChildViewScroll = false
    
    private var subViewheight: CGFloat = {
        let screenHeight = UIScreen.main.bounds.height
        let subViewheight: CGFloat
        
        if #available(iOS 11.0, *) {
            let topHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            let bottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            let navHeight = CGFloat(44)
            subViewheight = screenHeight - (topHeight + bottomHeight + navHeight)
        } else {
            let navHeight = CGFloat(44)
            subViewheight = screenHeight - navHeight
        }
        return subViewheight
    }()
    
    init() {
    
        super.init(frame: .zero)
        setupUI()
        actionHandler()
        getHorizontalGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(parentTableView)
        parentTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundColor = .white
    }
    
    private func actionHandler() {
        
        hmsSegment.indexChangeBlock = { [weak self] (index) in
            
            guard let self = self else { return }
            let direction: UIPageViewController.NavigationDirection = index > self.currentIndex ? .forward : .reverse
            self.currentIndex = Int(index)
            self.pageViewController.setViewControllers([self.subViewControllers[Int(index)].vc], direction: direction, animated: true, completion: nil)
        }
        
        for controllerDetail in subViewControllers {
            
            controllerDetail.onTitleChange = { [weak self] in
                
                guard let self = self else { return }
                self.onUpdateSectionTitle()
            }
            
            controllerDetail.vc.childScrollViewDidScrollHandler = { [weak self] (scrollView) in
                
                guard let self = self else { return }
                self.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    // 重新載入畫面
    func onReloadTable() {
        
        parentTableView.reloadData()
    }
    
    // 更新 segment 標題
    private func onUpdateSectionTitle() {
        
        hmsSegment.sectionTitles = subViewControllers.map { $0.titleName }
    }
    
    // 濾除 pageViewController 上面的手勢不要讓 parent scrollview 吃到
    private func getHorizontalGestureRecognizers() {

        let scrollView = pageViewController.view.subviews.compactMap { $0 as? UIScrollView }.first
        parentTableView.otherGestureRecognizers = scrollView?.gestureRecognizers
    }
    
    // 取得目前畫面上 pageViewController index
    private func getViewOfPageIndex() -> Int? {
        
        guard let currentVC = pageViewController.viewControllers?.first else { return nil }
        let index = subViewControllers.firstIndex { (model) -> Bool in
            return model.vc == currentVC
        }
        return index
    }
}

// MARK: - UITableViewDelegate

extension NestedScrollView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return section == 0 ? nil : hmsSegment
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? CGFloat.leastNormalMagnitude : hmsSegment.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        return indexPath.section == 0 ? UITableView.automaticDimension : subViewheight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let parentViewMaxContentYOffset = topView?.frame.height ?? 0
        let parentOffsetY = parentScrollView.contentOffset.y
        
        let childContentInsetTop = -childScrollView.contentInset.top
        let childOffsetY = childScrollView.contentOffset.y
        
        if parentOffsetY >= parentViewMaxContentYOffset,
            childOffsetY <= childContentInsetTop {
            canParentViewScroll = true
            canChildViewScroll = false
        }
        
        if scrollView == parentScrollView {
            // parent 收到滑動事件
            if !canParentViewScroll {
                parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                canChildViewScroll = true
            } else if parentOffsetY > parentViewMaxContentYOffset {
                parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                childScrollView.contentOffset.y = parentOffsetY - parentViewMaxContentYOffset + childContentInsetTop
                canParentViewScroll = false
                canChildViewScroll = true
            } else if parentScrollView.contentOffset.y == 0,
                    !canChildViewScroll {
                childScrollView.contentOffset.y = childContentInsetTop
            }
        } else {
            // child 收到滑動事件
            if !canChildViewScroll {
                childScrollView.contentOffset.y = childContentInsetTop
                canParentViewScroll = true
            } else if scrollView.contentOffset.y <= childContentInsetTop {
                canChildViewScroll = false
                canParentViewScroll = true
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension NestedScrollView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // 第一層放 topView, 第二層放 page view controller
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? (topView == nil ? 0 : 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell
        else { return UITableViewCell() }
        
        let inputView: UIView
        
        switch indexPath.section {
        case 0:
            inputView = topView ?? UIView()
        case 1:
            inputView = containerView
        default:
            inputView = UIView()
        }
        
        cell.infoSet(inputView: inputView)
        return cell
    }
}

// MARK: - UIPageViewControllerDelegate

extension NestedScrollView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let index = getViewOfPageIndex()
        guard let _index = index else { return }
        currentIndex = _index
        hmsSegment.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension NestedScrollView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
                
        let index = getViewOfPageIndex()
        guard let _index = index, !(_index == 0) else { return nil }
        
        currentIndex = _index - 1
        return subViewControllers[currentIndex].vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = getViewOfPageIndex()
        guard let _index = index, !(_index >= (subViewControllers.count - 1)) else { return nil }
        
        currentIndex = _index + 1
        return subViewControllers[currentIndex].vc
    }
}

// MARK: - GestureRecognizerTable

class GestureRecognizerTable: UITableView, UIGestureRecognizerDelegate {
    
    var otherGestureRecognizers: [UIGestureRecognizer]?
    
    init() {
        
        super.init(frame: .zero, style: .plain)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 過濾來自 page view controller 手勢, 其餘皆回傳 true
        guard let otherGestureRecognizers = otherGestureRecognizers,
            !(otherGestureRecognizers.contains(otherGestureRecognizer))
            else { return false }
        
        return true
    }
}

// MARK: - UITableViewCell

extension NestedScrollView {
    
    class Cell: UITableViewCell {
                
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
    
        func infoSet(inputView: UIView) {
            
            for view in contentView.subviews { view.removeFromSuperview() }
            
            contentView.addSubview(inputView)
            inputView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - Protocol NestedSrollable

protocol NestedSrollable: UIViewController {
    
    var scrollView: UIScrollView { get }
    var childScrollViewDidScrollHandler: ((UIScrollView) -> Void)? { get set }
}

// MARK: - ControllerDetail Model

class ControllerDetail {
    
    var onTitleChange: (() -> Void)?
    
    var titleName: String {
        didSet {
            onTitleChange?()
        }
    }
    
    let vc: NestedSrollable
    
    init(titleName: String = "", vc: NestedSrollable) {
        
        self.titleName = titleName
        self.vc = vc
    }
}
