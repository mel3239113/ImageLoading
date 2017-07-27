//
//  CollectionViewControllerEbay.swift
//  EbayTask
//
//  Created by Matthew Lewis on 7/26/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

enum Result<T> {
    
    case Success(T)
    case Failure(Error)
    
}

protocol Gettable {
    
    associatedtype Data
    func get(completionHandler:@escaping (Result<Data>) -> Void)
    
}

class EbayImageService : Gettable {
    
    typealias Data = [EbayImage]
    
    func get(completionHandler: @escaping (Result<[EbayImage]>) -> Void) {
        
        guard let requestUrl = URL(string: "http://m.mobile.de/svc/a/242019249") else { return }
        let request = URLRequest(url: requestUrl)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil , let usableData = data {
                
                let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                
                if let jsonDictionary = json as? [String : Any]{
                    
                    let jsonArray = jsonDictionary["images"]
                    
                    if let json = jsonArray as? Array<Any> {
                        
                        let images = self.createEbayImages(arrayOfJSONObjects: json)
                        print(images)
                        let result = Result.Success(images)
                        completionHandler(result)
                        
                    }
                    
                }
            }
        }
        task.resume()
        
    }
    
    func createEbayImages(arrayOfJSONObjects objects : Array<Any>) -> [EbayImage]   {
        
        var dataSource : [EbayImage] = []
        
        for json in objects {
            
            if let dic = json as? [String : String]{
                
                let uri = dic["uri"]
                let helper = UtilHelper()
                let image = helper.getImage(urlImageString: uri!)
                let ebay = EbayImage(image: image!)
                dataSource.append(ebay)
            }
        }
        
        return dataSource

    }
    
}


class CollectionViewControllerEbay: UICollectionViewController  {

    
    var dataSource = [EbayImage]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    let utilHelper : UtilHelper = UtilHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(EbayImageCollectionViewCell.self, forCellWithReuseIdentifier:EbayImageCollectionViewCell.EbayImageCollectionViewCellIndentifer )
        
        let ebayServiceManager = EbayImageService()
        self.getImages(fromService: ebayServiceManager)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImages<Service : Gettable>
        (fromService service : Service) where Service.Data == [EbayImage]{
        
        
        service.get() { [weak self] result in
            
            switch result {
            case .Success(let ebayImages):
                self?.dataSource = ebayImages
            case .Failure(let error):
                print("Balls")
            }
        }
        
        
    }


    
//    func getImageData() {
//        
//        
//        utilHelper.getIEbayImages(url: "http://m.mobile.de/svc/a/242019249") { (result : AnyObject) in
//            
//            print(result.debugDescription)
//            
//        }
//        
//        
//        
//        let ebayImage = EbayImage(urlThumbNail: "https://www.w3schools.com/css/trolltunga.jpg", urlLarge: "https://www.smashingmagazine.com/wp-content/uploads/2015/06/10-dithering-opt.jpg")
//        self.dataSource.append(ebayImage)
//        self.collectionView?.reloadData()
//        
//    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EbayImageCollectionViewCell.EbayImageCollectionViewCellIndentifer, for: indexPath) as! EbayImageCollectionViewCell
        cell.updateWithImage(ebayImage: self.dataSource[indexPath.row])
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ebayImage = self.dataSource[indexPath.row]
        
        let imageViewController = UIViewController()
        self.navigationController?.pushViewController(imageViewController, animated: true)
        
        
        DispatchQueue.global().async {
           // let image = util.getImage(urlImageString: url)
            
            DispatchQueue.main.async {
  
                let imageView = UIImageView(image: ebayImage.image)
                imageView.frame = imageViewController.view.frame
                imageViewController.view.addSubview(imageView)
            }
    
        }
        
    }
    
   
}
