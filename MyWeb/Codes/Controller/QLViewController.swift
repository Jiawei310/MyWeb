//
//  QLViewController.swift
//  MyWeb
//
//  Created by 一磊 on 2018/6/8.
//  Copyright © 2018年 一磊. All rights reserved.
//

import UIKit
import QuickLook
//支持格式 PDF doc txt rtf xls key numbers pages ppt mp3 jpq mp4
class QLViewController: UIViewController {

    var fileName:String?
    var fileType: String?
    
    lazy var qlPC: QLPreviewController = {[unowned self] in
        let pc = QLPreviewController()
        pc.dataSource = self
        return pc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.present(self.qlPC, animated: false, completion: nil)
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

extension QLViewController:QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let path = Source.getFilePath(fileName: fileName!, type: fileType!)
        let url = URL.init(fileURLWithPath:path!)
        return url as QLPreviewItem
    }
    
    
}
