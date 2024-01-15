//
//  TransactionList.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//

import SwiftUI

struct TransactionList: View {
    @ObservedObject var transactionListVM: TransactionListViewModel
    
    var body: some View {
        VStack{
            List{
                ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key){
                    month, transactions in
                    Section {
                        ForEach(transactions) {transactions in
                            TransactionRow(transaction: transactions)
                        }
                    } header: {
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)

                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


