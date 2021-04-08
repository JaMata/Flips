//
//  FlipsView.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import SwiftUI

struct FlipsView: View {
	
	var flips: [Flip]
	var filter: String?
	
	init(flips: [Flip], filter: String? = "*") {
		
		self.filter = filter
		self.flips = flips.filter{ filter == "*" || $0.trick.rawValue == filter }
		
	}
	
	var body: some View {
		
		ScrollView {
			VStack(alignment: .leading) {
				
				Text("\(flips.count) flip(s)!")
					.font(.title)
				ForEach(flips, id: \.id) { flip in
					
					AsyncImage(
						url: flip.image,
						placeholder: { Text("...") },
						image: { Image(uiImage: $0).resizable() }
					)
					.aspectRatio(contentMode: .fill)
					.frame(width: 300, height: 300)
					.clipped()
					
				}
			}.frame(maxWidth: .infinity)
		}
	}
}

struct FlipsView_Previews: PreviewProvider {
	static var previews: some View {
		FlipsView(flips: FlipsDataModel.designModel.flips)
	}
}
