//
//  stackedImageViewController.swift
//  SwipeTest
//
//  Created by Ayano Ohya on 2016/10/07.
//  Copyright © 2016年 Ayano Ohya. All rights reserved.
//

import UIKit
import Photos
protocol ViewControllerDelegate {
    func checkStackedAssets(stackedAssets: [PHAsset])
}

class stackedImageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    
    var delegate: ViewControllerDelegate! = nil
    
    @IBOutlet var collectionView: UICollectionView!
    var stackedAssets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    //cellが何個必要か
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stackedAssets.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2
        
        let imageView: UIImageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = self.getAssetThumbnail(self.stackedAssets[indexPath.row])
        return cell
    
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 560.0, height: 560.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in thumbnail = result!
        })
        return thumbnail
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert:UIAlertController = UIAlertController(title:"Remove from a trash box",
                                                              message: "",
                                                              preferredStyle: .Alert)
        //Cancel 一つだけしか指定できない
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.Cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        print("Cancel")
        })
        //Default 複数指定可
        let defaultAction:UIAlertAction = UIAlertAction(title: "復元",
                                                        style: UIAlertActionStyle.Default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            self.stackedAssets.removeAtIndex(indexPath.row)
                                                            self.collectionView.reloadData()
                                                            self.delegate.checkStackedAssets(self.stackedAssets)
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        //表示。UIAlertControllerはUIViewControllerを継承している。
        presentViewController(alert, animated: true, completion: nil)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
