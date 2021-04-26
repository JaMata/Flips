//
//  FlipView.swift
//  Flips
//
//  Created by Jordan Foster on 4/21/21.
//

import SwiftUI
import CoreLocation

struct FlipView: View {
	
	@State private var geolocation: String = ""
	@State private var rating: Double = 0
	@State private var isEditing = false
	let flip: FlipEntity
	
	var body: some View {
		
		ScrollView {
			VStack {
				HStack {
					Text("\(flip.trick!) by ")
						.padding(.leading)
					Text("\(flip.author!.username!)")
						.italic()
						.foregroundColor(.accentColor)
						.onAppear { computeGeolocation() }
					Spacer()
				}
				
				if !geolocation.isEmpty {
					HStack {
						Label("\(geolocation)", systemImage: "location.fill")
							.padding(.leading)
							.onAppear { computeGeolocation() }
						Spacer()
					}
				}
				
				
				ZStack {
					AsyncImage(
						url: flip.image!,
						placeholder: { Text("...") },
						image: { Image(uiImage: $0).resizable() }
					)
					.aspectRatio(contentMode: .fill)
					.frame(width: 350, height: 350)
					.clipped()
					
					RatingView(ratings: flip.ratings)
						.offset(x: 90, y: 160)
				}
				
				HStack {
					Spacer()
					Slider(
						value: $rating,
						in: 0...4,
						step: 1,
						onEditingChanged: { editing in
							isEditing = editing
						},
						minimumValueLabel: Image(systemName: "star"),
						maximumValueLabel: Image(systemName: "star.fill")
					) {
						Text("Flip Rating")
					}
					Spacer()
				}
				
				Text("\(String(format: "%.0f", rating))")
					.foregroundColor(isEditing ? .pink : .accentColor)
				
				Spacer()
				
				HStack {
					Text("Flip Description:")
						.padding(.leading)
					Spacer()
				}
				HStack(alignment: .top) {
					Text("\(flip.imageDescription ?? "")")
						.frame(maxWidth: .infinity, minHeight: 120)
						.border(Color.accentColor)
				}.padding()
				
				HStack {
					Spacer()
					Image(systemName: "dial.max") // Open Edit/Download Flip View
						.padding(.trailing)
				}
				
				Spacer()
				
			}
			
		}
	}
	
	func computeGeolocation() -> Void {
		
		let geocoder = CLGeocoder()
		let location: CLLocation = CLLocation(latitude: flip.latitude, longitude: flip.longitude)
		
		geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			if error == nil {
				
				let placemark = placemarks![0]
				let locality: String? = placemark.locality
				let adminArea: String? = placemark.administrativeArea
				
				if locality != nil && adminArea != nil {
					self.geolocation = "\(placemark.locality!), \(placemark.administrativeArea!)"
				}
			} else {
				print("Reverse Geocode Error: \(error!)")
			}
		})
	}
	
}

struct FlipView_Previews: PreviewProvider {
	static var previews: some View {
		FlipView(flip: FlipsDataModel.designModel.flips.first!.convertToManagedObject())
	}
}
