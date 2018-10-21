//
//  VKImageZoom.swift
//  VKImageZoom
//
//  Created by Kondaiah V on 9/6/18.
//  Copyright © 2018 Kondaiah Veeraboyina. All rights reserved.
//

import UIKit

class VKImageZoom: UIViewController {

    // assign image...
    var image: UIImage?
    // assign image url...
    var image_url: URL?
    // default image width...
    private var img_width: CGFloat = 0.0
    // default image height...
    private var img_height: CGFloat = 0.0
    // image display scroll view...
    private var img_scroll: UIScrollView?
    // imageview for image...
    private var zoom_imgView: UIImageView?
    // dismiss button...
    private var cancel_btn: UIButton?
    // indicator...
    private var act_indicator: UIActivityIndicatorView?
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add components...
        self.view.backgroundColor = UIColor.black
        addView_components()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceOrientationDidChange(notification:)),
                                               name: .UIDeviceOrientationDidChange,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:-
    @objc private func deviceOrientationDidChange(notification: Notification) {
        addView_components()
    }
    
    private func addView_components() -> Void {
        
        img_width = self.view.frame.size.width
        img_height = self.view.frame.size.height
        let status_height = UIApplication.shared.statusBarFrame.height
        
        // create scroll view...
        if img_scroll != nil {
            img_scroll?.removeFromSuperview()
        }
        img_scroll = UIScrollView()
        img_scroll?.frame = CGRect.init(x: 0, y: status_height, width: img_width, height: (img_height-2*status_height))
        img_scroll?.backgroundColor = UIColor.clear
        img_scroll?.bouncesZoom = true
        img_scroll?.delegate = self
        img_scroll?.clipsToBounds = true
        img_scroll?.maximumZoomScale = 4.0
        img_scroll?.minimumZoomScale = 1.0
        img_scroll?.zoomScale = 1.0
        self.view.addSubview(img_scroll!)
        
        // create zoom image view...
        zoom_imgView = UIImageView()
        zoom_imgView?.isUserInteractionEnabled = true
        zoom_imgView?.backgroundColor = UIColor.clear
        zoom_imgView?.frame = CGRect.init(x: 0, y: status_height, width: img_width, height: (img_height-2*status_height))
        zoom_imgView?.center = (img_scroll?.center)!
        img_scroll?.addSubview(zoom_imgView!)
        
        // create cancel button...
        if cancel_btn != nil {
            cancel_btn?.removeFromSuperview()
        }
        cancel_btn = UIButton(type: .custom)
        cancel_btn?.frame = CGRect.init(x: (img_width-36), y: (status_height+6), width: 30, height: 30)
        cancel_btn?.backgroundColor = UIColor.clear
        cancel_btn?.setTitle("X", for: .normal)
        cancel_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cancel_btn?.setTitleColor(UIColor.white, for: .normal)
        cancel_btn?.addTarget(self, action:#selector(cancelButtonClicked(button:)), for: .touchUpInside)
        self.view.addSubview(cancel_btn!)
        
        // corner radius...
        cancel_btn?.layer.cornerRadius = 30/2
        cancel_btn?.layer.borderWidth = 2.0
        cancel_btn?.layer.borderColor = UIColor.white.cgColor
        
        // create indicator...
        if act_indicator != nil {
            act_indicator?.removeFromSuperview()
        }
        act_indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        act_indicator?.center = self.view.center
        act_indicator?.stopAnimating()
        self.view.addSubview(act_indicator!)
        
        // loading images...
        loadingImages()
        
        // add double tab gesture to images...
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired = 2
        zoom_imgView?.addGestureRecognizer(doubleTap)
        
        // Set zoom value Max = 4.0 & Min = 1.0
        img_scroll?.contentSize = CGSize.init(width: (zoom_imgView?.bounds.width)!, height: (zoom_imgView?.bounds.size.height)!)
        img_scroll?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    @objc private func cancelButtonClicked(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        
        let loImgView = gestureRecognizer.view as! UIImageView
        let loZoomView = loImgView.superview as! UIScrollView
        
        // zoom_in...
        var newScale = loZoomView.zoomScale * CGFloat(ZOOM_STEP)
        if newScale > loZoomView.maximumZoomScale {
            newScale = loZoomView.minimumZoomScale
        }
        else {
            newScale = loZoomView.maximumZoomScale
        }
        
        // after zoom_in or zoom_out rect...
        let zoomRect = zoomRectForScale(scale: newScale, center: gestureRecognizer.location(in: gestureRecognizer.view), sendImgView: loImgView)
        loZoomView.zoom(to: zoomRect, animated: true)
    }
}

// MARK:-
extension VKImageZoom {
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint, sendImgView: UIImageView) -> CGRect {
        
        var zoomRect = CGRect()
        // the zoom rect is in the content view's coordinates.
        //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
        //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
        zoomRect.size.height = sendImgView.frame.size.height / scale
        zoomRect.size.width = sendImgView.frame.size.width / scale
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    func loadingImages() {
        
        // static image zooming...
        if self.image != nil {
            
            // adding images...
            zoom_imgView?.image = self.image
            
            // image width and height calculations...
            let imageSize = imageWidth_height(image: zoom_imgView?.image)
            zoom_imgView?.frame = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            zoom_imgView?.center = (img_scroll?.center)!
        }
        else if image_url != nil {  // image loading with url...
            
            // downloading images...
            act_indicator?.startAnimating()
            let session = URLSession.shared.dataTask(with: image_url!)
            { (data, response, error) in
                
                // if its error occuring...
                DispatchQueue.main.async {
                    self.act_indicator?.stopAnimating()
                }
                if error != nil {
                    print(error!)
                    return
                }
                
                // getting images...
                DispatchQueue.main.async {
                    if let load_image = UIImage(data: data!) {
                        
                        // adding images...
                        self.zoom_imgView?.image = load_image
                        
                        // image width and height calculations...
                        let imageSize = self.imageWidth_height(image: self.zoom_imgView?.image)
                        self.zoom_imgView?.frame = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                        self.zoom_imgView?.center = (self.img_scroll?.center)!
                    }
                }
            }
            session.resume()
        }
        else {
            print("No image allocated...")
        }
    }
    
    func imageWidth_height(image: UIImage?) -> (width: CGFloat, height: CGFloat) {
        
        // image height & weight...
        var imgWidth = image?.size.width ?? CGFloat(0)
        var imgHeight = image?.size.height ?? CGFloat(0)
        
        if imgWidth >= imgHeight {
            
            // width ratio calculating...
            let widthRatio = imgWidth/img_width
            let finalHeight = imgHeight/widthRatio
            
            imgWidth = img_width
            imgHeight = finalHeight
        }
        else {
            
            // height ratio calculating...
            let heightRatio = imgHeight/img_height
            let finalWidth = imgWidth/heightRatio
            
            imgWidth = finalWidth
            imgHeight = img_height
        }
        return (imgWidth, imgHeight)
    }
}


// MARK:-
extension VKImageZoom: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let offset_X = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offset_Y = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        
        // getting scroll child as uiimageview...
        for i in 0 ..< scrollView.subviews.count {
            
            let subScroll = scrollView.subviews[i]
            if subScroll is UIImageView {
                subScroll.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offset_X, y: scrollView.contentSize.height * 0.5 + offset_Y)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        var scroll_child: UIView!
        for i in 0 ..< scrollView.subviews.count {
            
            // getting scroll child as uiimageview...
            let subScroll = scrollView.subviews[i]
            if subScroll is UIImageView {
                scroll_child = subScroll
                break
            }
        }
        return scroll_child
    }
}

// Zoom level...
let ZOOM_STEP = 2.0

