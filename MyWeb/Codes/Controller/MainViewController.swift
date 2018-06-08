//
//  MainViewController.swift
//  MyWeb
//
//  Created by 一磊 on 2018/5/29.
//  Copyright © 2018年 一磊. All rights reserved.
//

import UIKit
import QuickLook

class MainViewController: UIViewController {
    //can not work
    subscript(indexPath: IndexPath) -> Web? {
        return self.getWeb(indexPath: indexPath)
    }
    
    //MARK: init let and var
    var web:Web?
    var websDict: Dictionary <String, Any>? {
        get {
            return Source.getDictionaryOfWebs()
        }
    }
    
    //tableView
    lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width:cScreenW , height: cScreenH))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    //addWebView
    lazy var addWebsView: AddWebsView = {[unowned self] in
        let addWebsView = AddWebsView(frame: CGRect(x: 15, y: cScreenH - 250.0, width: cScreenW - 30, height: 250.0))
        addWebsView.isHidden = true
        addWebsView.delegate = self
        return addWebsView
    }()
    
    //quick look
    lazy var qlPC: QLPreviewController = {[unowned self] in
        let pc = QLPreviewController()
        pc.dataSource = self
        pc.delegate = self
        return pc
    }()
  
    //MARK: viewController function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(rightAddAction))
        
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        //init view
        self.view.addSubview(tableView)
        self.view.addSubview(addWebsView)
        
        // init data
        if websDict == nil || websDict!.isEmpty {
            let originalDict = [
                "BlockChain": ["Candy":"https://ibo.candy.one","非小号":"https://www.feixiaohao.com"],
                "Learn": ["知笔墨":"http://zhibimo.com","ECMAScript 6 入门":"http://es6.ruanyifeng.com/#docs/intro"],
                "Book":["everyone-can-use-english":Source.getFilePath(fileName: "everyone-can-use-english", type: "pdf")]
            ]
            Source.writeDictionaryToWebs(dict: originalDict)
        }
        
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: action
extension MainViewController {
    @objc fileprivate func rightAddAction()  {
        self.addWebsView.showAddWebs(vc: self)
    }
    
    fileprivate func getGroupDict(index: Int) -> Dictionary<String,Any> {
        var groups = [String](websDict!.keys)
        let group = groups[index]
        let dict = websDict![group] as! Dictionary<String,Any>
        return dict
    }
    
    fileprivate func getWeb(indexPath: IndexPath ) -> Web {
        var groups = [String](websDict!.keys)
        let group = groups[indexPath.section]
        let groupDict = websDict![group] as! Dictionary<String,Any>

        let names = [String](groupDict.keys)
        let name = names[indexPath.row]

        let www =  groupDict[name] as? String

        web = Web.init(group: group, name: name, web: www!)
        return web!
    }
}

// 键盘通知
extension MainViewController {
    @objc fileprivate func keyboardWillShow(_ notification:Notification) {
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let kbH = kbRect.origin.y - cScreenH
        let duration = kbInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.addWebsView.transform = CGAffineTransform(translationX: 0, y: kbH)
        }
    }
}

//MARK: AddWebsDelegate
extension MainViewController:AddWebsViewDelegate {
    func addWebs(web: Web) {
        guard Source.hasName(web: web) else {
            Source.writeWebToPlist(web:web)
            self.tableView.reloadData()
            return
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return websDict!.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var keys = [String](websDict!.keys)
        return keys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let groupDict = getGroupDict(index: section)
        let names = [String](groupDict.keys)

        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "WEDCELLID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }

        let web = self.getWeb(indexPath: indexPath)
        cell?.textLabel?.text = web.name
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //pdf book
        let web = self.getWeb(indexPath: indexPath)
        if web.group == "Book" {
            //bottom to up
            self.present(self.qlPC, animated: true, completion: nil)
        } else {
            let webVC: WebViewController = WebViewController()
            webVC.webUrlStr = web.web
            webVC.title = web.name
            
            //nav push
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    //edit cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //can move dont need
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let alertController = UIAlertController(title: "提示", message: "您确定删除此网址收藏吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
                let web = self.getWeb(indexPath: indexPath)
                Source.deleteWeb(web: web)
                self.tableView.reloadData()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MAEK:QLPreviewControllerDelegate  QLPreviewControllerDataSource
extension MainViewController:QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let path = Source.getFilePath(fileName: web!.name, type: "pdf")
        let url = URL.init(fileURLWithPath:path!)
        return url as QLPreviewItem
    }
}
