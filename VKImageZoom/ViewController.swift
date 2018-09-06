//
//  ViewController.swift
//  VKImageZoom
//
//  Created by Kondaiah V on 9/6/18.
//  Copyright © 2018 Kondaiah Veeraboyina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addImage_clicked(_ sender: UIButton) {
        
        // zoom image actions...
        let zoomCtrl = VKImageZoom()
        zoomCtrl.image = UIImage.init(named: "rose_victor.jpg")
        self.present(zoomCtrl, animated: true, completion: nil)
        
        // rose_victor.jpg //rose.jpeg //dahlia_blossom.jpeg
    }
    
    @IBAction func addImageUrl_clicked(_ sender: UIButton) {
        
        // zoom image action...
        let zoomCtrl = VKImageZoom()
        zoomCtrl.image_url = URL.init(string: "http://cdn.playbuzz.com/cdn/38402fff-32a3-4e78-a532-41f3a54d04b9/cc513a85-8765-48a5-8481-98740cc6ccdc.jpg")
        self.present(zoomCtrl, animated: true, completion: nil)
        
        // http://i.imgur.com/w5rkSIj.jpg
        // http://cdn.playbuzz.com/cdn/38402fff-32a3-4e78-a532-41f3a54d04b9/cc513a85-8765-48a5-8481-98740cc6ccdc.jpg
    }

}

