//
//  EditBirthdayView.swift
//  LiftLogSwift
//
//  Created by Luke CHEN on 2024-11-22.
//

import SwiftUI

struct EditBirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileModel
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            Spacer()
        }
        .padding(.horizontal)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

