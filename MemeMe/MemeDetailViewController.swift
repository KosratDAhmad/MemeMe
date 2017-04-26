//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kosrat D. Ahmad on 4/27/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }

}
