//
//  XMGWaterFlowLayout.swift
//  swift--WaterFlow
//
//  Created by x on 2017/4/6.
//  Copyright © 2017年 HLB. All rights reserved.
//

import UIKit

@objc protocol XMGWaterFlowLayoutDelegate:NSObjectProtocol {
    
    /// 根据位置,宽度  得到cell的高度
    ///
    /// - Parameters:
    ///   - waterFlowLayout: <#waterFlowLayout description#>
    ///   - index: <#index description#>
    ///   - itemWidth: <#itemWidth description#>
    /// - Returns: <#return value description#>
    func heightForItemAtIndex(waterFlowLayout: XMGWaterFlowLayout, index: NSInteger, itemWidth:CGFloat) -> CGFloat
    
    /// 设置列数
    ///
    /// - Parameter waterFlowLayout: <#waterFlowLayout description#>
    @objc optional func columnCount(waterFlowLayout: XMGWaterFlowLayout) ->CGFloat
    
    //设置列间距
    @objc optional func columnMargin(waterFlowLayout: XMGWaterFlowLayout) ->CGFloat
    
    //设置行间距
    @objc optional func rowMargin(waterFlowLayout: XMGWaterFlowLayout) ->CGFloat
    
    //设置默认边缘之间的距离
    @objc optional func edgeInserts(waterFlowLayout: XMGWaterFlowLayout) ->UIEdgeInsets
}

class XMGWaterFlowLayout: UICollectionViewLayout {

    /// 默认列数
    let XMGDefaultColumnCount:CGFloat = 3
    
    /// 默认列间距
    let XMGDefaultColumnMargin:CGFloat = 10
    
    /// 默认行间距
    let XMGDefaultRowMargin:CGFloat = 10
    
    /// 默认边缘之间的距离
    let XMGDefaultEdgeInserts: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
    
    /// 只有遵守这个协议的对象才能实现代理犯法
    weak var delegate: XMGWaterFlowLayoutDelegate?
    
    /// 保存设置的列数 (定义一个计算属性  相当于oc中get方法)
    var columnCount:CGFloat? {
        
        //3.swift中怎么判断类有没有实现这个方法的格式 ,相当于oc中的respondsToSelector
        if ((self.delegate?.columnCount!(waterFlowLayout: self)) != nil) {
            return self.delegate?.columnCount!(waterFlowLayout: self)
        }else {
            return XMGDefaultColumnCount
        }
    }
    
    
    //写瀑布流布局
    
    //1.初始化布局 (每次重新布局的时候都要调用这个方法)
    override func prepare() {
        super.prepare()
        print("00000000000000000000000")
//        //3.swift中怎么判断类有没有实现这个方法的格式 ,相当于oc中的respondsToSelector
//        if ((self.delegate?.columnCount!(waterFlowLayout: self)) != nil) {
//            columnCount = self.delegate?.columnCount!(waterFlowLayout: self)
//        }else {
//            columnCount = XMGDefaultColumnCount
//        }

        //1.每次重新布局的时候要把高度数组清空,并且赋值一个初值
        columnHeight.removeAll()
        for _ in 1...NSInteger(columnCount!) {
            columnHeight.append(XMGDefaultEdgeInserts.top)
        }
        
        //2.每次重新布局要先清空布局属性数组
        attrsArray.removeAll()
        //2.1得到这个分区所有的cell
        let count = collectionView?.numberOfItems(inSection: 0)
        for i in 0..<count! {
            
            //2.2拿到每个cell的对应位子
            let indexPath = IndexPath.init(item: i, section: 0)
            
            //2.3得到每个cell的布局属性
            let attrs = layoutAttributesForItem(at: indexPath)
            attrsArray.append(attrs!)
        }
    }
    
    //2.决定cell的排布返回cell所有的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
    
    //3.重写决定每个cell的布局属性方法
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //1.创建对应位子cell的原始布局属性
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath);
        
        let collectionViewWidth = UIScreen.main.bounds.size.width
        //2.设置布局属性的frame
        //2.1cell的宽度
        let cellWidth = (collectionViewWidth-(columnCount!-CGFloat(1))*XMGDefaultColumnMargin-XMGDefaultEdgeInserts.left-XMGDefaultEdgeInserts.right)/columnCount!
        
        //2.2cell的高度
        let cellHeight = 50 + arc4random_uniform(100)//50+100以下的随机数
        
        //2.3我们要找出高度最短的那一列 把新的cell添加在最短的那一列
        //假设高度最短的一列是第一列 然后取出第一列的高度
        var destColumn = 0
        var minHeight = columnHeight.first
        
        //2.4获得最短的列 和最短列的高度
        for i in 0..<NSInteger(columnCount!) {
            let columnH = columnHeight[i]//拿到高度
            if minHeight! > columnH {
                minHeight = columnH
                destColumn = i
            }
        }
        //设置新添加cell的frame的x,y
        let x = XMGDefaultEdgeInserts.left + CGFloat(destColumn) * (XMGDefaultColumnMargin+cellWidth)
        var y = minHeight
        if y != XMGDefaultEdgeInserts.top {
            y = minHeight! + XMGDefaultRowMargin
        }
        attrs.frame = CGRect.init(x: x, y: y!, width: cellWidth, height: CGFloat(cellHeight))
        
        //当你设置完cell的frame之后要把 更新高度数组
        columnHeight[destColumn] = attrs.frame.maxY
        
        return attrs
    }
    
    //4.继承自动布局collecView的滚动范围要重写 滚动范围方法(属性)
    override var collectionViewContentSize: CGSize {
        
        var maxHeight = columnHeight.first
        for i in 1..<columnHeight.count {
            let H = columnHeight[i]
            if maxHeight! < H {
                maxHeight = H
            }
        }
        
        return CGSize.init(width: 0, height: maxHeight!)
    }
    
    //MARK: -- 懒加载

    /// 保存所有item的属性的数组
    private lazy var attrsArray:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    /// 保存所有列的高度
    private lazy var columnHeight:[CGFloat] = [CGFloat]()
}

