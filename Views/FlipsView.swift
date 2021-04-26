//
//  FlipsView.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import SwiftUI

struct FlipsView: View {
	
	var flips: [FlipEntity]
	var filter: String?
	
	init(flips: [FlipEntity], filter: String? = "flip") {
		
		self.filter = filter
		self.flips = flips.filter{ filter == "flip" || $0.trick! == filter }
		
	}
	
	var body: some View {
		
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					
					Text("\(flips.count) \(filter!)(s)!")
						.font(.title)
					ForEach(flips, id: \.id) { flip in
						NavigationLink(destination: FlipView(flip: flip)) {
							AsyncImage(
								url: flip.image!,
								placeholder: { Text("...") },
								image: { Image(uiImage: $0).resizable() }
							)
							.aspectRatio(contentMode: .fill)
							.frame(width: 300, height: 300)
							.clipped()
						}
					}
				}.frame(maxWidth: .infinity)
			}
		}
	}
}

struct FlipsView_Previews: PreviewProvider {
	static var previews: some View {
		FlipsView(flips: FlipsDataModel.designModel.flips.map{ $0.convertToManagedObject() })
	}
}
