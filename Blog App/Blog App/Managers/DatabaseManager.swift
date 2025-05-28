//
//  DatabaseManager.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insert(
        blogPost: BlogPost,
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
    public func getAllPosts(
        completion: @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func getPostsForUser(
        user: User,
        completion: @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
}
