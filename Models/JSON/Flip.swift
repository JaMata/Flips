//
//  Flip.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Flip: Codable {
	
	let id: UUID
	let timestamp: Date
	let image: String
	let trick: Trick
	let imageDescription: String
	let latitude: Double
	let longitude: Double
	let author: User
	let ratings: [Rating]
	var score: Double {
		guard ratings.count > 0 else {return 0 }
		return ratings.reduce(0) { $0
			+ $1.score }/Double(ratings.count)
		}
	
	func convertToManagedObject() -> FlipEntity {
		
		let flipEntity = FlipEntity(context: PersistenceController.shared.container.viewContext)
		
		flipEntity.id = self.id
		flipEntity.timestamp = self.timestamp
		flipEntity.image = URL(fileURLWithPath: self.image)
		flipEntity.trick = self.trick.rawValue
		flipEntity.imageDescription = self.imageDescription
		flipEntity.latitude = self.latitude
		flipEntity.longitude = self.longitude
		flipEntity.author = FlipsCoreDataModel.getUserWith(uuid: self.author.id)
		flipEntity.ratings = NSSet()
		
		// loop over flips, and add separately
		for rating in self.ratings {
			let ratingEntity = FlipsCoreDataModel.getRatingWith(uuid: rating.id)
			ratingEntity.addToRatings(ratingEntity)
		}
		
		return flipEntity
	}
	
	init(flipEntity: FlipEntity) {
		
		self.id = flipEntity.id!
		self.timestamp = flipEntity.timestamp!
		self.image = flipEntity.image!.absoluteString
		self.trick = Trick(rawValue: flipEntity.trick!)!
		self.imageDescription = flipEntity.imageDescription!
		self.latitude = flipEntity.latitude
		self.longitude = flipEntity.longitude
		self.author = User(userEntity: flipEntity.author!)
		var tempRatings: [Rating] = []
		
		for ratingEn in flipEntity.ratings!.allObjects as! [RatingEntity] {
			
			let rating = Rating(rating: ratingEn)
			tempRatings.append(rating)
		}
		self.ratings = tempRatings
	}
}
