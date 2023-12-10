//
//  API.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/8/23.
//

import Foundation

final class API{
    
    
    static let shared = API()
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=eb13c1fb0d034928aaedff13b205f02f")
    }
    
    private init() {}
    
    public func getTopStories (completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else{
            
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let author: String?
    
}

struct Source: Codable{
    let name: String
}
