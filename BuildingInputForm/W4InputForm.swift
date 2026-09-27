//
//  W4InputForm.swift
//  BuildingInputForm
//
//  Created by Coding Bee Academy on 27/09/26.
//

//
//  ContentView.swift
//  BuildingInputForm
//
//  Created by Coding Bee Academy on 07/09/26.
//

import SwiftUI

struct W4InputForm: View {
    @State private var challengeName = ""
    @State private var challengeDescription = ""
    @State private var selectedPlatform = "Tiktok"
    @State private var confirmInformation = false
    @State private var informationAccepted = false
    
    private var isFormValid : Bool {
        challengeName.count >= 3 &&
        challengeDescription.count >= 10 &&
        confirmInformation
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
                        Text("Tiktok")
                            .tag("Tiktok")
                        Text("YouTube")
                            .tag("YouTube")
                        Text("Instagram")
                            .tag("Instagram")
                        Text("Friend or Group Chat")
                            .tag("Friend or Group Chat")
                        Text("Other")
                            .tag("Other")
                        
                    }
                }
                
                // Second Section
                Section("Confirmation") {
                    Toggle(
                        "I entered the information honestly",
                        isOn: $confirmInformation
                    )
                    Label(
                        isFormValid
                        ? "Ready to continue."
                        : "Complete all required information.",
                        systemImage:
                            isFormValid
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                    )
                    .foregroundStyle(
                        isFormValid
                        ? Color.green
                        : Color.orange
                    )
                    .font(.caption)
                }
                
                // Final Section
                Section {
                    Button {
                        informationAccepted = true
                    } label: {
                        Label (
                            "Continue",
                            systemImage: "arrow.right.circle.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                    
                    if informationAccepted {
                        Label(
                            "Challenge information accepted",
                            systemImage: "checkmark.seal.fill"
                        )
                        .foregroundStyle(.green)
                        .font(.caption)
                    }
                }
            }
            .navigationTitle("Challenge Check")
            
        }
    }
}

#Preview {
    W4InputForm()
}
