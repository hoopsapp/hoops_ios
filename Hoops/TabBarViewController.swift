//
//  TabBarViewController.swift
//  Hoops
//
//  Created by Joe on 20.08.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tabBar.selectedImageTintColor = UIColor(red: 4.0/255.0, green: 165.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        // auskommentiert
        /*
        var tabBarItem1 :       UITabBarItem
        var image1 = UIImage(named: "feed.png")
        var image2 = UIImage(named: "feed_chosen.png")
        
        
        tabBarItem1 = tabBar.items[0] as UITabBarItem
        tabBarItem1.title = "Feed"
        
      
        image1 = RBSquareImageTo(image1, size: CGSize(width: 60, height: 80))
        
        
        
        tabBarItem1.image = image1
        tabBarItem1.selectedImage = image2
        
        
        
        if (image1 == nil){
        println("Image == nil")
        }
        if (image1 != nil){
            println("Image != nil")
        }
        */
        
        
        
        //image1.drawInRect(CGRect(x: 0, y: 0, width: 40, height: 30))
        // var size = CGSize(30, 40)
        
        //println("You selected cell #\(indexPath.row)!")

                //tabBarItem1.selectedImage = UIImage(
        
        
        
        
        //tabBarController.tabBar.items[0]
        
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState: .Normal)
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState: .Selected)
        //tabBarController = self.window?.rootViewController as UITabBarController
        //tabBar = tabBarController.tabBar
    
        //var tabBarController :  TabBarViewController
        //var tabBar :            UITabBar
        //tabBar = TabBarViewController.tabBar()
        //UITabBarItem tabBarItem1 = tabBar.
    }
    
    
    // 19.11.2014 auskommentiert
    // Image Resize
    /*
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    */
    
}
