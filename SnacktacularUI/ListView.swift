//
//  ListView.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/21/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Text("list items go here!")
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
                        //todo
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ListView()
}
