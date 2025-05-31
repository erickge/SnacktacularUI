//
//  PhotoView.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/22/25.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot
    @State private var photo = Photo()
    @State private var data = Data() //We need to take image & convert it to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented: Bool = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("description", text: $photo.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
                            dismiss()
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image 
                            }
                            // Get raw data from image so we can save it
                            guard let transferredData = try? await
                                    selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("😡 ERROR: Could not create Data from selectedPhoto")
                                
                                return
                            }
                            data = transferredData
                            
                            
                        } catch {
                            print ("😡 ERROR: Could not create Image from selectedPhoto \(error.localizedDescription)")
                        }
                    }
                    
                }
                                  
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot())
}
