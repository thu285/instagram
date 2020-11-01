//
//  SinglePostViewController.swift
//  insta
//
//  Created by Thu Do on 10/31/20.
//

import UIKit
import Parse

class SinglePostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var post : PFObject!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    var comments = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set image of post
        let imageFile = post["image"] as! PFFileObject
        let urlStr = imageFile.url!
        let url = URL(string: urlStr)!
        imageView.af.setImage(withURL: url)
        
        // set profile image
        let user = post["author"] as! PFUser
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        if user["profile_pic"] != nil {
            let profileImageFile = user["profile_pic"] as! PFFileObject
            let pUrlStr = profileImageFile.url!
            let pUrl = URL(string: pUrlStr)!
            profileImageView.af.setImage(withURL: pUrl)
        }
        
        // set username and caption
        nameLabel.text = user.username
        captionLabel.text = post["caption"] as! String
        
        // set table delegate & data source
        commentTableView.delegate = self
        commentTableView.dataSource = self
        loadComments()
        commentTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    func loadComments() {
        comments = (post["comments"] as? [PFObject]) ?? []
        commentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        let comment = comments[indexPath.section]
        cell.commentLabel.text = comment["text"] as? String
        
        let user = comment["author"] as! PFUser
        cell.nameLabel.text = user.username
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        if user["profile_pic"] != nil {
            let imageFile = user["profile_pic"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            cell.profileImage.af.setImage(withURL: url)
            
        }
        
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
