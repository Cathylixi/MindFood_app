//
//  Logs.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import SwiftUI

struct LogsView: View {
    @State private var selectedFilter: String = "Today"

    var body: some View {
        PageWithTab(selectedTab: "Logs") {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("MIND FOOD")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#FF914D"))
                        Spacer()
                        Button(action: {
                            print("Add tapped")
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color(hex: "#FF914D"))
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(["Today", "Yesterday", "This Week", "Last Week", "Last Month", "Custom Range"], id: \.self) { label in
                                Button(action: {
                                    selectedFilter = label
                                    print("\(label) tapped")
                                }) {
                                    Text(label)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(label == selectedFilter ? Color(hex: "#FFBE98") : Color(.systemGray6))
                                        .foregroundColor(label == selectedFilter ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .font(.subheadline)
                    }
                    .padding(.vertical)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(Color(hex: "#FFBE98"))
                                    .background(Color(hex: "#FFF1E6"))
                                    .clipShape(Circle())
                                Text("Calories Remaining")
                                    .fontWeight(.semibold)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                Text("Today")
                            }
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }

                        HStack(alignment: .firstTextBaseline) {
                            Text("995")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(hex: "#FF914D"))
                            Text("You can still eat")
                                .foregroundColor(.gray)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("1,399")
                                    .fontWeight(.bold)
                                Text("kcal daily goal")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }

                        ProgressView(value: 995, total: 1399)
                            .accentColor(Color(hex: "#FFBE98"))

                        Divider()

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Macronutrients")
                                .font(.headline)

                            macroRow(name: "Protein", amount: "23/77 g", description: "Essential for muscle repair and growth", color: .teal, progress: 23.0/77.0)
                            macroRow(name: "Carbs", amount: "53/171 g", description: "Primary energy source for your body", color: .mint, progress: 53.0/171.0)
                            macroRow(name: "Fats", amount: "30/67 g", description: "Helps vitamin absorption", color: .orange, progress: 30.0/67.0)
                            macroRow(name: "Sugar", amount: "12/45 g", description: "Limit intake for better health", color: .brown, progress: 12.0/45.0)

                            Button("View Details") {
                                print("Tapped view details")
                            }
                            .foregroundColor(Color(hex: "#FF914D"))
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.1), radius: 5)
                    .padding()
                    
                    // Glucose Monitoring and Meal Section
                    Spacer(minLength: 20)
                    VStack {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Glucose Monitoring")
                                    .fontWeight(.semibold)
                                Spacer()
                                Button(action: {
                                    print("Add Reading tapped")
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus")
                                        Text("Add Reading")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(Color(hex: "#FF914D"))
                                }
                            }

                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 150)
                                Rectangle()
                                    .fill(Color(hex: "#FFBE98"))
                                    .frame(height: 4)
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 12)
                            }

                            HStack {
                                VStack {
                                    Text("5.6")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(hex: "#FF914D"))
                                    Text("Fasting")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Text("(mmol/L)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)

                                VStack {
                                    Text("6.8")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                    Text("Post-meal")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)

                                VStack {
                                    Text("6.2")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                    Text("Daily Avg")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.1), radius: 5)
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 32)
                    
                    HStack {
                        Text("Today's Meals")
                            .fontWeight(.semibold)
                        Spacer()
                        Button("Add Meal") {
                            print("Add Meal tapped")
                        }
                        .font(.footnote)
                        .foregroundColor(Color(hex: "#FF914D"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 0)

                    MealCard(
                            title: "Breakfast",
                            time: "8:30 AM",
                            calories: "450",
                            glucose: "6.2",
                            imageName: "avocado_toast_sample",
                            mealName: "Avocado Toast",
                            description: "2 slices whole grain bread, 1 avocado, 2 eggs"
                        )

                        MealCard(
                            title: "Lunch",
                            time: "12:45 PM",
                            calories: "680",
                            glucose: "7.1",
                            imageName: "quinoa_bowl_sample",
                            mealName: "Quinoa Bowl",
                            description: "Quinoa, grilled chicken, mixed vegetables"
                        )

                        MealCard(
                            title: "Dinner",
                            time: "7:15 PM",
                            calories: "720",
                            glucose: "6.8",
                            imageName: "salmon_sample",
                            mealName: "Salmon with Rice",
                            description: "Grilled salmon, brown rice, steamed broccoli"
                        )
                        .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.05)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }

    func macroRow(name: String, amount: String, description: String, color: Color, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(amount)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 6)
                    .foregroundColor(Color(.systemGray5))
                Capsule()
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.8, height: 6)
                    .foregroundColor(color)
            }

            Text(description)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    
}

struct MealCard: View {
    var title: String
    var time: String
    var calories: String
    var glucose: String
    var imageName: String
    var mealName: String
    var description: String

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(time)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack(spacing: 8) {
                    Text("\(calories) cal")
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())

                    Text("Glucose \(glucose)")
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                }
            }

            HStack(alignment: .top, spacing: 12) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(mealName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 5)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

struct PageWithTab<Content: View>: View {
    var selectedTab: String
    let content: Content

    init(selectedTab: String, @ViewBuilder content: () -> Content) {
        self.selectedTab = selectedTab
        self.content = content()
    }

    var body: some View {
        content
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
