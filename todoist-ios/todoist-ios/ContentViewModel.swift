//
//  ContentViewModel.swift
//  todoist-ios
//
//  Created by nyuksoon.vong on 12/6/25.
//

import Foundation
import TodoistCore

extension ContentView {
    final class ViewModel: ObservableObject {
    
        @Published private(set) var isLoggedIn = false 
        @Published private(set) var tasks = [TaskEntityDTO]()
        
        func getAuthorizationURL() -> URL? {
            return AuthKoinHelper().getAuthorizationUrl()
        }
        
        @MainActor
        func getTasks() async throws {
            self.tasks = try await TaskKoinHelper().getAll()
            print(self.tasks)
        }
        
        func onTaskCreated(_ task: TaskEntityDTO) {
            self.tasks.append(task)
        }
        
        @MainActor
        func tryRestoreAccess() async throws {
            try await AuthKoinHelper().tryRestoreAccess()
            self.isLoggedIn = true 
        }
        
        @MainActor
        func authenticate(clientSecret: String, code: String) async throws {
            try await AuthKoinHelper().authenticate(
                clientSecret: clientSecret,
                code: code,
                redirectUrlPath: "com.example.todoist-ios://authorization"
            )
            self.isLoggedIn = true 
        }
        
        @MainActor
        func logout() async throws {
            try await AuthKoinHelper().logout()
            self.isLoggedIn = false
        }
    }
}
