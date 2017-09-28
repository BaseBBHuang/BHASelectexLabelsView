//
//  ViewController.swift
//  ToDoDemo
//
//  Created by 乔贝斯 on 2017/9/26.
//  Copyright © 2017年 Mars. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var labelsBGView: UIScrollView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var deleteClick: UIButton!
    
    var selectedLabelView: HBASelectedLabelView!

    
    let titleArrDemo: Array = ["iOS", "工资低", "加班累", "标签太长", "小明不高兴了", "心里也很浮躁", "tiele", "小明", "小明", "小明","iOS", "工资低", "加班累", "标签太长", "小明不高兴了", "心里也很浮躁"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let menuArr = titleArrDemo.map { (value) -> UILabel in
            let menuLabel = UILabel()
            menuLabel.textAlignment = .center
            menuLabel.backgroundColor = UIColor.blue
            menuLabel.text = value
            menuLabel.textColor = UIColor.white
            menuLabel.font = UIFont.systemFont(ofSize: 14)
            let width = menuLabel.widthOfSizeToFit()
            menuLabel.frame = CGRect(x: 0, y: 0, width: width + 15 + 15, height: 30)
            menuLabel.layer.cornerRadius = 5.0
            menuLabel.clipsToBounds = true
            return menuLabel
        }

        selectedLabelView = HBASelectedLabelView(origin: CGPoint(x: 0, y: 0), width: self.view.bounds.size.width)
        selectedLabelView.backgroundColor = UIColor.gray
        selectedLabelView.dataSource = menuArr
        selectedLabelView.minRowSpace = 5
        selectedLabelView.minMarginSpace = UIEdgeInsetsMake(5, 5, 5, 5)
        self.labelsBGView.addSubview(self.selectedLabelView)
        self.labelsBGView.contentSize = CGSize(width: self.view.bounds.size.width, height: selectedLabelView.bounds.size.height)
        _ = selectedLabelView.status.subscribe(
            onNext: {
                [weak self] status in
                self?.title = status + " SelectedLabels"
                if(status == "LabelsZero") {
                    self?.deleteClick.isEnabled = false
                }
                else {
                    self?.deleteClick.isEnabled = true
                }
            },
            onDisposed:{
                print("Finish adding a new todo.")
            }
        )
        _ = selectedLabelView.gestureViewTag.subscribe(
            onNext: { viewTag in
                print("摸了\(viewTag)Label")
            }
        )
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func add(_ sender: Any) {
        let menuLabel = UILabel()
        menuLabel.textAlignment = .center
        menuLabel.backgroundColor = UIColor.blue
        menuLabel.text = "new" + String(arc4random() % 60)
        menuLabel.textColor = UIColor.white
        menuLabel.font = UIFont.systemFont(ofSize: 14)
        let width = menuLabel.widthOfSizeToFit()
        menuLabel.frame = CGRect(x: 0, y: 0, width: width + 15 + 15, height: 30)
        menuLabel.layer.cornerRadius = 5.0
        menuLabel.clipsToBounds = true
    
        selectedLabelView.addLabels(withArr: [menuLabel])
    }
    
    
    @IBAction func deleteLabel(_ sender: Any) {
        let deleteArr = selectedLabelView.labelsArray
        if(!deleteArr.isEmpty) {
            selectedLabelView.deleteLabels(withArr: [deleteArr.last!])
        }
        
    }
}
