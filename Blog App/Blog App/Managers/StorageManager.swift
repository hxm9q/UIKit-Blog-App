//
//  StorageManager.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import Foundation
import FirebaseFirestore

final class StorageManager {
    
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private let storage = Firestore.firestore()
    
    // MARK: - Methods
    
    private init() {}
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let pngData = image?.pngData() else {
            completion(false)
            return
        }
        
        let base64String = pngData.base64EncodedString()
        let docId = sanitizeEmail(email)
        
        storage.collection("profile_pictures").document(docId).setData([
            "imageData": base64String
        ]) { error in
            completion(error == nil)
        }
    }
    
    public func downloadUrlForProfilePicture(
        email: String,
        completion: @escaping (URL?) -> Void
    ) {
        let docId = sanitizeEmail(email)
        
        storage.collection("profile_pictures").document(docId).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let base64String = data["imageData"] as? String,
                  let imageData = Data(base64Encoded: base64String) else {
                completion(nil)
                return
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent("\(docId).png")
            
            do {
                try imageData.write(to: fileURL)
                completion(fileURL)
            } catch {
                print("Failed to save image to temp file: \(error)")
                completion(nil)
            }
        }
    }
    
    public func uploadBlogHeaderImage(
        email: String,
        image: UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let imageData = compressImage(image, maxSizeKB: 500) else {
            completion(false)
            return
        }
        
        let base64String = imageData.base64EncodedString()
        
        let docId = "\(sanitizeEmail(email))_\(postId)"
        
        storage.collection("post_headers").document(docId).setData([
            "imageData": base64String,
            "email": email,
            "postId": postId,
            "timestamp": FieldValue.serverTimestamp()
        ]) { error in
            completion(error == nil)
        }
    }
    
    public func downloadUrlForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let docId = "\(sanitizeEmail(email))_\(postId)"
        
        storage.collection("post_headers").document(docId).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let base64String = data["imageData"] as? String,
                  let imageData = Data(base64Encoded: base64String) else {
                completion(nil)
                return
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent("\(docId).jpg")
            
            do {
                try imageData.write(to: fileURL)
                completion(fileURL)
            } catch {
                print("Failed to save image to temp file: \(error)")
                completion(nil)
            }
        }
    }
    
    private func sanitizeEmail(_ email: String) -> String {
        return email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }
    
    private func compressImage(_ image: UIImage, maxSizeKB: Int) -> Data? {
        var compression: CGFloat = 1.0
        guard var imageData = image.jpegData(compressionQuality: compression) else { return nil }
        
        while imageData.count > maxSizeKB * 1024 && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression) ?? Data()
        }
        return imageData
    }
    
    public func downloadProfileImage(email: String, completion: @escaping (UIImage?) -> Void) {
        downloadUrlForProfilePicture(email: email) { url in
            guard let url = url else {
                completion(nil)
                return
            }
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    completion(UIImage(data: data))
                } catch {
                    completion(nil)
                }
            }
        }
    }
}
