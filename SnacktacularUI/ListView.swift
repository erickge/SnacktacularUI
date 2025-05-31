//
//  ListView.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/21/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot] // loads all "spots" documents into the array variable named spots !!
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(spots)  { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                                            
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        SpotViewModel.deleteSpot(spot: spot)
                    }
                }
                
            }
            .listStyle( .plain)
            .navigationTitle("Snack Spots:")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵 Sign Out Successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not Sign Out \(error.localizedDescription)")
                        }
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button  {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }
            }
        }
        
    }
}

#Preview {
    ListView()
}
