//
//  StripeCart.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [ProductInventory]()
    var itemPrices = [Double]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    //Variables for subtotal, processing dees, total
    
    //Note: Stripe takes payment in cents
    var subtotal: Int{
        var amount = 0
        for price in itemPrices{
            let pricePennies = Int(price*100)
            amount += pricePennies
        }
        return amount //Returns subtotal of all items in Strip Cart
    }
    
    var processingFees: Int{
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total: Int{
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: ProductInventory, price: Double){
        cartItems.append(item)
        itemPrices.append(price)
    }
    
    func removeItemFromCart(item: ProductInventory){
        if let index = cartItems.firstIndex(of: item){
            cartItems.remove(at: index)
        }
    }
    
    func removeAllItems(){
        cartItems.removeAll()
    }
    
}
