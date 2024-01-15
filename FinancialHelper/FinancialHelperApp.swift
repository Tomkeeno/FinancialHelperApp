//
//  FinancialHelperApp.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//

import SwiftUI

@main
struct FinancialHelperApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            SplashScreenView(transactionListVM: transactionListVM)
        }
    }
}
