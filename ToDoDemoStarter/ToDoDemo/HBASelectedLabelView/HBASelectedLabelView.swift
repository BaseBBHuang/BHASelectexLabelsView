//
//  HBASelectedLabelView.swift
//  ToDoDemo
//
//  Created by 乔贝斯 on 2017/9/26.
//  Copyright © 2017年 Mars. All rights reserved.
//

import UIKit
import RxSwift

class HBASelectedLabelView: UIView {
    
    var labelsArray: Array<UILabel> = []
    var columnSpace: CGFloat = 10
    var rowSpace: CGFloat = 10
    var marginSpce: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var previousObj: UIView?
    
    fileprivate let statusSubject = PublishSubject<String>()
    fileprivate let gestureSubject = PublishSubject<Int>()
    var status: Observable<String> {
        return statusSubject.asObservable()
    }
    var gestureViewTag: Observable<Int> {
        return gestureSubject.asObservable()
    }
    var bag = DisposeBag()
    
    public var minColumnSpace: CGFloat = 0 {
        didSet{
            columnSpace = minColumnSpace
            if !labelsArray.isEmpty {
                updateUILabelsView(rect: self.frame)
            }
        }
    }
    
    public var minRowSpace: CGFloat = 0 {
        didSet{
            rowSpace = minRowSpace
            if !labelsArray.isEmpty {
                updateUILabelsView(rect: self.frame)
            }
        }
    }
    
    public var minMarginSpace: UIEdgeInsets = UIEdgeInsets(){
        didSet{
            marginSpce = minMarginSpace
            if !labelsArray.isEmpty {
                updateUILabelsView(rect: self.frame)
            }
        }
    }
    
    public var dataSource: Array = [UILabel]() {
        didSet{
            if !dataSource.isEmpty {
                labelsArray.append(contentsOf: dataSource)
            }
        }
    }
    
    public func addLabels(withArr arr: Array<UILabel>) {
        if !arr.isEmpty {
            statusSubject.onNext(String(labelsArray.count))
            labelsArray.append(contentsOf: arr)
            updateUILabelsView(rect: self.frame)
        }
        
    }
    
    public func deleteLabels(withArr arr: Array<UILabel>) {
        if !arr.isEmpty {
            let currentArrCount = labelsArray.count
            for deleteObj in arr {
                for (idx, obj) in labelsArray.enumerated() {
                    if (deleteObj == obj) {
                        labelsArray.remove(at: idx)
                        statusSubject.onNext(String(labelsArray.count))
                    }
                    
                }
            }
            
            if (currentArrCount != labelsArray.count) {
                updateUILabelsView(rect: self.frame)
            }
        } else {
            statusSubject.onNext("LabelsZero")
        }
    }
    
    
    init(origin: CGPoint, width: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: 100))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //更新 UI
    func updateUILabelsView(rect: CGRect) {
        _ = self.subviews.map{
            $0.removeFromSuperview()
        }
        
        let selfWidth = rect.size.width
        var rowElementX = marginSpce.left
        var rowElementY = marginSpce.top
        
        var rowElementArr = [UILabel]()
        
        for (idx, obj) in labelsArray.enumerated() {
            obj.tag = idx + 1000
            obj.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
            obj.addGestureRecognizer(tapGesture)
            
            if((rowElementX + obj.bounds.size.width + marginSpce.right) > selfWidth) {
                var rowElementTotalWidth: CGFloat = 0
                var rowMaxObjHeight: CGFloat = 0
                
                _ = rowElementArr.map{
                    rowElementTotalWidth += $0.bounds.size.width
                    if(rowMaxObjHeight <= $0.bounds.size.height){
                        rowMaxObjHeight = $0.bounds.size.height
                    }
                }
                
                let newColumnSpace: CGFloat = (selfWidth -
                                                marginSpce.left -
                                                marginSpce.right -
                                                rowElementTotalWidth) / CGFloat(rowElementArr.count - 1)
                
                for (idx, obj) in rowElementArr.enumerated() {
                    if(idx != 0) {
                        obj.frame = CGRect(x: (previousObj?.frame.origin.x)! +
                                                (previousObj?.bounds.size.width)! +
                                                    newColumnSpace,
                                           y: rowElementY,
                                           width: obj.bounds.size.width,
                                           height: obj.bounds.size.height)
                    }
                    previousObj = obj
                    
                    if(idx == (rowElementArr.count - 1) ) {
                        rowElementY += rowMaxObjHeight + rowSpace
                        rowElementX = marginSpce.left
                    }
                }
                rowElementArr.removeAll()
                
                if (obj.bounds.size.width >= (selfWidth - marginSpce.left - marginSpce.right)) {
                    obj.frame = CGRect(x: rowElementX,
                                       y: rowElementY,
                                       width: selfWidth - rowElementX - marginSpce.right,
                                       height: obj.bounds.size.height)
                    rowElementY += obj.bounds.size.height + rowSpace
                    rowElementX = marginSpce.left
                }
                else {
                    obj.frame = CGRect(x: rowElementX,
                                       y: rowElementY,
                                       width: obj.bounds.size.width,
                                       height: obj.bounds.size.height)
                    rowElementX += obj.bounds.size.width + columnSpace
                    rowElementArr.append(obj)
                }
            }
            else {
                obj.frame = CGRect(x: rowElementX,
                                   y: rowElementY,
                                   width: obj.bounds.size.width,
                                   height: obj.bounds.size.height)
                rowElementX += obj.bounds.size.width + columnSpace
                rowElementArr.append(obj)
            }
            
            previousObj = obj
            self.addSubview(obj)
            
            if (idx == labelsArray.count - 1) {
                var rowMaxObjHeight: CGFloat = 0
                _ = rowElementArr.map {
                    if (rowMaxObjHeight <= $0.bounds.size.height) {
                        rowMaxObjHeight = obj.bounds.size.height
                    }
                }
                self.frame = CGRect(x: rect.origin.x,
                                    y: rect.origin.y,
                                    width: rect.size.width,
                                    height: rowElementY + rowMaxObjHeight + marginSpce.bottom)
                previousObj = nil
            }
        }
    }
    
    func tap(gestureRecognizer: UITapGestureRecognizer) {
//        statusSubject.onNext(String((gestureRecognizer.view?.tag)! - 1000))
        gestureSubject.onNext((gestureRecognizer.view?.tag)! - 1000)
    }
    
}
