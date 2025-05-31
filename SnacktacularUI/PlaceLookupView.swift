//
//  PlaceLookupView.swift
//  LocationAndPlaceLookup
//
//  Created by Gary Erickson on 5/28/25.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    let locationManager: LocationManager
    @Binding var selectedPlace: Place?
    @State var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var searchRegion = MKCoordinateRegion()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView("No Results", systemImage: "mappin.slash")
                } else {
                    List(placeVM.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.title2)
                            Text(place.address)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            selectedPlace = place
                            dismiss()
                        }
                    }
                    .listStyle(.plain)
                }
                
            }
            
            
            .navigationTitle("loation Search")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            
        }
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        
        .onAppear {
            searchRegion = locationManager.getRegionAroundCurrentLocation() ?? MKCoordinateRegion()
        }
        
        .onDisappear() {
            searchTask?.cancel() // Cancel any outstanding tasks when view dismisses
        }
        
        .onChange(of: searchText) {oldValue, newValue in
            searchTask?.cancel()
            // if search string is empty, clear out the list
            guard !newValue.isEmpty else {
                placeVM.places.removeAll()
                return
            }
            //Create a new search task
            searchTask = Task {
                do {
                    // Wait 300 ms before running the current task
                    try await Task.sleep(for: .milliseconds(300))
                    // Check if task was called during sleep-- if so, return & wait for new Task to run
                    if Task.isCancelled { return }
                    // Verify search text hasn't changed during delay
                    if searchText == newValue {
                        try await placeVM.search(text: newValue, region: searchRegion
                        )
                    }
                    
                } catch {
                    if !Task.isCancelled {
                        print("😡 ERROR: \(error.localizedDescription)")
                        
                    }
                }
                
            }
        }
        
    }
    
    
}

#Preview {
    PlaceLookupView(locationManager: LocationManager(), selectedPlace: .constant(Place(mapItem: MKMapItem())))
}
