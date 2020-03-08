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
                let size = jsonElement["productsize"] as? String,
                let colorway = jsonElement["productcolorway"] as? String,
                let price = jsonElement["productprice"] as? String,
                let retail = jsonElement["productretail"] as? String,
                let style = jsonElement["productstyle"] as? String,
                let release = jsonElement["productrelease"] as? String
            {

                product.name = name
                product.brand = brand
                product.size = size
                product.colorway = colorway
                product.price = "$"+price
                product.retail = "$"+retail
                product.style = style
                product.release = release

            }

            products.add(product)
        }

        DispatchQueue.main.async(execute: { () -> Void in

            self.delegate.itemsDownloaded(items: products)

        })
    }
}
