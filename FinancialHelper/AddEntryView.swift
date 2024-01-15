//
//  AddEntryView.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//

import SwiftUI

struct AddEntryView: View {
    @State private var amount: String = ""
    @State private var selectedCategoryId: Int = Category.categories.first?.id ?? 0
    @State private var date = Date()
    @State private var merchant: String = ""
    @State private var institution: String = ""
    @State private var account: String = ""
    var addEntry: (Transaction) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $selectedCategoryId) {
                    ForEach(Category.all, id: \.id) { category in
                        Text(category.name).tag(category.id)
                    }
                }
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Merchant", text: $merchant)
                TextField("Institution", text: $institution)
                TextField("Account", text: $account)
            }
            .navigationBarTitle("Add Entry", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                if let amountValue = Double(amount) {
                    let category = Category.all.first { $0.id == selectedCategoryId }
                    let newTransaction = Transaction(
                        id: Int.random(in: 1...10000), // Generate a unique ID
                        date: date.formatted(.iso8601), // Format the date as a string
                        institution: institution,
                        account: account,
                        merchant: merchant,
                        amount: amountValue,
                        type: amountValue >= 0 ? TransactionType.credit.rawValue : TransactionType.debit.rawValue,
                        categoryId: selectedCategoryId,
                        category: category?.name ?? "Unknown",
                        isPending: false, // Set as per your requirement
                        isTransfer: false, // Set as per your requirement
                        isExpense: amountValue < 0,
                        isEdited: false // Set as per your requirement
                    )
                    addEntry(newTransaction)
                }
            })
        }
    }
}

