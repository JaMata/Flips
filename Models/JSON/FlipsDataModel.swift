//
//  FlipsDataModel.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import Foundation

struct FlipsDataModel: FlipsModel {
	
	var users: [User]
	var flips: [Flip]
	// var ratings: [Rating]
	var feedbacks: [Feedback]
	
	static var designModel: FlipsDataModel = testModel
}

struct FlipsDataModelTestData {
	
	var users: [User]?
	var flips: [Flip]?
	// var ratings: [Rating]?
	var feedbacks: [Feedback]?
	
	init() {
		do {
			if let bundlePath = Bundle.main.path(forResource: "user", ofType: "json"),
				let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
				let decoder = JSONDecoder()
				users = try decoder.decode([User].self, from: jsonData)
			}
			
			if let bundlePath = Bundle.main.path(forResource: "flips", ofType: "json"),
				let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
					let decoder = JSONDecoder()
					flips = try decoder.decode([Flip].self, from: jsonData)
			}
			
			if let bundlePath = Bundle.main.path(forResource: "feedbacks", ofType: "json"),
				let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
				let decoder = JSONDecoder()
				feedbacks = try decoder.decode([Feedback].self, from: jsonData)
			}
			
		} catch {
			print("An error occurred during decoding: \(error)")
		}
		
	}
}
	
let testData = FlipsDataModelTestData()
let testModel = FlipsDataModel(users: testData.users!, flips: testData.flips!, feedbacks: testData.feedbacks!)

