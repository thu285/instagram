//
//  ProfileGridViewController.swift
//  insta
//
//  Created by Thu Do on 10/31/20.
//

import UIKit
import AlamofireImage
import Parse

class ProfileGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var posts = [PFObject]()
    var user = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = (view.frame.size.width-layout.minimumInteritemSpacing*2)/3
        layout.itemSize = CGSize(width: width, height: width)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        username.text = user.username
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        
    }
    
    func loadPosts() {
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"]).whereKey("author", equalTo: user)
        query.limit = 20
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.item]
        let imageFile = post["image"] as! PFFileObject
        let urlStr = imageFile.url!
        let url = URL(string: urlStr)!
        cell.photoView.af.setImage(withURL: url)
        return cell
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
