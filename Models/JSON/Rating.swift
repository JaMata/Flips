//
//  Rating.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Rating: Codable {
	
	public var id: UUID = UUID()
	public var timestamp: Date = Date()
	let score: Int16
	let user: User
	let flip: Flip
	
	init(score: Int16, user: User, flip: Flip) {
		
		self.score = score
		self.user = user
		self.flip = flip
		
	}
	
	init(ratingEntity: RatingEntity) {
		
		self.id = ratingEntity.id!
		self.timestamp = ratingEntity.timestamp!
		self.score = ratingEntity.score
		self.flip = Flip(flipEntity: ratingEntity.flip!)
		self.user = User(userEntity: ratingEntity.user!)
		
	}
	
	func convertToManagedObject() -> RatingEntity {
		
		let ratingEntity = RatingEntity(context: PersistenceController.shared.container.viewContext)
		
		ratingEntity.id = self.id
		ratingEntity.timestamp = self.timestamp
		ratingEntity.score = self.score
		ratingEntity.flip = FlipsCoreDataModel.getFlipWith(uuid: self.flip.id)
		ratingEntity.user = FlipsCoreDataModel.getUserWith(uuid: self.user.id)
		
		return ratingEntity
	}
	
	
}
