//
//  RatingView.swift
//  Flips
//
//  Created by Jordan Foster on 4/24/21.
//

import SwiftUI

struct RatingView: View {
	
	var ratings: NSSet?
	var score: Int = 0
	
	init(ratings: NSSet?) {
		
		self.ratings = ratings
		
		if (ratings != nil && ratings!.count > 0) {
			
			let tempRatings = ratings!.allObjects as! [RatingEntity]
			var sum: Int = 0
			for rating in tempRatings {
				sum += Int(rating.score)
			}
			
			self.score = Int(sum/tempRatings.count)
			// self.score = tempRatings.reduce(0) { $0 + $1.score }/Double(tempRatings.count)
			print("Calculated Score: \(self.score)")
		}
	}
	
	var body: some View {
		
		HStack {
			ForEach((0..<score), id: \.self) {
				Image(systemName: "star.fill")
					.accessibility(label: Text("Star \($0) filled"))
					.foregroundColor(.accentColor)
			}
			
			ForEach((score..<4), id: \.self) {
				Image(systemName: "star")
					.accessibility(label: Text("Star \($0) unfilled"))
					.foregroundColor(.accentColor)
			}
		}
	}
}

struct RatingView_Previews: PreviewProvider {
	static var previews: some View {
		RatingView(ratings: nil)
	}
}
