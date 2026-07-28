//
//  SettingsScreen.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import SwiftUI

struct SettingsScreen: View {
   
    @AppStorage(UserDefaultsKeys.appearanceTheme)
    private var appearanceTheme: AppearanceTheme = .system
    
    @AppStorage(UserDefaultsKeys.username)
    private var username: String = ""
    
    @AppStorage(UserDefaultsKeys.itemsPerPage)
    private var itemsPerPage: Int = 20
    
    @AppStorage(UserDefaultsKeys.notificationsEnabled)
    private var notificationsEnabled: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Appearance", selection: $appearanceTheme) {
                        ForEach(AppearanceTheme.allCases) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Overrides the system appearance to always use Light.")
                }
                
                Section("Account") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section("Preferences") {
                    Stepper("Items per page: \(itemsPerPage)", value: $itemsPerPage, in: 10...100, step: 5)
                    Toggle("Enable notifications", isOn: $notificationsEnabled)
                }
                
                Section {
                    Button(role: .destructive) {
                        resetDefaults()
                    } label: {
                        Text("Reset to Defaults")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func resetDefaults() {
        appearanceTheme = .system
        username = ""
        itemsPerPage = 20
        notificationsEnabled = true
    }
}

//MARK: - data model for appearance

enum AppearanceTheme: String, Identifiable, CaseIterable {
    case system
    case light
    case dark
    var id: Self { return self }
}

//MARK: - helper to save user defaults keys and keep them unique

enum UserDefaultsKeys {
    static let appearanceTheme = "appearanceTheme"
    static let username = "username"
    static let itemsPerPage = "itemsPerPage"
    static let notificationsEnabled = "notificationsEnabled"
}

//MARK: - helper to set saved theme

extension View {
    func setAppearanceTheme() -> some View {
        modifier(AppearanceThemeViewModifier())
    }
}


struct AppearanceThemeViewModifier: ViewModifier {
    
    @AppStorage(UserDefaultsKeys.appearanceTheme) private var appearanceTheme: AppearanceTheme = .system
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(scheme())
    }
    
    func scheme() -> ColorScheme? {
        switch appearanceTheme {
            case .dark: return .dark
            case .light: return .light
            case .system: return nil
        }
    }
}

//MARK: - Preview

#Preview {
    NavigationStack {
        SettingsScreen()
    }
}
