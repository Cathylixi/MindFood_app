//
//  ProfileViewModel.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/23.
//

import Foundation
import SQLite

struct UserModel {
    let id: Int
    let email: String
    let name: String
    let dateOfBirth: String
    let height: Float
    let weight: Float
    let gender: String
    let ethnicity: String
    let typicalDiet: String
    let bmrValue: Int
    let hasDiabetes: Bool
    let diabetesDiagnosis: String
    let takesMedication: Bool
    let physicalActivityLevel: String
    let otherHealthConcerns: String
    let specificGoals: String
    let foodAllergies: String?
    let dietaryPreferences: String?
    let bloodSugarGoals: String?
    let favoriteCuisines: String?
}

class ProfileViewModel: ObservableObject {
    @Published var user: UserModel?

    private var db: Connection?

    init() {
        connectToDatabase()
        fetchUserData()
    }

    func connectToDatabase() {
        do {
            if let path = Bundle.main.path(forResource: "test", ofType: "db") {
                db = try Connection(path, readonly: true)
            }
        } catch {
            print("Failed to connect to database: \(error)")
        }
    }

    func fetchUserData() {
        guard let db = db else { return }

        let users = Table("users")
        let id = Expression<Int>("id")
        let email = Expression<String>("email")
        let name = Expression<String>("name")
        let dob = Expression<String>("date_of_birth")
        let height = Expression<Double>("height")
        let weight = Expression<Double>("weight")
        let gender = Expression<String>("gender")
        let ethnicity = Expression<String>("ethnicity")
        let typicalDiet = Expression<String>("typical_diet")
        let bmrValue = Expression<Int>("bmr_value")
        let hasDiabetes = Expression<Bool>("has_diabetes")
        let diagnosis = Expression<String>("diabetes_diagnosis")
        let takesMedication = Expression<Bool>("takes_medication")
        let activityLevel = Expression<String>("physical_activity_level")
        let concerns = Expression<String>("other_health_concerns")
        let goals = Expression<String>("specific_goals")
        let foodAllergies = Expression<String?>("food_allergies")
        let dietaryPreferences = Expression<String?>("dietary_preferences")
        let bloodSugarGoals = Expression<String?>("blood_sugar_goals")
        let favoriteCuisines = Expression<String?>("favorite_cuisines")
        do {
            if let row = try db.pluck(users) {
                let user = UserModel(
                    id: row[id],
                    email: row[email],
                    name: row[name],
                    dateOfBirth: row[dob],
                    height: Float(row[height]),
                    weight: Float(row[weight]),
                    gender: row[gender],
                    ethnicity: row[ethnicity],
                    typicalDiet: row[typicalDiet],
                    bmrValue: row[bmrValue],
                    hasDiabetes: row[hasDiabetes],
                    diabetesDiagnosis: row[diagnosis],
                    takesMedication: row[takesMedication],
                    physicalActivityLevel: row[activityLevel],
                    otherHealthConcerns: row[concerns],
                    specificGoals: row[goals],
                    foodAllergies: row[foodAllergies],
                    dietaryPreferences: row[dietaryPreferences],
                    bloodSugarGoals: row[bloodSugarGoals],
                    favoriteCuisines: row[favoriteCuisines]
                )
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        } catch {
            print("Error reading user: \(error)")
        }
    }
}
