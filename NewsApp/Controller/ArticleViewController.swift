//
//  ArticleViewController.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-28.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate, APIServiceDelegate {
    
    @IBOutlet var favouriteButton: UIBarButtonItem?
    
    var article: Article?
    var webTitle: String?
    var urlString: String?
    @IBOutlet var webView: WKWebView?
    
    // Use APIService instead
    let baseWebUrlString = "https://www.theguardian.com/"
    let baseApiUrlString = "https://content.guardianapis.com/"    
    
    override func loadView() {
        super.loadView()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = webTitle
        setupFavouritesButton()
        
        
        webView?.navigationDelegate = self
        if(webView != nil) {
            //            print("1111111111111 Ja")
            webView!.allowsBackForwardNavigationGestures = true
        }
        if(urlString != nil) {
            load(urlString!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("VIEW DID APPEAR")
        APIService.shared.delegate = self
        setupFavouritesButton()
        
        //Metod istället:
        if(self.webView!.backForwardList.backList.count > 0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("didStartProvisionalNavigation  + \(self.webView?.title)" + "backList: \(self.webView!.backForwardList.backList)")
        disableFavouritesButton()
        
        //Metod istället:
        if(self.webView!.backForwardList.backList.count > 0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        if(self.webView!.backForwardList.currentItem != nil) {
            self.webTitle = self.webView!.backForwardList.currentItem!.title
            self.navigationItem.title = self.webTitle
            
            self.urlString = self.webView?.url?.absoluteString
            let apiUrlString = apiLinkFromWebLink()
            APIService.shared.getArticle(apiUrlString: apiUrlString)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("didCommit  + \(self.webView?.title)")
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("didFinish navigation + \(self.webView?.title)")
        self.webTitle = self.webView?.title
        self.navigationItem.title = self.webTitle
        self.urlString = self.webView?.url?.absoluteString
        
        //Metod istället:
        if(self.webView!.backForwardList.backList.count > 0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            let apiUrlString = apiLinkFromWebLink()
            APIService.shared.getArticle(apiUrlString: apiUrlString)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func categoriesAreFetched(categories: [Category]) {}
    func articlesAreFetched(articles: [Article]) {}
    
    func articleIsFetched(article: Article) {
        //        print("articleIsFetched in ArticleViewController, article: \(article)")
        self.article = article
        Favourites.shared.currentlyAddableArticle = article
        enableFavouritesButton()
        setupFavouritesButton()
        
        //        getHTML()
    }
    
    
    //Use FIRST image in results objects array:
    //Category: artanddesign:
    //https://content.guardianapis.com/artanddesign?show-fields=thumbnail&api-key=the_API_key
    //But maybe (probably) skip image in CATEGORIES list
    
    //Get PAGE 2 of category artanddesign:
    //https://content.guardianapis.com/artanddesign?show-fields=thumbnail&page=2&api-key=the_API_key
    
    
    //MAYBE to get a bigger image, otherwise skip.
    func getHTML() {
        print("getHTMLgetHTMLgetHTML")
        
        let session = URLSession.shared
        if let url = URL(string: self.urlString!) {
            let task = session.dataTask(with: url) { data, response, error in
                // Check whether data is not nil
                guard let loadedData = data else { return }
                // Load HTML code as string
                let contents = String(data: loadedData, encoding: .utf8)!
                // print(contents)
//                let decoder = JSONDecoder()
                do {
//                    let something =  try decoder.decode(String.self, from: loadedData) 
                    // print(something)
                    // print("LENGTH: \(something.count)")
                } 
//                catch {
//                    print("CAN'T")
//                }
                self.getMainImageUrl(htmlString: contents)
            }
            task.resume()
        }
    }
    
    func getMainImageUrl(htmlString: String) {
        let substring = htmlString.split(separator: "<", maxSplits: 100, omittingEmptySubsequences: true)
        print(substring)
        print("LENGTH: \(substring.count)")
    }
    
    func apiLinkFromWebLink() -> String {
        let baseStringLength = baseWebUrlString.count
        let range = String.Index(encodedOffset: baseStringLength)..<urlString!.endIndex
        let idString = urlString![range]
        
        let apiUrl = "\(baseApiUrlString)\(idString)" + "?show-fields=thumbnail" + "\("&api-key=")\(APIService.shared.getApiKey())"
        
        return apiUrl
    }
    
    
    
    func setupFavouritesButton() {
        DispatchQueue.main.async {
            if(Favourites.shared.isFavourite(article: self.article!)) {
                self.favouriteButton?.image = UIImage(systemName: "heart.fill")
            } else {
                self.favouriteButton?.image = UIImage(systemName: "heart")
            }
        }
    }
    
    func disableFavouritesButton() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func enableFavouritesButton() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func load(_ urlString: String) {
        print("load")
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            self.webView?.load(request)
        }
    }
    
    
    @IBAction func favouriteButtonClicked(_ sender: UIBarButtonItem) {
        print("favouriteButtonClicked")
        let toggledOff = Favourites.shared.toggleFavourite(article: self.article!)
        print("toggledOff \(toggledOff)")
        if(toggledOff) {
            sender.image = UIImage(systemName: "heart.fill")
        } else {
            sender.image = UIImage(systemName: "heart")
        }
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
