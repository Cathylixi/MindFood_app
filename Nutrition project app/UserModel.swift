//
//  UserModel.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/23.
//

import Foundation

struct EditableUserModel {
    var id: Int
    var email: String
    var name: String
    var dateOfBirth: String
    var height: Float
    var weight: Float
    var gender: String
    var ethnicity: String
    var typicalDiet: String
    var bmrValue: Int
    var hasDiabetes: Bool
    var diabetesDiagnosis: String
    var takesMedication: Bool
    var physicalActivityLevel: String
    var otherHealthConcerns: String
    var specificGoals: String
}
