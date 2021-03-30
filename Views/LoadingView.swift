//
//  LoadingView.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import SwiftUI

struct LoadingView: View {
  
	@Binding private var networkDataLoaded: Bool
	
	init(networkDataLoaded: Binding<Bool>) {
		_networkDataLoaded = networkDataLoaded
		// let dataModel = ClassAssignmentsCoreDataModel()
		// dataModel.loadAllDatabaseData(isLoaded: networkDataLoaded)
	}
	
	var body: some View {
		VStack {
			ProgressView()
		}
	}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
			LoadingView(networkDataLoaded: .constant(false))
    }
}
