//
//  FavouritesTableViewController.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-28.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favourites.shared.articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! NameWithImageTableViewCell
        self.article = Favourites.shared.articles[indexPath.row]
        
        cell.nameLabel?.text = self.article!.webTitle
        
        if let thumbnailUrlFromApi = self.article!.fields?.thumbnail {
            let imageURL = URL(string: thumbnailUrlFromApi)
            cell.theImageView!.kf.setImage(with: imageURL)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ArticleViewController
        
        self.article = Favourites.shared.articles[tableView.indexPathForSelectedRow!.row]
        destination.article = self.article
        destination.webTitle = self.article?.webTitle
        destination.urlString = self.article?.webUrl        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, 
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove from Favourites") {
            //Skapa closure...
            (action, sourceView, completionHandler) in
            
            let currentArticle = Favourites.shared.articles[indexPath.row]
            Favourites.shared.remove(article: currentArticle)
            tableView.reloadData()
            
            completionHandler(true)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfig
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
