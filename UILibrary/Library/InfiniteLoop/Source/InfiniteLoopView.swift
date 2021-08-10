//
//  InfiniteLoopView.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/1.
//

import UIKit

class InfiniteLoopView<T, Cell: UICollectionViewCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    // UI element
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.itemSize = collectionViewItemSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .clear
        view.contentInset = .zero
        view.register(Cell.self,
                      forCellWithReuseIdentifier: String(describing: Cell.self))
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.clipsToBounds = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    // property
    
    private let collectionViewItemSize: CGSize
    
    /// 設置 cell 和 資料型別
    private let cellConfigure: (T, Cell) -> Void
    
    /// 回傳當前顯示內容的 index, 可搭配外部 page view 顯示用
    private let pageIndexHandler: ((Int) -> Void)?
    
    /// 回傳點擊 cell 觸發事件
    private let selectIndexHandler: ((Int) -> Void)?
    
    /// collection view 實際輪播資料內容
    private var collectionInputDatas = [T]()
    
    /// 輪播秒數
    private let changeSec: TimeInterval
    
    /// 計時器
    private var timer: Timer?
    
    /// collection view 目前顯示的 index
    private var collectionIndex = Int()
    
    /// 原始資料的目前顯示的 index
    private var originIndex: Int {
        return collectionIndex - 1
    }
    
    /// 輪播資料
    var inputDatas = [T]() {
        didSet {
            guard let firstItem = inputDatas.first,
                let lastItem = inputDatas.last
                else { return }
            
            clearTimer()
            
            collectionInputDatas = [lastItem] + inputDatas + [firstItem]
            
            collectionView.reloadData { [weak self] in
                guard let self = self else { return }
                self.collectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
                self.collectionIndex = 1
                self.collectionView.isScrollEnabled = self.inputDatas.count > 1
                
                self.startTimer()
            }
        }
    }

    // Life cycle
    
    init(changeSec: TimeInterval = 5,
         itemSize: CGSize,
         cellConfigure: @escaping (T, Cell) -> Void,
         pageIndexHandler: ((Int) -> Void)? = nil,
         selectIndexHandler: ((Int) -> Void)? = nil) {
        
        self.changeSec = changeSec
        self.collectionViewItemSize = itemSize
        self.cellConfigure = cellConfigure
        self.pageIndexHandler = pageIndexHandler
        self.selectIndexHandler = selectIndexHandler
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        clearTimer()
    }
    
    // MARK: - Active
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: changeSec, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func clearTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func update() {
        
        if !(collectionView.isScrollEnabled) { return }
                        
        collectionView.setContentOffset(CGPoint(x: CGFloat(Int(UIScreen.main.bounds.width) * (collectionIndex + 1)), y: 0), animated: true)
    }
    
    private func setCurrentPage(to index: Int) {
        
        switch index {
        case 0:
            // 滑到第一筆資料時, 把 index 改成倒數第二筆
            collectionView.setContentOffset(CGPoint(x: CGFloat(Int(UIScreen.main.bounds.width) * (collectionInputDatas.count - 2)), y: 0), animated: false)
            
            collectionIndex = collectionInputDatas.count - 2
        case collectionInputDatas.count - 1:
            // 滑到最後一筆資料時, 把 index 改成第二筆
            collectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
            
            collectionIndex = 1
        default:
            // 其餘 index 不做任何動作
            collectionIndex = index
        }
        
        pageIndexHandler?(originIndex)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        // 原始資料
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        
        guard !(pageFloat.isNaN || pageFloat.isInfinite) else { return }
        
        // 無條件捨去
        let pageInt = Int(pageFloat)
        
        // 無條件進位
        let pageCeil = Int(ceil(pageFloat))
        
        switch pageInt {
        case 0:
            setCurrentPage(to: pageCeil)
        default:
            setCurrentPage(to: pageInt)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        clearTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        startTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var index = indexPath.row - 1
        index = max(-1, index)
        index = min(index, inputDatas.count - 1)
        selectIndexHandler?(index)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionInputDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: Cell.self, for: indexPath)
        let item = collectionInputDatas[indexPath.row]
        cellConfigure(item, cell)
        return cell
    }
}

// MARK: - Setup UI

private extension InfiniteLoopView {

    func setupUI() {

        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(collectionViewItemSize)
        }
    
        backgroundColor = .clear
    }
}
