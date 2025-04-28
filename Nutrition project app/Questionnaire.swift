import SwiftUI

struct QuestionnaireView: View {
    // States for input fields
    @State private var dateOfBirth = ""
    @State private var heightUnit: String = "cm"
    @State private var heightValue: Int = 160
    @State private var weight: Int = 50
    @State private var weightUnit: String = "kg"
    @State private var gender = ""
    @State private var ethnicity = ""
    
    @State private var typicalDiet = ""
    @State private var specificDiet = ""
    @State private var foodAllergies = ""
    @State private var mealsPerDay = ""
    @State private var cookingFrequency = ""
    @State private var favoriteCuisines = ""
    @State private var favoriteDish = ""
    @State private var hatedDish = ""

    @State private var bmrMeasured = "No"
    @State private var bmrValue = ""
    @State private var diagnosed = "No"
    @State private var diagnosisDetail = ""
    @State private var medications = "No"
    @State private var medicationList = ""
    @State private var customMedication = ""
    @State private var pregnancyStatus = "No"
    @State private var pregnancyWeek = ""
    @State private var physicalActivity = ""
    @State private var otherHealthConcerns = "No"
    @State private var myHealthConcern = ""
    @State private var supplements = "No"
    @State private var mySupplements = ""

    @State private var healthGoal = ""
    @State private var specificGoal = ""
    @State private var specificAllergy = ""

