//
//  AddWebs.swift
//  MyWeb
//
//  Created by 一磊 on 2018/6/4.
//  Copyright © 2018年 一磊. All rights reserved.
//

import UIKit
protocol AddWebsViewDelegate {
    func addWebs(web:Web)
}

class AddWebsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var vc: UIViewController?
    var web:Web?
    var delegate: AddWebsViewDelegate?
    
    lazy var tapGesture:UIGestureRecognizer = {[unowned self] in
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackViewAction))
        return gesture
    }()
    lazy var backView: UIView = {[unowned self] in
        let backView = UIView.init()
        backView.backgroundColor = UIColor.lightGray
        backView.addGestureRecognizer(tapGesture)
        return backView
    }()
    
    lazy var groupField: UITextField = { [unowned self] in
        let field = UITextField()
        field.placeholder = "填写分组"
        field.borderStyle = .roundedRect
        field.delegate = self
        return field
    }()
    
    lazy var nameField:UITextField = {[unowned self] in
        let field = UITextField()
        field.placeholder = "填写网站名称"
        field.borderStyle = .roundedRect

        return field
    }()
    
    lazy var webField:UITextField = {[unowned self] in
        let field = UITextField()
        field.placeholder = "填写网址"
        field.borderStyle = .roundedRect
        return field
    }()
    
    lazy var cancelBtn:UIButton = {[unowned self] in
        let btn:UIButton = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var addBtn:UIButton = {[unowned self] in
        let btn:UIButton = UIButton(type: .custom)
        btn.setTitle("添加", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        return btn
    }()
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 3
        self.backgroundColor = UIColor.white
        
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let x: CGFloat = 15.0
        let w: CGFloat = self.frame.size.width - 30.0
        let h: CGFloat = 44.0
        self.groupField.frame = CGRect(x: x, y: x, width: w, height: h)
        self.nameField.frame = CGRect(x: x, y: h + 2 * x, width: w, height: h)
        self.webField.frame = CGRect(x: x, y: 2 * h + 3 * x, width: w, height: h)
        
        self.cancelBtn.frame = CGRect(x: x, y: 3 * h + 4 * x, width: w/2.0 - x, height: h)
        self.addBtn.frame = CGRect(x: 3 * x + w/2.0 - x, y: 3 * h + 4 * x, width: w/2.0 - x, height: h)
    }
    
    fileprivate func initView() {
        self.addSubview(self.groupField)
        self.addSubview(self.nameField)
        self.addSubview(self.webField)
        self.addSubview(self.cancelBtn)
        self.addSubview(self.addBtn)
    }
    fileprivate func cleanField() {
        self.groupField.text = nil
        self.nameField.text = nil
        self.webField.text = nil
    }
}

extension AddWebsView {
    
    func showAddWebs(vc:UIViewController) {
        self.vc = vc
        
        backView.frame = vc.view.frame
        backView.alpha = 0.3
        backView.isHidden = false
        vc.view.addSubview(backView)
        
        self.isHidden = false
        vc.view.addSubview(self)
    }
    
    func hiddenAddWebs() {
        backView.removeFromSuperview()
        backView.isHidden = true
        
        self.removeFromSuperview()
        self.isHidden = true
        cleanField()
    }
}
//MARK: 事件
extension AddWebsView {
    @objc func cancelBtnAction() {
        hiddenAddWebs()
    }
    
    @objc func addBtnAction() {
        if let group = groupField.text, let name = nameField.text, let www = webField.text {
            if group.isEmpty || name.isEmpty || www.isEmpty {
                return
            }
            web = Web.init(group:group, name: name, web: www)
            delegate?.addWebs(web: web!)
        }
        hiddenAddWebs()
    }
    
    @objc func tapBackViewAction() {
        hiddenAddWebs()
    }
}

extension AddWebsView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let websDict = Source.getDictionaryOfWebs()
        let groups = [String](websDict!.keys)
        
        let cancelAction = UIAlertAction(title: "添加新组", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        for group in groups {
            let groupAction = UIAlertAction(title: group, style: .default) { (action) in
                self.groupField.text = group
            }
            alertController.addAction(groupAction)
        }
        self.vc?.present(alertController, animated: true, completion: nil)
    }
}
