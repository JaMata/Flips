//
//  Rating.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Rating: Codable {
	
	let id: UUID
	let timestamp: Date
	let score: Int16
	
	init(score: Int16) {
		
		self.id = UUID()
		self.timestamp = Date()
		self.score = score
		
	}
	
	init(ratingEntity: RatingEntity) {
		
		self.id = ratingEntity.id!
		self.timestamp = ratingEntity.timestamp!
		self.score = ratingEntity.score
		
	}
	
	func convertToManagedObject() -> RatingEntity {
		
		let ratingEntity = RatingEntity(context: PersistenceController.shared.container.viewContext)
		
		ratingEntity.id = self.id
		ratingEntity.timestamp = self.timestamp
		ratingEntity.score = self.score
		
		return ratingEntity
		
	}
}
