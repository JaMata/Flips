//
//  User.swift
//  Flips
//
//  Created by Jordan Foster on 3/27/21.
//

import Foundation

struct User: Codable {
	
	let username: String
	let name: String
	let email: String
	let profileImage: String
	let bio: String
	let city: String
	let state: String
	let type: UserType
	
	init(username: String, name: String, email: String, profileImage: String? = "https://i.imgur.com/1jDaiew.jpg", bio: String? = "", city: String? = "", state: String? = "", type: String? = "Standard") {
		
		self.username = username
		self.name = name
		self.email = email
		self.profileImage = profileImage!
		self.bio = bio!
		self.city = city!
		self.state = state!
		self.type = UserType(rawValue: type!)!
		
	}
	
	func convertToManagedObject() -> UserEntity {
		
		let userEntity = UserEntity(context: PersistenceController.shared.container.viewContext)
		
		userEntity.username = self.username
		userEntity.name = self.name
		userEntity.email = self.email
		userEntity.profileImage = URL(string: self.profileImage)
		userEntity.bio = self.bio
		userEntity.city = self.city
		userEntity.state = self.state
		userEntity.flips = NSSet()
		userEntity.ratings = NSSet()
		userEntity.type = self.type.rawValue
		
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
		
		if tempProfileImage != nil {
			self.profileImage = tempProfileImage!.absoluteString
		} else {
			self.profileImage = "https://i.imgur.com/1jDaiew.jpg"
		}
	}
	
}
