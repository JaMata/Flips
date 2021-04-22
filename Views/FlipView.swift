//
//  FlipView.swift
//  Flips
//
//  Created by Jordan Foster on 4/21/21.
//

import SwiftUI

struct FlipView: View {
	
	@State private var rating: Double = 0
	@State private var isEditing = false
	let flip: FlipEntity
	
	var body: some View {
		
		VStack {
			ZStack {
				AsyncImage(
					url: flip.image!,
					placeholder: { Text("...") },
					image: { Image(uiImage: $0).resizable() }
				)
				.aspectRatio(contentMode: .fill)
				.frame(width: 350, height: 350)
				.clipped()
				Image(systemName: "star") // flip score
					.offset(x: 30, y: 60)
			}
			HStack {
				Text("\(flip.author!.username!)")
				Spacer()
				Slider(
					value: $rating,
					in: 0...4,
					step: 1,
					onEditingChanged: { editing in
						isEditing = editing
					},
					minimumValueLabel: Text("Lame"),
					maximumValueLabel: Text("Rad")
				) {
					Text("Flip Rating")
				}
			}
			Text("\(flip.description)")
				.padding()
				.border(Color.accentColor)
			HStack {
				Text("\(flip.latitude)")
				Spacer()
				Image(systemName: "dial.max") // Open Edit/Download Flip View
			}
			Spacer()
			
		}
	}
}

struct FlipView_Previews: PreviewProvider {
	static var previews: some View {
		FlipView(flip: FlipsDataModel.designModel.flips.first!.convertToManagedObject())
	}
}
