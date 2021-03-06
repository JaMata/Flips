//
//  FlipsCoreDataModel.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import Foundation
import SwiftUI
import CoreData

struct FlipsCoreDataModel: FlipsModel {
	var users: [User] { return [] }
	var flips: [Flip] { return [] }
	var ratings: [Rating] { return [] }
	var feedbacks: [Feedback] { return [] }

	static var context = PersistenceController.shared.container.viewContext
	let flipsTestData = FlipsDataModelTestData()
	
	//Populating/Clearing methods
	func emptyDB() {
		
		let userFetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
		let userDeleteRequest = NSBatchDeleteRequest(fetchRequest: userFetchRequest)
		
		let flipFetchRequest: NSFetchRequest<NSFetchRequestResult> = FlipEntity.fetchRequest()
		let flipDeleteRequest = NSBatchDeleteRequest(fetchRequest: flipFetchRequest)
		
		let ratingFetchRequest: NSFetchRequest<NSFetchRequestResult> = RatingEntity.fetchRequest()
		let ratingDeleteRequest = NSBatchDeleteRequest(fetchRequest: ratingFetchRequest)
		
		let feedbackFetchRequest: NSFetchRequest<NSFetchRequestResult> = FeedbackEntity.fetchRequest()
		let feedbackDeleteRequest = NSBatchDeleteRequest(fetchRequest: feedbackFetchRequest)

		do {
			try FlipsCoreDataModel.context.execute(userDeleteRequest)
			try FlipsCoreDataModel.context.execute(flipDeleteRequest)
			try FlipsCoreDataModel.context.execute(ratingDeleteRequest)
			try FlipsCoreDataModel.context.execute(feedbackDeleteRequest)
		} catch let error as NSError {
			print("error during deletion \(error.localizedDescription)")
		}
		
	}
	
	func loadAllDatabaseData(isLoaded: Binding<Bool>) {
		
		emptyDB()
		
		FlipsCoreDataModel.context.performAndWait({
			
			loadUserDatasetFromJSON()
			loadFlipDatasetFromJSON()
			loadFeedbackDatasetFromJSON()
			
		})
		
		// Assign Users to Flips and Generate Random Flip Ratings
		assignUsersToFlips(completion: { (success) -> Void in
			if success {
				generateRatings(count: 30, completion: { (success) -> Void in
					if success {
						print("setting isLoaded to true!\n\n")
						isLoaded.wrappedValue.toggle()
						
					} else { print("Error during generation of Ratings. Stuck at Loading Screen!")}
				})
			} else { print("Error during User-Flip Entity Assignment. Stuck at Loading Screen!") }
		})
		
	}
	
	func loadUserDatasetFromJSON() {
			
		guard let users = flipsTestData.users else {
			return print("Error loading users: \(flipsTestData)")
		}
		
		users.forEach({ user in _ = user.convertToManagedObject() })
		
		do {
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Error saving user to core data \(error.localizedDescription)")
		}
	}
		
	func loadFlipDatasetFromJSON() {
		
		guard let flips = flipsTestData.flips else {
			return print("Error loading flips")
		}
		
		flips.forEach({ flip in _ = flip.convertToManagedObject() })
		
		do {
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Error saving flip to core data \(error)")
		}
	}
		
	func loadFeedbackDatasetFromJSON() {
		
		guard let feedbacks = flipsTestData.feedbacks else {
			return print("Error loading feedbacks")
		}
		feedbacks.forEach({ feedback in _ = feedback.convertToManagedObject() })
		
		do {
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Error saving feedback to core data \(error)")
		}
		
	}
	
	
	/// Returns a `UserEntity` for a given `username`
	static func getUserWith(username: String) -> UserEntity? {
		let request = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserByUsername", substitutionVariables: ["username" : username])
		
		do {
			let user = try FlipsCoreDataModel.context.fetch(request!).first as! UserEntity
			return user
		} catch {
			print("User fetch failed")
			return nil
		}
	}
	
	/// Returns a `User` for a given `username`
	static func getUser(username: String) -> User? {
		
		let tempData = FlipsDataModelTestData()
		
		if let user = tempData.users!.first(where: { $0.username == username }) {
			return user;
		}
		
		return nil
	}
	
	/// Returns a `FlipEntity` for a given `uuid`
	static func getFlipWith(uuid: UUID) -> FlipEntity? {
		let request = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "FlipById", substitutionVariables: ["id" : uuid])
		
