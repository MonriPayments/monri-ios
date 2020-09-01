//
//  ConfirmPaymentControllerViewController.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import UIKit
import WebKit

class ConfirmPaymentControllerViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var indicator: UIActivityIndicatorView!

    var callback: ConfirmPaymentResultCallback!

    var confirmPaymentParams: ConfirmPaymentParams!
    var monriApiOptions: MonriApiOptions!

    var monri: MonriApi {
        MonriApi(self.navigationController!,options: monriApiOptions)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
