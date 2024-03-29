//
//  ViewModel.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var items = [PostModel]()
    @Published private(set) var isLoding = false
    
    init() {
        fetchPosts()
    }
    
    // Retrieve data
    func fetchPosts() {
        if isLoding == false {
            isLoding = true
            guard let url = URL(string: "http://localhost:8000/todos") else {
                print("Not found url")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                    return
                }
                
                do {
                    
                    if let data = data {
                        let result = try JSONDecoder().decode([PostModel].self, from: data)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.items = result
                            self.isLoding = false
                        }
                        
                    }else {
                        print("No data")
                    }
                    
                }catch (let error) {
                    print(error.localizedDescription)
                }
            }.resume()
            
        }
    }
        
    
    // Create new data
    func createPost(paramaters: [String: Any]) {
        if isLoding == false {
            isLoding = true
            guard let url = URL(string: "http://localhost:8000/todos") else {
                print("Not found url")
                return
            }
            
            let data = try! JSONSerialization.data(withJSONObject: paramaters)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("Error", error?.localizedDescription ?? "Error")
                }else {
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(PostModel.self, from: data)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                print(result)
                                self.items.insert(result, at: 0)
                                print(self.items[0])
                                self.isLoding = false
                            }
                            
                        }else {
                            print("No data")
                        }
                        
                    }catch let JsonError {
                        print("Fetch json error: ", JsonError.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    
    // Update data
    func updatePost(idUpdate: Int, paramaters: [String: Any]) {
        if isLoding == false {
            isLoding = true
            guard let url = URL(string: "http://localhost:8000/todos/\(idUpdate)") else {
                print("Not found url")
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: paramaters)
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("Error", error?.localizedDescription ?? "Error")
                }else {
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(PostModel.self, from: data)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                print(result)
                                for (index, post) in self.items.enumerated() where post.id == idUpdate {
                                    self.items[index] = result
                                }
                                self.isLoding = false
                            }
                            
                        }else {
                            print("No data")
                        }
                        
                    }catch let JsonError {
                        print("Fetch json error: ", JsonError.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    
    // Delete data
    func deletePost(idDelete: Int, paramaters: [String: Any]) {
        guard let url = URL(string: "http://localhost:8000/todos/\(idDelete)") else {
            print("Not found url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: paramaters)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error", error?.localizedDescription ?? "Error")
            }else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Success")
                    }
                }
            }
        }.resume()
    }
}
