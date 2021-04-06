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
	
	let username: String
	let name: String
	let email: String
	let profileImage: String
	let bio: String
	let city: String
	let state: String
	let flips: [Flip]?
	let ratings: [Rating]?
	let type: UserType
	
	init(username: String, name: String, email: String, profileImage: String? = "https://i.imgur.com/1jDaiew.jpg", bio: String? = "", city: String? = "", state: String? = "", flips: [Flip]? = [], ratings: [Rating]? = [], type: String? = "Standard") {
		
		self.username = username
		self.name = name
		self.email = email
		self.profileImage = profileImage!
		self.bio = bio!
		self.city = city!
		self.state = state!
		self.flips = flips!
		self.ratings = ratings!
		self.type = UserType(rawValue: type!)!
		
	}
	
	func convertToManagedObject() -> UserEntity {
		
		let userEntity = UserEntity(context: PersistenceController.shared.container.viewContext)
		
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
		for flip in self.flips! {
			let flipEntity = FlipsCoreDataModel.getFlipWith(uuid: flip.id)
			userEntity.addToFlips(flipEntity!)
		}
		
		// loop over ratings, and add separately
		for rating in self.ratings! {
			let ratingEntity = FlipsCoreDataModel.getRatingWith(uuid: rating.id)
			userEntity.addToRatings(ratingEntity!)
		}
		
		return userEntity
	}
	
	init(userEntity: UserEntity) {
		
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
