//
//  W5DataManagement.swift
//  BuildingInputForm
//
//  Created by Coding Bee Academy on 27/09/26.
//

import SwiftUI

struct W6SmartAppLogic: View {
    @State private var challengeName = ""
    @State private var challengeDescription = ""
    @State private var selectedPlatform = "Tiktok"
    @State private var confirmInformation = false
    @State private var informationAccepted = false
    @State private var selectedType = "Creative or Academic"
    @State private var selectedSoource = "Recognised Organisation"
    
    // Coding Task 1: Add the Saved-Assessment State
    @State private var savedAssessments: [String] = []
    
    // Coding Task 2: Add the Five Warning-Sign States
    @State private var involvesDanger = false
    @State private var involvesUnknownSubstance = false
    @State private var asksForPrivateInfo = false
    @State private var createsPressure = false
    @State private var reviewedByAdult = false
    
    // Coding Task 3: Add the result states
    @State private var resultLevel = "Waiting"
    
    
    private let platforms = ["Tiktok", "YouTube", "Instagram", "Friend or Group Chat", "Other"]
    private let challengeTypes  = ["Creative or Academic", "Physical Activity", "Food or Substance", "Online or Privacy", "Dangerous Environment", "Unknown"]
    private let sourceTypes = ["Recognised Organisation", "Teacher or Trusted Adult", "Friend or Classmate", "Online Content Crator", "Unknown Source"]
    private let challengeTypePoints: [String: Int] = ["Creative or Academic": 0, "Physical Activity": 2, "Food or Substance": 4, "Online or Privacy": 3, "Dangerous Environment": 5, "Unknown": 3]
    private let sourceTypePoints: [String: Int] = ["Recognised Organisation": 0, "Teacher or Trusted Adult": 0, "Friend or Classmate": 1, "Online Content Crator": 2, "Unknown Source": 3]
    