		do {
			let flip = try FlipsCoreDataModel.context.fetch(request!).first as! FlipEntity
			return flip
		} catch {
			print("Flip fetch failed")
			return nil
		}
	}
	
	/// Returns a `FlipEntity` for a given `uuid`
	static func getFlip(id: UUID) -> Flip? {
		
		let tempData = FlipsDataModelTestData()
		
		if let flip = tempData.flips!.first(where: { $0.id == id }) {
			return flip;
		}
		
		return nil
	}
	
	/// Returns a `RatingEntity` for a given `uuid`
	static func getRatingWith(uuid: UUID) -> RatingEntity? {
		let request = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "RatingById", substitutionVariables: ["id" : uuid])
		
		do {
			let rating = try FlipsCoreDataModel.context.fetch(request!).first as! RatingEntity
			return rating
		} catch {
			print("Rating fetch failed")
			return nil
		}
	}
	
	/// Returns a `FeedbackEntity` for a given `uuid`
	static func getFeedbackWith(uuid: UUID) -> FeedbackEntity? {
		let request = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "FeedbackById", substitutionVariables: ["id" : uuid])
		
		do {
			let feedback = try FlipsCoreDataModel.context.fetch(request!).first as! FeedbackEntity
			return feedback
		} catch {
			print("Feedback fetch failed")
			return nil
		}
	}
	
	/// Makes an relationship between the user that has the provided `uuid` and the flip that has the provided `uuid`
	func assign(user username: String, flip uuid: UUID) {
		let userRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserByUsername", substitutionVariables: ["username" : username])
		
		let flipRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "FlipById", substitutionVariables: ["id" : uuid])
		do {
			let user = try FlipsCoreDataModel.context.fetch(userRequest!).first as! UserEntity
			let flip = try FlipsCoreDataModel.context.fetch(flipRequest!).first as! FlipEntity
			
			// adds this flip to the user's "flips" array
			user.addToFlips(flip)
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Assignment of flip to user failed")
		}
	}
	
	/// Evenly assign Flips to Users
	/// User to Flip as Author:Flip Inverse
	func assignUsersToFlips(completion: (Bool) -> ()) {
		
		let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
		let flipRequest: NSFetchRequest<FlipEntity> = FlipEntity.fetchRequest()
		
		do {
			
			let users = try FlipsCoreDataModel.context.fetch(userRequest)
			let flips = try FlipsCoreDataModel.context.fetch(flipRequest)
			
			let usersCount: Int = users.count
			let flipsCount: Int = flips.count
			
			for i in 0..<flipsCount {
				
				let index: Int = i%usersCount
				let tempUser: UserEntity = users[index]
				let tempFlip: FlipEntity = flips[i]
				
				// adds this flip to the user's "flips" array
				tempUser.addToFlips(tempFlip)
				try FlipsCoreDataModel.context.save()
				
			}
			
		} catch {
			print("No-go, friend")
			return
		}
		
		completion(true)
	}
	
	
	/// Generate a random Rating and assign it to a random flip and random user
	/// Helps simulate the social aspect of Flips
	func generateRatings(count: Int16, completion: (Bool) -> ()) {
		
		for _ in 1...count {
			
			let userRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserEntity")
			if let userCount = try? FlipsCoreDataModel.context.count(for: userRequest) {
				userRequest.fetchOffset = Int.random(in: 0..<userCount)
			}
			
			let flipRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FlipEntity")
			if let flipCount = try? FlipsCoreDataModel.context.count(for: flipRequest) {
				flipRequest.fetchOffset = Int.random(in: 0..<flipCount)
			}
			
			userRequest.fetchLimit = 1
			flipRequest.fetchLimit = 1
			
			var randomUsers: [UserEntity]?
			var randomFlips: [FlipEntity]?
			
			FlipsCoreDataModel.context.performAndWait {
				randomUsers = try? userRequest.execute() as? [UserEntity]
				randomFlips = try? flipRequest.execute() as? [FlipEntity]
			}
			
			do {
				
				let randomUserEntity = randomUsers!.first!
				let randomFlipEntity = randomFlips!.first!
				
				let uniqueRatingRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "RatingByUserAndFlip", substitutionVariables: ["user" : randomUserEntity, "flip" : randomFlipEntity])
				let existingRatings = try FlipsCoreDataModel.context.fetch(uniqueRatingRequest!)
				if !existingRatings.isEmpty { print("Rating duplicated in generateRatings. Skipping."); continue }
				
				let newRating = Rating(score: Int16.random(in: 0...3))
				let newRatingEntity = newRating.convertToManagedObject()
				newRatingEntity.user = randomUserEntity
				newRatingEntity.flip = randomFlipEntity
				// adds this rating to the user's "ratings" array
				randomUserEntity.addToRatings(newRatingEntity)
				
				// adds this rating to the flip's "ratings" array
				randomFlipEntity.addToRatings(newRatingEntity)
				
				try FlipsCoreDataModel.context.save()
			} catch {
				print("Assignment of rating to user and flip failed")
			}
		}
		
		completion(true)
	}
}
