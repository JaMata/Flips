//
//  User.swift
//  Flips
//
//  Created by Jordan Foster on 3/27/21.
//

// TODO: Resolve the JSON load issue, probably by adding dummy id & timestamp for now
// TODO: Get FlipsView, CreateFlipView, and FeedbackView stubs
// TODO: Put the necessary notes in ppt for submission tonight.

import Foundation

struct User: Codable {
	public var id: UUID = UUID()
	public var timestamp: Date = Date()
	let username: String
	let name: String
	let email: String
	let profileImage: String
	let bio: String
	let city: String
	let state: String
	let flips: [Flip]
	let ratings: [Rating]
	let type: UserType
	
	func convertToManagedObject() -> UserEntity {
		
		let userEntity = UserEntity(context: PersistenceController.shared.container.viewContext)
		
		userEntity.id = self.id
		userEntity.timestamp = self.timestamp
		userEntity.username = self.username
		userEntity.name = self.name
		userEntity.email = self.email
		userEntity.profileImage = URL(fileURLWithPath: self.profileImage)
		userEntity.bio = self.bio
		userEntity.city = self.city
		userEntity.state = self.state
		userEntity.flips = NSSet()
		userEntity.ratings = NSSet()
		userEntity.type = self.type.rawValue

		// loop over flips, and add separately
		for flip in self.flips {
			let flipEntity = FlipsCoreDataModel.getFlipWith(uuid: flip.id)
			userEntity.addToFlips(flipEntity!)
		}
		
		// loop over ratings, and add separately
		for rating in self.ratings {
			let ratingEntity = FlipsCoreDataModel.getRatingWith(uuid: rating.id)
			userEntity.addToRatings(ratingEntity!)
		}
		
		return userEntity
	}
	
	init(userEntity: UserEntity) {
		
		self.id = userEntity.id!
		self.timestamp = userEntity.timestamp!
		self.username = userEntity.username!
		self.name = userEntity.name!
		self.email = userEntity.email!
		let tempProfileImage = userEntity.profileImage
		self.bio = userEntity.bio!
		self.city = userEntity.city!
		self.state = userEntity.state!
		self.type = UserType(rawValue: userEntity.type!)!
		var tempFlips: [Flip] = []
		var tempRatings: [Rating] = []
		
		if tempProfileImage != nil {
			self.profileImage = tempProfileImage!.absoluteString
		} else {
			self.profileImage = "https://i.imgur.com/1jDaiew.jpg"
		}
		
		for flipEn in userEntity.flips!.allObjects as! [FlipEntity] {
			
			let flip = Flip(flipEntity: flipEn)
			tempFlips.append(flip)
		}
		self.flips = tempFlips
		
		for ratingEn in userEntity.ratings!.allObjects as! [RatingEntity] {
			
			let rating = Rating(ratingEntity: ratingEn)
			tempRatings.append(rating)
		}
		self.ratings = tempRatings
	}
	
}