    private var cleanChallengeName: String {
        challengeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var cleanChallengeDescription: String {
        challengeDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isFormValid : Bool {
        cleanChallengeName.count >= 3 &&
        cleanChallengeDescription.count >= 10 &&
        confirmInformation
    }
    
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
    
    private var baseConcernPoints: Int {
        let challengeScore = challengeTypePoints[selectedType] ?? 0
        let sourceScore = sourceTypePoints[selectedSoource] ?? 0
        
        return challengeScore + sourceScore
    }
    
    // Coding Task 4: Add the complete concern score computed property
    private var totalConcernPoints: Int {
        var score = baseConcernPoints
        
        if involvesDanger {
            score += 5
        }
        
        if involvesUnknownSubstance {
            score += 5
        }
        
        if asksForPrivateInfo {
            score += 3
        }
        
        if createsPressure {
            score += 2
        }
        
        if !reviewedByAdult {
            score += 2
        }
        
        return score
    }
    
    // Coding Task 5-A: Add the Change Color Result CP
    private var resultColor: Color {
        switch resultLevel {
        case "Lower Concern":
            return .green
        case "Needs Adult Review":
            return .orange
        case "Avoid":
            return .red
        default:
            return .gray
        }
    }
    
    // Coding Task 5-B: Add the change SF Symbol Result CP
    private var resultSymbol: String {
        switch resultLevel {
        case "Lower Concern":
            return "checkmark.shield.fill"
        case "Needs Adult Review":
            return "exclamationmark.shield.fill"
        case "Avoid":
            return "exclamationmark.triangle.fill"
        default:
            return "hourglass"
            
        }
    }
    
    // Coding Task 5-C: Add the Change Message Result CP
    private var resultMessage: String {
        switch resultLevel {
        case "Lower Concern":
            return """
                Few warning signs were identified. Read the complete instructions and ask a trusted adult if you are uncertain.
            """
        case "Needs Adult Review":
            return """
                This challenge contains warning signs. Do not attempt it until a trusted adult has reviewed it.
            """
        case "Avoid":
            return """
                Serious warning signs were identified. Do not attempt or shere this challenge.
            """
        default:
            return """
                Complete the form and tap Assess Challenge to receive a result.
            """
            
        }
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Section("Initial Review") {
                    Label("Base concern points: \(baseConcernPoints)", systemImage: "chart.bar.fill")
                        .foregroundStyle(baseConcernPoints >= 5 ? Color.orange : Color.blue)
                    Text("The initial score is based on the challenge type and it's source.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Coding Task 6: Add the warning signs section
                Section("Warning Signs") {
                    Toggle("Involves fire, electricity, heights, traffic, or moving vehicles", isOn: $involvesDanger)
                    
                    Toggle("Involves eating, drinking, or applying an unknown substance", isOn: $involvesUnknownSubstance)
                    
                    Toggle("Asks for personal information", isOn: $asksForPrivateInfo)
                    
                    Toggle("Pressures people to act quickly", isOn: $createsPressure)
                    
                    Toggle("Reviewed by a trusted adult", isOn: $reviewedByAdult)
                }
                
                Section("Confirmation") {
                    Toggle(
                        "I entered the information honestly",
                        isOn: $confirmInformation
                    )
                    
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
                
                // Coding Task 8: Add the inline assessment result section
                Section("Assessment Result") {
                    VStack(alignment: .leading, spacing: 10) {
                        Label(resultLevel, systemImage: resultSymbol)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(resultColor)
                        Text(resultMessage)
                            .font(.body)
                        Label("Concern points: \(totalConcernPoints)", systemImage: "number.circle.fill")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 5)
                    
                    // Coding Task 11: Add the conditional result button
                    if resultLevel != "Waiting" {
                        Button {
                            saveAssesment()
                        } label: {
                            Label("Save Assesment", systemImage: "bookmark.fill")
                        }
                        
                        Button {
                            resetForm()
                        } label: {
                            Label("Assess Another Challenge", systemImage: "arrow.counterclockwise")
                        }
                        .foregroundStyle(.blue)
                        
                    }
                }
                
                // Coding Task 13: Add the saved Assessment Section
                Section("Saved Assessments") {
                    if savedAssessments.isEmpty {
                        Label("No assessments saved yet.", systemImage: "tray")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(savedAssessments, id: \.self) {
                            assessment in
                            Label(assessment, systemImage: "bookmark.fill")
                        }
                        .onDelete(perform: deleteAssessment)
                    }
                }
                
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
            .tint(.blue)
            // Coding Task 14: Add the edit Button Toolbar
            .toolbar {
                if !savedAssessments.isEmpty {
                    EditButton()
                }
            }
            
        }
    }
    
    // Coding Task 7: Complete Assess Challenge Function
    private func assessChallenge() {
        if involvesDanger || involvesUnknownSubstance {
            resultLevel = "Avoid"
        } else {
            switch totalConcernPoints {
            case 0...4:
                resultLevel = "Lower Concern"
            case 5...9:
                resultLevel = "Needs Adult Review"
            default:
                resultLevel = "Avoid"
            }
        }
        
    }
    
    // Coding Task 9: Add save function
    private func saveAssesment() {
        guard resultLevel != "Waiting" else {
            return
        }
        
        let newAssesment = "\(cleanChallengeName) - \(resultLevel)"
        
        if !savedAssessments.contains(newAssesment) {
            savedAssessments.append(newAssesment)
        }
    }
    
    // Coding Task 10: Add the reset Function
    private func resetForm() {
        challengeName = ""
        challengeDescription = ""
        selectedPlatform = "Tiktok"
        selectedType = "Creative or Academic"
        selectedSoource = "Recognised Organisation"
        involvesDanger = false
        involvesUnknownSubstance = false
        asksForPrivateInfo = false
        createsPressure = false
        reviewedByAdult = false
        confirmInformation = false
        resultLevel = "Waiting"
        
    }
    
    // Coding Task 12: Add the deletion function
    private func deleteAssessment(at offsets: IndexSet) {
        savedAssessments.remove(atOffsets: offsets)
    }
    
}




#Preview {
    W6SmartAppLogic()
}
