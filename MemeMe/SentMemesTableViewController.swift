//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Kosrat D. Ahmad on 4/25/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes = [Meme]() {
        didSet {
            guard tableView != nil else { return }
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func addMeme() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! MemeEditorViewController
        present(controller, animated: true, completion: nil)
    }
}
