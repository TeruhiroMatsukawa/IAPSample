//
//  AppDelegate.swift
//  InAppPurchaseSample
//
//  Created by Teruhiro Matsukawa on 2017/12/12.
//  Copyright © 2017年 Teruhiro Matsukawa. All rights reserved.
//

import UIKit
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // トランザクションの完了を検知
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases
            {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored
                {
                    if purchase.needsFinishTransaction
                    {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased: \(purchase)")
                }
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
    }
}
