//
//  StoreManager.swift
//  InAppPurchaseSample
//
//  Created by Teruhiro Matsukawa on 2017/12/13.
//  Copyright © 2017年 Teruhiro Matsukawa. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

enum EnProductIdentifier: String
{
    case oneWeek = "hogehoge.product"
}

class StoreManager
{
    static let sharedInstance: StoreManager = StoreManager()
    
    // プロダクトID
    fileprivate let productIdentifiers: Set<String> = [EnProductIdentifier.oneWeek.rawValue]
    
    // プロダクトの配列
    internal var products: Set<SKProduct> = []
    
    //********************************
    //  MARK: internal function
    //********************************
    
    // プロダクトの読み込み
    internal func loadProducts(complete: @escaping (Set<SKProduct>) -> ())
    {
        self.getProducts(identifiers: self.productIdentifiers) { products in
            self.products = products
            complete(products)
        }
    }
    
    // プロダクトの購入
    internal func purchaseProduct(enIdentifier: EnProductIdentifier, onSuccess: @escaping () -> (), onFailed: @escaping (String) -> ())
    {
        self.purchaseProduct(identifier: enIdentifier.rawValue, onSuccess: {
            onSuccess()
        }) { errorMessage in
            onFailed(errorMessage)
        }
    }
    
    // base64でエンコードしたレシート
    internal func getReceipt4Base64String() -> String
    {
        guard let receipt = self.getReceipt() else { return "" }
        return receipt.base64EncodedString()
    }
    
    // アイテム購入履歴の確認（レシートが存在するか？）
    internal func isPurchased() -> Bool
    {
        guard let _ = self.getReceipt() else { return false }
        return true
    }
    
    // リストア
    internal func restore(complete: @escaping () -> ())
    {
        SwiftyStoreKit.restorePurchases(atomically: true) { result in
            for product in result.restoredPurchases
            {
                if product.needsFinishTransaction { SwiftyStoreKit.finishTransaction(product.transaction) }
            }
            complete()
        }
    }
    
    //********************************
    //  MARK: private function
    //********************************
    
    // プロダクトの取得
    fileprivate func getProducts(identifiers: Set<String>, complete: @escaping (Set<SKProduct>) -> ())
    {
        SwiftyStoreKit.retrieveProductsInfo(identifiers) { results in
            for id in results.invalidProductIDs { print("Invalid Product ID:\(id)") }
            complete(results.retrievedProducts)
        }
    }
    
    // プロダクトの購入（productで指定）
    fileprivate func purchaseProduct(product: SKProduct, onSuccess: @escaping () -> (), onFailed: @escaping () -> ())
    {
        SwiftyStoreKit.purchaseProduct(product) { result in
            if case .success(let product) = result
            {
                if product.needsFinishTransaction
                {
                    SwiftyStoreKit.finishTransaction(result as! PaymentTransaction)
                    onSuccess()
                }
            }
            else
            {
                // 購入失敗
                onFailed()
            }
        }
    }
    
    // プロダクトの購入（identifierで指定）
    fileprivate func purchaseProduct(identifier: String, onSuccess: @escaping () -> (), onFailed: @escaping (String) -> ())
    {   
        SwiftyStoreKit.purchaseProduct(identifier) { result in
            if case .success(let product) = result
            {
                if product.needsFinishTransaction
                {
                    SwiftyStoreKit.finishTransaction(result as! PaymentTransaction)
                    onSuccess()
                }
            }
            else if case .error(let error) = result
            {
                onFailed(error.localizedDescription)
            }
        }
    }
    
    // レシートの取得
    fileprivate func getReceipt() -> Data? { return SwiftyStoreKit.localReceiptData }
}
