//
//  PreviewData.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//



import Foundation

var transactionPreviewData = Transaction(id: 1, date: "12/01/2024", institution: "CR", account: "Visa CR", merchant: "Apple", amount: 199, type: "debit", categoryId: 801, category: "Subscription", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)

