//
//  HomeScreen.swift
//  DocLink
//
//  Created by Адам Мирзаканов on 14.11.2024.
//

import SwiftUI

struct HomeScreen: View {
  // MARK: Internal Properties
  var body: some View {
    NavigationStack {
      Picker("", selection: $selectedItem) {
        ForEach(DoctorSortCriterion.allCases) { category in
          Text(category.title).tag(category)
        }
      }
      .pickerStyle(.segmented)
      .padding([.leading, .trailing])
      
      List(filteredUsers) { user in
        VStack(alignment: .leading) {
          Text("\(user.firstName) \(user.lastName)")

        }
      }
      .searchable(text: $searchText, prompt: "Поиск")
      .navigationTitle("Главная")
      .onAppear {
        loadUsers()
      }
    }
  }
  
  // MARK: Private Properties
  @State private var searchText = ""
  @State private var selectedItem: DoctorSortCriterion = .price
  @State private var users: [User] = []
  
  private var filteredUsers: [User] {
    if searchText.isEmpty {
      return users
    } else {
      return users.filter {
        $0.firstName.contains(searchText) || $0.lastName.contains(searchText)
      }
    }
  }
  
  // MARK: Private Methods
  private func loadUsers() {
    if let response: APIResponse = decode(from: "UsersData", as: APIResponse.self) {
      users = response.record.data.users
    }
  }
}

// MARK: - DoctorSortCriterion
private enum DoctorSortCriterion: String, CaseIterable, Identifiable {
  case price
  case experience
  case rating
  
  var id: Self {
    self
  }
  
  var title: String {
    switch self {
    case .price:
      return "По цене"
    case .experience:
      return "По стажу"
    case .rating:
      return "По рейтингу"
    }
  }
}