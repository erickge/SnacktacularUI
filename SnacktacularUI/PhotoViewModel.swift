//
//  PhotoViewModel.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/24/25.
//

import Foundation
import Firebase
import FirebaseAuth

import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    static func saveImage(spot:Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {
            print("😡 ERROR: Should never have been called without a vali spot.id")
            return
        }
        
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        //let photoName = UUID().uuidString
        
        
        metadata.contentType = "image/jpeg"
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageRef = storage.child(path)
            let returnedMedaData = try await storageRef.putDataAsync(data, metadata: metadata)
            print("😎 SAVED! \(returnedMedaData)")
            
            //get URL that we will use to load the image
            guard let url = try? await storageRef.downloadURL() else {
                print("😡 Error: Could not get download URL")
                return
                
            }
            photo.imageURLString = url.absoluteString
            print ("photo.imageURLString: \(photo.imageURLString)")
            
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("😡 ERROR Could no update data in spots/\(id)/\(photo.id ?? "n/a"): \(error.localizedDescription)")
                
            }
            
        } catch {
            print("😡 ERROR: saving photo to Storage: \(error.localizedDescription)")
            
        }
    }
}
