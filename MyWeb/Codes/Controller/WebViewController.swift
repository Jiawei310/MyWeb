//
//  WebViewController.swift
//  MyWeb
//
//  Created by 一磊 on 2018/6/1.
//  Copyright © 2018年 一磊. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var webUrlStr : String?
    
    lazy var webView : UIWebView = {[unowned self] in
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: cScreenW, height: cScreenH))
        webView.backgroundColor = UIColor.white
        
        webView.scalesPageToFit = true
        webView.isMultipleTouchEnabled = true
        webView.isUserInteractionEnabled = true
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = UIViewContentMode.scaleAspectFit
        
        webView.delegate = self

        return webView
    }()
    lazy var loadingView : UIActivityIndicatorView = {[unowned self] in
        let loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200.0, height: 200.0))
        loadingView.activityIndicatorViewStyle = .gray
        loadingView.center = self.view.center
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(webView)
        self.view.addSubview(loadingView)
        
        if let urlstr = webUrlStr {
            let url = URL(string: urlstr)
            let request:URLRequest = URLRequest(url: url!)
            webView.loadRequest(request)
        }
        
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

extension WebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadingView.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopAnimating()
    }
}
