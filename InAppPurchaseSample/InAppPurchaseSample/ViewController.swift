//
//  ViewController.swift
//  InAppPurchaseSample
//
//  Created by Teruhiro Matsukawa on 2017/12/12.
//  Copyright © 2017年 Teruhiro Matsukawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var productLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        StoreManager.sharedInstance.loadProducts { products in
            print("complete load products.")
            guard let product = products.first else { return }
            self.productLabel.text = "Identifier = \(product.productIdentifier)\nTitle = \(product.localizedTitle)\nPrice = ¥\(product.price.decimalValue)"
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    internal func showAlert(message: String)
    {
        let ac: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func onTapPurchase(_ sender: Any)
    {
        StoreManager.sharedInstance.purchaseProduct(enIdentifier: .oneWeek, onSuccess: {
            print("success purchase!!!")
        }) { errorMessage in
            print(errorMessage)
            self.showAlert(message: errorMessage)
        }
    }
    
    @IBAction func onTapRestore(_ sender: Any)
    {
        StoreManager.sharedInstance.restore
        {
            print("success restore!!!")
        }
    }
}
