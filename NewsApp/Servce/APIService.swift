//
//  APIService.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-24.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseUrl = "https://content.guardianapis.com/"
    
    //Put your API Key here. See: https://open-platform.theguardian.com/access/
    private let apiKey = "" 
    
    var delegate: APIServiceDelegate?
    
    private init() {
    }
    
    func getApiKey() -> String {
        if(apiKey.count > 0) {
            return apiKey
        } else {
            print("\n\n A (free) API is needed for this app to work. See: https://open-platform.theguardian.com/access/  \n\n")
            return ""
        }
    }
    
    func getCategories() {
        let urlString = baseUrl + "sections?api-key=" + getApiKey()
        if let url = URL.init(string: urlString) {
            print(url)
            
            let session = URLSession(configuration: .default)
            print(session)
            
            let task = session.dataTask(with: url, completionHandler: {data, response, error in
                if (error != nil) {
                    print("We got an error here: \(String(describing: error))")
                    return
                }
                guard let responseData = data else {
                    print("Got no data")
                    return
                }
                print("responseData: \(responseData)")
                if let news = self.decodeJsonForCategories(categoriesData: responseData) {
                    // print("news: \(news)")
                    if (news.response.status == "ok") {
                        if let categories = news.response.results {
                            self.delegate?.categoriesAreFetched(categories: categories)
                            // print("subjects: \(subjects)")
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    func getArticles(id: String, page: Int, withSearchQuery: Bool) { // SKA INTE HÅRDKODA STRÄNG
        let urlString: String
        if(withSearchQuery) {
            urlString = "\(baseUrl)search?q=\(id)&show-fields=thumbnail&page=\(page)&api-key=\(getApiKey())"
        } else {
            urlString = "\(baseUrl)\(id)?show-fields=thumbnail&page=\(page)&api-key=\(getApiKey())"
        }
        
        if let url = URL.init(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: {data, response, error in
                if (error != nil) {
                    print("We got an error here: \(String(describing: error))")
                    return
                }
                
                guard let responseData = data else {
                    print("Got no data")
                    return
                }
                if let articles = self.decodeJsonForArticles(articlesData: responseData) {
                    //  print("news: \(news)")
                    if (articles.response.status == "ok") {
                        //                        print("Response status is ok")
                        if let articles = articles.response.results {
                            //                            print("articlesarticlesarticles, withSearchQuery: \(withSearchQuery) self.delegate? \(self.delegate) \(articles)")
                                self.delegate?.articlesAreFetched(articles: articles)
                        }
                    }
                }
                
            })
            task.resume()
        } else {
            print("URL doesn't work...")
        }
    }
    
    func getArticle(apiUrlString: String) { // SKA INTE HÅRDKODA STRÄNG
        print("getArticle apiUrlString: \(apiUrlString)")
        
        if let url = URL.init(string: apiUrlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: {data, response, error in
                if (error != nil) {
                    print("We got an error here: \(String(describing: error))")
                    return
                }
                
                guard let responseData = data else {
                    print("Got no data")
                    return
                }
                //                print("responseData: \(responseData)")
                if let article = self.decodeJsonForSingleArticle(articleData: responseData) {
                    //                                        print("article here: \(article)")
                    if (article.response.status == "ok") {
                        print("Response status is ok")
                        if let singleArticle = article.response.content {
                            //                                                        print("singleArticle: \(singleArticle)")
                            self.delegate?.articleIsFetched(article: singleArticle)
                        }
                    }
                }
                
            })
            task.resume()
        } else {
            print("URL doesn't work...")
        }
    }
    
    func getResponsData(urlString: String) -> Data? {
        return nil
    }
    
    
    func recieveMapper(mapper: CategoriesMapper.Type) {
    }
    
    func decodeJsonForCategories(categoriesData: Data) -> CategoriesMapper? {
        let decoder = JSONDecoder()
        let categoriesMapper = CategoriesMapper.self
        recieveMapper(mapper: categoriesMapper)
        
        do {
            let mapper = try decoder.decode(CategoriesMapper.self, from: categoriesData)
            return mapper
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    
    func decodeJsonForArticles(articlesData: Data) -> ArticlesMapper? {
        let decoder = JSONDecoder()
        
        do {
            let mapper = try decoder.decode(ArticlesMapper.self, from: articlesData)
            return mapper
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    func decodeJsonForSingleArticle(articleData: Data) -> SingleArticleMapper? {
        let decoder = JSONDecoder()
        
        do {
            let mapper = try decoder.decode(SingleArticleMapper.self, from: articleData)
            return mapper
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    
    
}


protocol APIServiceDelegate {
    func categoriesAreFetched(categories: [Category])
    func articleIsFetched(article: Article)
    func articlesAreFetched(articles: [Article])
}


