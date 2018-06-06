//
//  MainViewController.swift
//  MyWeb
//
//  Created by 一磊 on 2018/5/29.
//  Copyright © 2018年 一磊. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //Mark
    lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width:cScreenW , height: cScreenH))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    lazy var addWebsView: AddWebsView = {[unowned self] in
        let addWebsView = AddWebsView(frame: CGRect(x: 0, y: 0, width: cScreenW - 30, height: 250.0))
        addWebsView.center = self.view.center
        addWebsView.isHidden = true
        addWebsView.delegate = self
        return addWebsView
    }()
    
    var websDict: Dictionary <String, Any>? {
        get {
            return Source.getDictionaryOfWebs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Home"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(rightAddAction))

        
        self.view.addSubview(tableView)
        self.view.addSubview(addWebsView)
        if websDict!.isEmpty {
            let originalDict = [
                "BlockChain": ["Candy":"https://ibo.candy.one","非小号":"https://www.feixiaohao.com"],
                "Learn": ["知笔墨":"http://zhibimo.com","ECMAScript 6 入门":"http://es6.ruanyifeng.com/#docs/intro"]
            ]
            Source.writeDictionaryToWebs(dict: originalDict)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: 事件
extension MainViewController {
    @objc private func rightAddAction()  {
        self.addWebsView.showAddWebs(vc: self)
    }
    
    fileprivate func getGroupDict(index: Int) -> Dictionary<String,Any> {
        var groups = [String](websDict!.keys)
        let group = groups[index]
        let dict = websDict![group] as! Dictionary<String,Any>
        return dict
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
        let groupDict = getGroupDict(index: indexPath.section)
        let names = [String](groupDict.keys)
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupDict = getGroupDict(index: indexPath.section)

        let names = [String](groupDict.keys)
        let name = names[indexPath.row]
        
        let webVC: WebViewController = WebViewController()
        webVC.webUrlStr = groupDict[name] as? String
        webVC.title = name
        
        //通过导航栏切换界面
        self.navigationController?.pushViewController(webVC, animated: true)
        //直接切换界面
        //self.present(webVC, animated: true, completion: nil)
    }
    
    //edit cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //可以省略，需要处理的可以做权限开放
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
                
                var groups = [String](self.websDict!.keys)
                let group = groups[indexPath.section]
                var groupDict = self.websDict![group] as! Dictionary<String,Any>
                
                let names = [String](groupDict.keys)
                let name = names[indexPath.row]
                
                var dict = self.websDict!
                if names.count == 1 {
                    dict.removeValue(forKey: group)
                } else {
                    groupDict.removeValue(forKey: name)
                    dict[group] = groupDict
                }
                
                Source.writeDictionaryToWebs(dict: dict)
                self.tableView.reloadData()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
