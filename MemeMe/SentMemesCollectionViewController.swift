//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Kosrat D. Ahmad on 4/25/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    var memes = [Meme]() {
        didSet {
            guard collectionView != nil else { return }
            
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func addMeme() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! MemeEditorViewController
        present(controller, animated: true, completion: nil)
    }

}
