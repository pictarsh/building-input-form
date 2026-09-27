//
//  W5DataManagement.swift
//  BuildingInputForm
//
//  Created by Coding Bee Academy on 27/09/26.
//

import SwiftUI

struct W5DataManagement: View {
    @State private var challengeName = ""
    @State private var challengeDescription = ""
    @State private var selectedPlatform = "Tiktok"
    @State private var confirmInformation = false
    @State private var informationAccepted = false
    
    // Coding Task 1: Add the Collection-Selection states
    @State private var selectedType = "Creative or Academic"
    @State private var selectedSoource = "Recognised Organisation"
    
    
    // Coding Task 2: Create the Arrays
    private let platforms = ["Tiktok", "YouTube", "Instagram", "Friend or Group Chat", "Other"]
    private let challengeTypes  = ["Creative or Academic", "Physical Activity", "Food or Substance", "Online or Privacy", "Dangerous Environment", "Unknown"]
    private let sourceTypes = ["Recognised Organisation", "Teacher or Trusted Adult", "Friend or Classmate", "Online Content Crator", "Unknown Source"]
    
    
    // Coding Task 4: Add the Dictionaries
    // Dictionaries are collections that store related data as Key-Value pairs.
    private let challengeTypePoints: [String: Int] = ["Creative or Academic": 0, "Physical Activity": 2, "Food or Substance": 4, "Online or Privacy": 3, "Dangerous Environment": 5, "Unknown": 3]
    private let sourceTypePoints: [String: Int] = ["Recognised Organisation": 0, "Teacher or Trusted Adult": 0, "Friend or Classmate": 1, "Online Content Crator": 2, "Unknown Source": 3]
    
    // Coding Task 5: Clean the Two Text Inputs
    private var cleanChallengeName: String {
        challengeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var cleanChallengeDescription: String {
        challengeDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Coding Task 6: Clean and validate the text
    // replace the old isFormValid with
    private var isFormValid : Bool {
        cleanChallengeName.count >= 3 &&
        cleanChallengeDescription.count >= 10 &&
        confirmInformation
    }
    
    // Coding Task 7: Add a validation message
    private var validationMessage: String {
        if cleanChallengeName.count < 3 {
            return "Enter a challenge name with at least 3 characters."
        }
        
        if cleanChallengeDescription.count < 10 {
            return "Describe the challenge using at least 10 characters."
        }
        
        if !confirmInformation {
            return "Confirm that the information is accurate."
        }
        
        return "The challenge is ready for assesment."
    }
    
    // Coding Task 8: Calculate the base concern points
    private var baseConcernPoints: Int {
        let challengeScore = challengeTypePoints[selectedType] ?? 0
        let sourceScore = sourceTypePoints[selectedSoource] ?? 0
        
        return challengeScore + sourceScore
    }
    

    
    var body: some View {
        NavigationStack {
            Form {
                // First Section
                Section("Challenge Information") {
                    TextField(
                        "Challenge name",
                        text: $challengeName
                    )
                    
                    TextField(
                        "Briefly describe the challenge",
                        text: $challengeDescription
                    )
                    Picker(
                        "Where did you find it?",
                        selection: $selectedPlatform
                    ) {
                        // Coding Task 3: Replace the platform Picker Options
                        ForEach(platforms, id: \.self) {
                            platform in
                            Text(platform)
                                .tag(platform)
                        }
                        
                    }
                }
                
                // Coding Task 9: Add the Challenge Classification Section
                Section("Challenge Classification") {
                    Picker("Challenge Type", selection: $selectedType) {
                        ForEach(challengeTypes, id: \.self) {
                            type in
                            Text(type)
                                .tag(type)
                        }
                    }
                    
                    Picker("Who shared it", selection: $selectedSoource) {
                        ForEach(sourceTypes, id: \.self) {
                            type in
                            Text(type)
                                .tag(type)
                        }
                    }
                }
                
                // Coding Task 10: Add the Initial Review Section
                Section("Initial Review") {
                    Label("Base concern points: \(baseConcernPoints)", systemImage: "chart.bar.fill")
                        .foregroundStyle(baseConcernPoints >= 5 ? Color.orange : Color.blue)
                    Text("The initial score is based on the challenge type and it's source.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Second Section
                Section("Confirmation") {
                    Toggle(
                        "I entered the information honestly",
                        isOn: $confirmInformation
                    )
                    
                    // Coding Task 11: Replace the week 4 Confirmation and Button Section
                    Button {
                        assessChallenge()
                    } label: {
                        Label (
                            "Access Challenge",
                            systemImage: "shield.lefthalf.filled"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                    
                    Text(validationMessage)
                        .font(.caption)
                        .foregroundStyle(isFormValid ? Color.green: Color.orange)
                }
                
                // Coding Task 12: Add the Importan Reminder Section
                Section("Important Reminder") {
                    Label(
                        """
                        This app provides a basic classroom assessment. It does not guarantee that a challenge is safe
                        """,
                        systemImage: "info.circle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Challenge Check")
            
        }
    }
    
    // Coding Task 13: Declare the Assessment Function
    private func assessChallenge() {
        
    }
    
}




#Preview {
    W5DataManagement()
}
