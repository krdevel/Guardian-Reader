//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-04-17.
//

import UIKit

class NewsTableViewController: UITableViewController, UITableViewDataSourcePrefetching, APIServiceDelegate {
    
    var apiService: APIService?
    var id: String?
    var articles: [Article] = []
    var viewDidLoadTriggered = false
    var currentlyFetchedAtIndex = 0
    var currentPage = 1
    var prefetchDistance = 2 //Nog mer än 1, även om det blir många API-anrop
    var useSearchQuery = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewsTableViewController viewDidLoad")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        apiService = APIService.shared
        apiService?.delegate = self
        fetchArticles()
        viewDidLoadTriggered = true
        tableView.prefetchDataSource = self
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        addToBeNotifiedWhenWillEnterForeground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("NewsTableViewController viewDidAppear")
        apiService?.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        if(viewDidLoadTriggered) {
//            viewDidLoadTriggered = false
//        } else {
//            refresh(sender: self)
//        }
    }
    
    func addToBeNotifiedWhenWillEnterForeground() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refresh), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func fetchArticles() {
        print("fetchArticlesfetchArticlesfetchArticles")
        apiService?.getArticles(id: self.id!, page: self.currentPage, withSearchQuery: self.useSearchQuery)
    }
    
    func categoriesAreFetched(categories: [Category]) {}
    func articlesAreFetchedWithSearchQuery(articles: [Article]) {
        DispatchQueue.main.async {
            self.articles.append(contentsOf: articles)
            self.currentlyFetchedAtIndex = self.articles.count - 1
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    func articlesAreFetchedWithId(articles: [Article]) {
        DispatchQueue.main.async {
            self.articles.append(contentsOf: articles)
            self.currentlyFetchedAtIndex = self.articles.count - 1
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    func articleIsFetched(article: Article) {}
    
    @objc func refresh(sender:AnyObject) {
        print("refresh")
        fetchArticles()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NameWithImageTableViewCell
        cell.nameLabel?.text = articles[indexPath.row].webTitle
//        cell.nameLabel?.text = "\(articles[indexPath.row].webTitle) i: \(indexPath.row) l: \(articles.count)"
        
        if let thumbnailUrlFromApi = articles[indexPath.row].fields?.thumbnail {
            let imageURL = URL(string: thumbnailUrlFromApi)
            let image = UIImage(named: "placeHolder_black")
            
            cell.theImageView!.kf.setImage(with: imageURL, placeholder: image, options: [.transition(.fade(0.1))])
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ArticleViewController
        let article = self.articles[tableView.indexPathForSelectedRow!.row]
        destination.article = article
        destination.webTitle = article.webTitle
        destination.urlString = article.webUrl
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        //        print("willDisplay Cell self.currentlyFetchedAtIndex: \(self.currentlyFetchedAtIndex), indexPath.row: \(indexPath.row), self.prefetchDistance: \(self.prefetchDistance)")
        if((self.currentlyFetchedAtIndex - indexPath.row) < self.prefetchDistance ) {
            print("SAME, FETCH!")
            self.currentPage += 1
            refresh(sender: self)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchRowsAt: \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {        
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
