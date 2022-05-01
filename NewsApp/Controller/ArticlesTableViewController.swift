//
//  ArticlesTableViewController.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-27.
//

import UIKit
import Kingfisher

class ArticlesTableViewController: UITableViewController, APIServiceDelegate {
    
    var apiService: APIService?
    var category: String?
    var webTitle: String?
    var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = webTitle
        
        apiService = APIService.shared
        apiService?.delegate = self
        if(category != nil) {
            apiService?.getArticles(id: category!, page: 1, withSearchQuery: true) //page not used here yet.
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func categoriesAreFetched(categories: [Category]) {}
    
    func articlesAreFetchedWithSearchQuery(articles: [Article]) {        
        DispatchQueue.main.async {
            self.articles = articles
            self.tableView.reloadData()
        }
    }
    
    func articlesAreFetchedWithId(articles: [Article]) {}
    func articleIsFetched(article: Article) {}
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! NameWithImageTableViewCell
        cell.nameLabel?.text = articles?[indexPath.row].webTitle
        
        if let thumbnailUrlFromApi = articles?[indexPath.row].fields?.thumbnail {
            let imageURL = URL(string: thumbnailUrlFromApi)
            
            cell.theImageView!.kf.setImage(with: imageURL)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ArticleViewController
        let article = self.articles?[tableView.indexPathForSelectedRow!.row]
        destination.article = article
        destination.webTitle = article?.webTitle
        destination.urlString = article?.webUrl
        
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
