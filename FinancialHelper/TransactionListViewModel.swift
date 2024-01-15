//
//  TransactionListViewModel.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//

import Foundation
import SwiftUI
import Combine
import Collections
import CoreData


typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    var transactions: [Transaction] = []
    
    @AppStorage("TRANSACTION_STORAGE") var storedTransaction = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    func getTransactions() {
        var geturl: String
        if storedTransaction.isEmpty {
            geturl = "https://raw.githubusercontent.com/ngcothu/datasets/main/transactions.json"
        
        guard let url = URL(string: geturl) else {
            loadFromPersistingData()
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                self.storedTransaction = String(decoding: data, as: UTF8.self)
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.loadFromPersistingData()
                    print("Error fetching transaction: ", error.localizedDescription)
                case .finished:
                    print("Finished fetching transaction")
                }
                
            } receiveValue: { [weak self] result in
                self?.transactions = result
                dump(self?.transactions)
            }
            .store(in: &cancellables)
        }
        else
        {
            self.loadFromPersistingData()
        }
            
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {return [:]}
        
        let groupedTransactions = TransactionGroup(grouping: transactions) {$0.month}
        
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum{
        print("accumulateTransactions")
        guard !transactions.isEmpty else {return [] }
        
        let today = "1/7/2024".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24){
            let dailyExpanses = transactions.filter{ $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpanses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum)
            
        }
        return cumulativeSum
        
    }
    
    func addTransaction(transa: Transaction) {
        self.transactions.append(transa)
    }
    
    func saveToPersistingData() {
        do {
            let jsonData = try JSONEncoder().encode(transactions)
            let jsonString = String(data: jsonData, encoding: .utf8)

            storedTransaction = jsonString ?? ""
            
        } catch {
            print("Failed to save transactions: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistingData() {
        do {
            let jsonDataString = storedTransaction
            let jsonData = jsonDataString.data(using: .utf8)
            transactions = try JSONDecoder().decode([Transaction].self, from: jsonData!)
        } catch {
            
        }
    }
}
