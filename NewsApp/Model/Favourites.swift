//
//  Favourites.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-28.
//

import Foundation

struct Favourites {
    static var shared = Favourites()
    var articles: [Article] = []
    
    private init() {
    }
    
    var currentlyAddableArticle: Article?
    
    mutating func add(article: Article) {
//        print("Favourites in add, currentlyAddableArticle: \(currentlyAddableArticle)")
        if(currentlyAddableArticle != nil) {
            articles.append(currentlyAddableArticle!)
        } else {
            articles.append(article)
        }
        writeFavouritesToDefaults()
    }
    
    mutating func remove(article: Article) {
        // print("remove articles.count BEFORE: \(articles.count)")
        if let index = articles.firstIndex(of: article) {
            articles.remove(at: index)
            writeFavouritesToDefaults()
            
        }
    }
    
    func isFavourite(article: Article) -> Bool {
        return articles.contains(article)
    }
    
    mutating func toggleFavourite(article: Article) -> Bool {
        if(isFavourite(article: article)) {
            remove(article: article)
            return false
        } else {
            add(article: article)
            return true
        }
    }
    
    func writeFavouritesToDefaults() {
        print("writeFavouritesToDefaults")
        
        let favourites = self.articles 
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(favourites)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "favourites")
            print("writeFavouritesToDefaults data: \(data)")
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    
}
