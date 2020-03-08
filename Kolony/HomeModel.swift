//
//  GetProducts.swift
//  Kolony
//
//  Created by Kedlaya on 3/1/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {

    weak var delegate: HomeModelProtocol!

    //var data = Data() //What is this??

    let urlPath: String = "http://192.168.0.20/kolony.php?type=pullProducts" //this will be changed to the path where service.php lives

    func downloadItems() {

        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        //print("Try 2")

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            //print("Try 3")

            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                //print(data)
                self.parseJSON(data!)
            }

        }

        task.resume()
    }
    
    let urlPath1: String = "http://192.168.0.20/kolony.php?type=pullProductSizes&productID="+ProductVC.prodID
    
    func downloadItemSizes() {

        let url: URL = URL(string: urlPath1)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        //print("Try 2")

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            //print("Try 3")

            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                //print(data)
                self.parseJSONSizes(data!)
            }

        }

        task.resume()
    }

    
    func parseJSON(_ data:Data) {

        var jsonResult = NSArray()

        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray

        } catch let error as NSError {
            print(error.localizedDescription)
            //print("Error Here")
            print(data)

        }

        var jsonElement = NSDictionary()
        let products = NSMutableArray()

        for i in 0 ..< jsonResult.count
        {

            jsonElement = jsonResult[i] as! NSDictionary

            let product = ProductsModel()

            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["productname"] as? String,
                let brand = jsonElement["productbrand"] as? String,
                let colorway = jsonElement["productcolorway"] as? String,
                let price = jsonElement["productprice"] as? String,
                let retail = jsonElement["productretail"] as? String,
                let style = jsonElement["productstyle"] as? String,
                let release = jsonElement["productrelease"] as? String,
                let id = jsonElement["productid"] as? String
            {

                product.name = name
                product.brand = brand
                product.colorway = colorway
                product.price = "$"+price
                product.retail = "$"+retail
                product.style = style
                product.release = release
                product.id = id

            }

            products.add(product)
        }

        DispatchQueue.main.async(execute: { () -> Void in

            self.delegate.itemsDownloaded(items: products)

        })
    }
    
    func parseJSONSizes(_ data:Data) {

        var jsonResult = NSArray()

        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray

        } catch let error as NSError {
            print(error.localizedDescription)
            //print("Error Here")
            print(data)

        }

        var jsonElement = NSDictionary()
        let sizeProducts = NSMutableArray()

        for i in 0 ..< jsonResult.count
        {

            jsonElement = jsonResult[i] as! NSDictionary

            let sizeProduct = SizeProductModel()

            //the following insures none of the JsonElement values are nil through optional binding
            if let individualID = jsonElement["eachproductid"] as? String,
                let prodID = jsonElement["productid"] as? String,
                let size = jsonElement["productsizes"] as? String
            {
                
                sizeProduct.individualID = individualID
                sizeProduct.prodID = prodID
                sizeProduct.size = size

            }

            sizeProducts.add(sizeProduct)
        }

        DispatchQueue.main.async(execute: { () -> Void in

            self.delegate.itemsDownloaded(items: sizeProducts)

        })
    }
}
