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
	let flipsTestData = FlipsModelTestData()
	
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
		
		loadUserDatasetFromJSON()
		loadFlipDatasetFromJSON()
		loadRatingDatasetFromJSON()
		loadFeedbackDatasetFromJSON()
		
		// link the objects to eachother ?
	}
	
	func loadUserDatasetFromJSON() {
			
		guard let users = flipsTestData.users else {
			return print("Error loading users")
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
	
	func loadRatingDatasetFromJSON() {
		
		guard let ratings = flipsTestData.ratings else {
			return print("Error loading ratings ")
		}
		
		ratings.forEach({ rating in _ = rating.convertToManagedObject() })
		
		do {
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Error saving rating to core data \(error)")
		}
	}
	
	func loadFeedbackDatasetFromJSON() {
		
		guard let feedbacks = flipsTestData.schoolClasses else {
			return print("Error loading feedbacks")
		}
		feedbacks.forEach({ feedback in _ = feedback.convertToManagedObject() })
		
		do {
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Error saving feedback to core data \(error)")
		}
		
	}
	
	
	/// Returns a `UserEntity` for a given `uuid`
	static func getUserWith(uuid: UUID) -> UserEntity? {
		let request = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserById", substitutionVariables: ["id" : uuid])
		
		do {
			let user = try FlipsCoreDataModel.context.fetch(request!).first as! UserEntity
			return user
		} catch {
			print("User fetch failed")
			return nil
		}
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
	static func getRatingWith(uuid: UUID) -> FeedbackEntity? {
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
	func assign(user uid: UUID, flip fid: UUID) {
		let userRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserById", substitutionVariables: ["id" : uid])
		
		let flipRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "FlipById", substitutionVariables: ["id" : fid])
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
	
	/// Makes an relationship between the user of `uuid`, the flip of `uuid`, and the rating of `uuid`
	func assign(user uid: UUID, flip fid: UUID, rating rid: UUID) {
		let userRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserById", substitutionVariables: ["id" : uid])
		
		let flipRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "FlipById", substitutionVariables: ["id" : fid])
		
		let ratingRequest = FlipsCoreDataModel.context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "RatingById", substitutionVariables: ["id" : rid])
		do {
			let user = try FlipsCoreDataModel.context.fetch(userRequest!).first as! UserEntity
			let flip = try FlipsCoreDataModel.context.fetch(request!).first as! FlipEntity
			
			// adds this flip to the user's "flips" array
			user.addToFlips(flip)
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Assignment of flip to user failed")
		}
	}
	
	func assign(student jhed: String, toCourseClass courseClassName: String)
	{
		let studentRequest: NSFetchRequest<StudentEntity> = StudentEntity.fetchRequest()
		studentRequest.predicate = NSPredicate(format: "jhed == %@", jhed)
		
		let courseClassRequest: NSFetchRequest<CourseClassEntity> = CourseClassEntity.fetchRequest()
		courseClassRequest.predicate = NSPredicate(format: "courseClassName == %@", courseClassName)
		do {
			let student = try FlipsCoreDataModel.context.fetch(studentRequest).first!
			let courseClass = try FlipsCoreDataModel.context.fetch(courseClassRequest).first!
			student.addToClasses(courseClass)
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Assignment of student to class failed")
		}
		
	}
	
	func assign(assignmentGrade: AssignmentGrade, toStudent jhed: String)
	{
		let studentRequest: NSFetchRequest<StudentEntity> = StudentEntity.fetchRequest()
		studentRequest.predicate = NSPredicate(format: "jhed == %@", jhed)
		
		let assignmentGradeEntity = assignmentGrade.convertToManagedObject()
		
		do {
			let student = try FlipsCoreDataModel.context.fetch(studentRequest).first!
			student.addToAssignmentGrades(assignmentGradeEntity)
			try FlipsCoreDataModel.context.save()
		} catch {
			print("Assignment of assignment to student failed")
		}
		
	}
}
