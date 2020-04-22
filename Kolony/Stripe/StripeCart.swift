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
    var cartProducts = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    //Variables for subtotal, processing dees, total
    
    //Note: Stripe takes payment in pennies
    var subtotal: Int{
        var amount = 0
        for price in cartProducts{
            let pricePennies = Int(price.price*100)
            amount += pricePennies
        }
        return amount //Returns subtotal of all items in Strip Cart
    }
    
    //To account for the cut that Stripe, add and calculate that cut as processing fees
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
    
    //Add to cart
    func addItemToCart(item: ProductInventory, product: Product){
        cartItems.append(item)
        cartProducts.append(product)
    }
    
    //Remove from cart
    func removeItemFromCart(item: ProductInventory){
        if let index = cartItems.firstIndex(of: item){
            cartItems.remove(at: index)
            cartProducts.remove(at: index)
        }
    }
    
    //Empty cart
    func clearCart(){
        cartItems.removeAll()
        cartProducts.removeAll()
        shippingFees = 0
    }
    
}
