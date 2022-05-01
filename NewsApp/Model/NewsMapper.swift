//
//  NewsMapper.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-24.
//

import Foundation

struct CategoriesMapper: Decodable {
    var response: CategoriesResponse
}

struct CategoriesResponse: Decodable {
    var status: String
    var userTier: String
    var results: [Category]?
    
}

struct Category: Decodable {
    var id: String
    var webTitle: String
    var webUrl: String
}
//--------------------
struct ArticlesMapper: Decodable {
    var response: ArticlesResponse
}

struct ArticlesResponse: Decodable {
    var status: String
    //    var pageSize: Int
    //    var pages: Int
    //    var currentPage: Int
    var results: [Article]?
    
}

struct Article: Codable, Equatable {
    //var sectionName: String
    var webTitle: String
    var webUrl: String
    var fields: Field?
    
}

struct Field: Codable, Equatable {
    var thumbnail: String?
}


//----------
struct SingleArticleMapper: Decodable {
    var response: SingleArticleResponse
}

struct SingleArticleResponse: Decodable {
    var status: String
    //    var pageSize: Int
    //    var pages: Int
    //    var currentPage: Int
    var content: Article?
    
}