    @State private var selectedMonth = 1
    @State private var selectedDay = 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    //for progressView scrolling
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 1
    
    
    
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                Text("Health Questionnaire")
                    .font(.title2.bold())
                    .foregroundColor(Color(hex: "#2C3E50"))
                ProgressView(value: min(max(scrollOffset / contentHeight, 0), 1))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#FFBE98")))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .animation(.easeInOut(duration: 0.2), value: scrollOffset)
            }
            .padding(.top, 10)
            .padding(.horizontal)
            .background(Color.white)
            .zIndex(1)

            GeometryReader { outerGeo in
                ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Color.clear
                        .frame(height: 0)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                            }
                        )
                    Group {
                    sectionTitle("Basic Information")
                    Text("What is your date of birth?")
                        .foregroundColor(.gray)
                        .font(.body)
                    HStack(spacing: 12) {
                        Picker("Month", selection: $selectedMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text(Calendar.current.shortMonthSymbols[month - 1]).tag(month)
                            }
                        }
                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .fixedSize()

                        Picker("Day", selection: $selectedDay) {
                            ForEach(1...31, id: \.self) { day in
                                Text(String(format: "%02d", day)).tag(day)
                            }
                        }
                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .fixedSize()


                        Picker("Year", selection: $selectedYear) {
                            ForEach(1900...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .fixedSize()

                    }
                    Text("What is your height?")
                        .foregroundColor(.gray)
                        .font(.body)

                    HStack(spacing: 12) {
                        Picker("Unit", selection: $heightUnit) {
                            Text("cm").tag("cm")
                            Text("inch").tag("inch")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)

                        if heightUnit == "cm" {
                            Picker("Value", selection: $heightValue) {
                                ForEach(50...250, id: \.self) { value in
                                    Text("\(value) cm").tag(value)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                            .fixedSize()

                        } else {
                            Picker("Value", selection: $heightValue) {
                                ForEach(48...84, id: \.self) { totalInches in
                                    let feet = totalInches / 12
                                    let inches = totalInches % 12
                                    Text("\(feet)'\(inches)\"").tag(totalInches)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                            .fixedSize()

                        }
                    }
                    Text("What is your current weight?")
                        .foregroundColor(.gray)
                        .font(.body)

                    HStack(spacing: 12) {
                        Picker("Unit", selection: $weightUnit) {
                            Text("kg").tag("kg")
                            Text("lbs").tag("lbs")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)

                        if weightUnit == "kg" {
                            Picker("Weight", selection: $weight) {
                                ForEach(30...200, id: \.self) { value in
                                    Text("\(value) kg").tag(value)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                            .fixedSize()

                        } else {
                            Picker("Weight", selection: $weight) {
                                ForEach(66...440, id: \.self) { value in
                                    Text("\(value) lbs").tag(value)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                            .fixedSize()
                        }
                    }
                    Text("What is your gender?")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(["Male", "Female", "Non-binary", "Prefer not to say"], id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .fixedSize()
                        
                    
                    Text("What is your ethnicity?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Select your country", selection: $ethnicity) {
                    ForEach(Locale.Region.isoRegions.compactMap { Locale.current.localizedString(forRegionCode: $0.identifier) }.sorted(), id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .fixedSize()
                }

                Group {
                    sectionTitle("Dietary Habits")
                    Text("What is your typical diet?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Typical Diet", selection: $typicalDiet) {
                        Text("Strict Vegetarian: No meat, poultry, or fish, but includes eggs").tag("Strict Vegetarian")
                        Text("Vegetarian: No meat, poultry, or fish, but may include eggs, dairy, and other animal products").tag("Vegetarian")
                        Text("Pescatarian: Vegetarian with the addition of fish").tag("Pescatarian")
                        Text("Omnivorous: Eats a variety of foods, including meat, poultry, fish, and plant-based foods").tag("Omnivorous")
                        Text("Low-Carb: Restricts carbohydrate intake, focusing on proteins and fats").tag("Low-Carb")
                        Text("Gluten-Free: Avoids gluten-containing grains like wheat, barley, and rye").tag("Gluten-Free")
                        Text("Dairy-Free: Excludes dairy products like milk, cheese, and yogurt").tag("Dairy-Free")
                        Text("Keto: High-fat, low-carb diet to induce ketosis").tag("Keto")
                        Text("Paleo: Mimics the diet of our Paleolithic ancestors, focusing on meats, fish, fruits, and vegetables").tag("Paleo")
                        Text("None").tag("None")
                        Text("Other (please specify):").tag("Other")
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    
                    
                    if typicalDiet == "Other" {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Please specify your diet:")
                                .foregroundColor(.gray)
                                .font(.body)
                            TextField("Enter your diet", text: $specificDiet)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
                        }
                    }
                    
                    Text("Do you have any food allergies or intolerances?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Allergies", selection: $foodAllergies) {
                        Text("Peanuts").tag("Peanuts")
                        Text("Tree nuts (e.g., walnuts, almonds, hazelnuts)").tag("Tree nuts")
                        Text("Shellfish (e.g., shrimp, crab, lobster)").tag("Shellfish")
                        Text("Fish (e.g., tuna, salmon, cod)").tag("Fish")
                        Text("Soy").tag("Soy")
                        Text("Milk").tag("Milk")
                        Text("Eggs").tag("Eggs")
                        Text("Wheat").tag("Wheat")
                        Text("Gluten").tag("Gluten")
                        Text("Sesame seeds").tag("Sesame seeds")
                        Text("Other (please specify)").tag("Other")
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .fixedSize()
                    
                    if foodAllergies == "Other" {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Please specify your allergy:")
                                .foregroundColor(.gray)
                                .font(.body)
                            TextField("Enter your allergy", text: $specificAllergy)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
                        }
                    }
                    
                    inputField("How many meals do you usually eat per day?", text: $mealsPerDay)
                    inputField("How frequently do you prefer to cook at home?", text: $cookingFrequency)
                    Text("What types of cuisines do you enjoy the most?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Favorite Cuisines", selection: $favoriteCuisines) {
                        Text("Asian").tag("Asian")
                        Text("American").tag("American")
                        Text("Mexican").tag("Mexican")
                        Text("Indian").tag("Indian")
                        Text("French").tag("French")
                        Text("Greek").tag("Greek")
                        Text("Middle Eastern").tag("Middle Eastern")
                        Text("Spanish").tag("Spanish")
                        Text("Italian").tag("Italian")
                        Text("Other (please specify)").tag("Other")
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .fixedSize()

                    if favoriteCuisines == "Other" {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Please specify:")
                                .foregroundColor(.gray)
                                .font(.body)
                            TextField("Enter your cuisine", text: $favoriteDish)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
                        }
                    }
                    inputField("What is your favorite dish or type of food?", text: $favoriteDish)
                    inputField("What is your most hated dish or type of food?", text: $hatedDish)
                }

                Group {
                    sectionTitle("Health Status")
                    Text("Have you ever measured your Basal Metabolic Rate (BMR)?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("BMR Measured", selection: $bmrMeasured) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    if bmrMeasured == "Yes" {
                        inputField("If yes, what is your BMR?", text: $bmrValue)
                    }
                    Text("Have you been diagnosed with a condition related to blood sugar or diabetes?")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Picker("Diagnosed", selection: $diagnosed) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    
                    if diagnosed == "Yes" {
                        Text("If you're willing to share, what is your diagnosis?")
                            .foregroundColor(.gray)
                            .font(.body)
                        
                        Picker("Diagnosis", selection: $diagnosisDetail) {
                            Text("Pre-Diabetes").tag("Pre-Diabetes")
                            Text("Type 1 Diabetes").tag("Type 1 Diabetes")
                            Text("Type 2 Diabetes").tag("Type 2 Diabetes")
                            Text("Gestational diabetes mellitus").tag("Gestational diabetes mellitus")
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .fixedSize()
                    }
                    Text("Are you taking any medications or insulin to manage your blood sugar?")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Picker("Taking Medications", selection: $medications) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    
                    if medications == "Yes" {
                        Text("If you're on medications, could you list them and their dosages?")
                            .foregroundColor(.gray)
                            .font(.body)
                        Picker("Medication Options", selection: $medicationList) {
                            Text("Metformin").tag("Metformin")
                            Text("Glipizide").tag("Glipizide")
                            Text("Glyburide").tag("Glyburide")
                            Text("Liraglutide").tag("Liraglutide")
                            Text("Semaglutide").tag("Semaglutide")
                            Text("Dapagliflozin").tag("Dapagliflozin")
                            Text("Empagliflozin").tag("Empagliflozin")
                            Text("Insulin Glargine").tag("Insulin Glargine")
                            Text("Insulin Detemir").tag("Insulin Detemir")
                            Text("Insulin Lispro").tag("Insulin Lispro")
                            Text("Insulin Aspart").tag("Insulin Aspart")
                            Text("Other (please specify)").tag("Other")
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .fixedSize()
                        
                        if medicationList == "Other" {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Please specify:")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                TextField("Enter your medication", text: $customMedication)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
                            }
                        }
                    }
                    
                    
                    Text("Are you pregnant or breastfeeding?")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Picker("Pregnancy", selection: $pregnancyStatus) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    
                    if pregnancyStatus == "Yes" {
                        inputField("If yes, what week of pregnancy are you in?", text: $pregnancyWeek)
                        
                    }
                    
                    
                    
                    
                    Text("How would you describe your typical physical activity level?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Physical Activity", selection: $physicalActivity) {
                        Text("Sedentary").tag("Sedentary")
                        Text("Lightly active").tag("Lightly active")
                        Text("Moderately active").tag("Moderately active")
                        Text("Very active").tag("Very active")
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .fixedSize()
                    
                    Text("Do you have any other health concerns or special considerations we should be aware of?")
                        .foregroundColor(.gray)
                        .font(.body)

                    Picker("Other Health Concerns", selection: $otherHealthConcerns) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    if otherHealthConcerns == "Yes" {
                        inputField("If yes, please enter your health concerns", text: $myHealthConcern)
                        
                    }
                    
                    
                    Text("Are there other medications or supplements you are taking?")
                        .foregroundColor(.gray)
                        .font(.body)
                    Picker("Other medications or supplements", selection: $supplements) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                
                    if supplements == "Yes" {
                        inputField("If yes, please enter your medications or supplements", text: $mySupplements)
                        
                    }
                    
                    
                    
                   
                }

                Group {
                    sectionTitle("Health Goals")
                    Text("What are your primary health goals related to blood sugar management?")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.bottom, 6)
                        .multilineTextAlignment(.leading)
                    
                    VStack(alignment: .leading) {
                        Picker("Health Goal", selection: $healthGoal) {
                            Text("Achieve and maintain a target HbA1c level").tag("Achieve and maintain a target HbA1c level")
                            Text("Reduce the frequency of hyperglycemic or hypoglycemic episodes").tag("Reduce the frequency of hyperglycemic or hypoglycemic episodes")
                            Text("Improve overall blood sugar stability").tag("Improve overall blood sugar stability")
                            Text("Prevent or delay diabetes-related complications").tag("Prevent or delay diabetes-related complications")
                            Text("Lose weight").tag("Lose weight")
                            Text("Build muscle").tag("Build muscle")
                            Text("Build a healthier lifestyle").tag("Build a healthier lifestyle")
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4))
                        )
                    }
                    inputField("Describe your specific goals.", text: $specificGoal)
                }

                Button(action: { print("Continue tapped") }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#FFBE98")))
                }
                .padding(.top, 20)
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                contentHeight = geo.size.height
                            }
                    }
                )
                .padding(.horizontal, 32)
                .padding(.vertical, 80)
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
            }
        }
    }

    func inputField(_ question: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .foregroundColor(.gray)
                .font(.body)
            TextField("", text: text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
        }
    }

    func sectionTitle(_ title: String) -> some View {
    Text(title)
        .font(.title.bold())
        .padding(.top, 16)
}

struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 1
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

    func genderOptionButton(label: String) -> some View {
        Button(action: {
            gender = label
        }) {
            Text(label)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(gender == label ? Color(hex: "#FFBE98") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                        )
                )
                .foregroundColor(.black)
        }
    }
}


//for progressView scrolling
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}




struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
    }
}
