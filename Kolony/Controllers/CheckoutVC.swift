//
//  CheckoutVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutVC: UIViewController, CartCellDelegate {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buyBtn: RoundedButton!
    
    //Variables
    var paymentContext : STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Once again")
        print("User: \(UserService.user.email)")
        print("Userid: \(UserService.user.stripeId)")
        
        setupTableView()
        setcheckoutData()
        setupStripeConfig()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setcheckoutData(){
        subtotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
        
        buyBtn.isEnabled = true
        
        if (subtotalLabel.text == "$0.00"){
            buyBtn.isEnabled = false
        }
    }
    
    @IBAction func placeOrderOnClick(_ sender: Any) {
        paymentContext.requestPayment() //Automatically prompts for shipping or payment information if user tries to place order witout having that information ob file
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodOnClick(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodOnClick(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func setupStripeConfig(){

        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]

        let customerContext = STPCustomerContext(keyProvider: StripeApi)

        //Change theme here if you want to have a different theme
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        //Set payment amount in Stripe
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    //When remove item button is clicked
    func removeItem(productInventory: ProductInventory) {
        StripeCart.removeItemFromCart(item: productInventory)
        tableView.reloadData()
        setcheckoutData()
        setupStripeConfig()
        //Refresh amount in Stripe too
        paymentContext.paymentAmount = StripeCart.total
    }
    
    //Alert Popup
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true,completion: nil)
    }
}

extension CheckoutVC: STPPaymentContextDelegate{
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //Update selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption{
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        //Udpate selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(shippingMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100) //Convert to pennies as Stripe accepts payment sin the lowes denomination of currency
            setcheckoutData() //Update payment info in View
        } else {
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }
    }
    
    //If error occurs when processing payment (Eg: User does not have a stripe id, etc.)
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        //let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertController = UIAlertController(title: "Hi friend!", message: "This is a user only feature. Please create an account with us to be able to access all of our features.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true) //Dismiss VC
        }
        
        //let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            //self.paymentContext.retryLoading() //Try loading again
        let signup = UIAlertAction(title: "Sign-Up", style: .cancel) { (action) in
            MainVC.goTo("SignUpVC", animate: true)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(signup)
        //alertController.addAction(retry)
        present(alertController,animated: true,completion: nil)
    }
    
    //Send payment information to cloud function
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        //Idempotency safely retries requests without performing same operatin twice
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data : [String: Any] = [
            "total_amount" : StripeCart.total,
            "customer_id" : UserService.user.stripeId,
            "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency" : idempotency
        ]
                
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            //If payment request was not successful
            if let error = error {
                debugPrint(error.localizedDescription)
                self.alert(title: "Error", message: "Unable to make charge.")
                completion(STPPaymentStatus.error, error)
                return
            }
            //If request was successful
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setcheckoutData()
            completion(.success, nil)
        }
    }

    //Check on status after request was made about whether payment was successfully made
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        activityIndicator.stopAnimating()
        
        switch status{
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Thank you for your purchase."
        case .userCancellation:
            return
        @unknown default:
            fatalError()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Setup shipping method
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Gound"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        //If address is in the US, consider valid Address
        if address.country == "US" { //US is ISO country code, can
            completion(.valid, nil, [upsGround, fedEx], fedEx) //fedEx is set as default
        } else {
            completion(.invalid,nil, nil, nil)
        }
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell {
            
            cell.configureCell(productInventory: StripeCart.cartItems[indexPath.row], product: StripeCart.cartProducts[indexPath.row], delegate: self)
            
            return cell
        }
        
        return UITableViewCell()
    }
}
