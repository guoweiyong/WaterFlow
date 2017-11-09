//
//  XMGMainViewController.swift
//  swift--WaterFlow
//
//  Created by x on 2017/4/6.
//  Copyright © 2017年 HLB. All rights reserved.
//

import UIKit

let cellID = "cellID"

class XMGMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        //初始化collecionView
        setupCollectionView()
    }
    func setupCollectionView() -> Void {
        
        //设置布局的代理对象
        waterFlowLayout.delegate = self
        
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
    }
    
    //MARK: -- 懒加载

    /// 瀑布流的布局
    private lazy var waterFlowLayout:XMGWaterFlowLayout = XMGWaterFlowLayout()
    
    /// collectionView
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: self.waterFlowLayout)
}

extension XMGMainViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.gray;
        
        return cell
    }
}
extension XMGMainViewController: XMGWaterFlowLayoutDelegate {
    
    func heightForItemAtIndex(waterFlowLayout: XMGWaterFlowLayout, index: NSInteger, itemWidth: CGFloat) -> CGFloat {
        return 60
    }
    
    func columnCount(waterFlowLayout: XMGWaterFlowLayout) -> CGFloat {
        return 4
    }
}
