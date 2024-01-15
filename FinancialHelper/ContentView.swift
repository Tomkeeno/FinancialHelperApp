import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @ObservedObject var transactionListVM: TransactionListViewModel
    @State private var showingAddEntryView = false
  //  var demoData: [Double] = [3,2,4,6,12,9,2]
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 24) {
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    let data = transactionListVM.accumulateTransactions()
                    if !data.isEmpty{
                        let totalExpanses = data.last?.1 ?? 0
                        CardView {
                            VStack(alignment: .leading){
                                ChartLabel(totalExpanses.formatted(.currency(code: "CZK")),type: .title, format: "%.02f Kč")
                                
                                LineChart()
                            }
                            .background(Color.systemBackground)

                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                    .frame(height:300)
                        
                    }
                    
                    
                    RecentTransactionList(transactionListVM: transactionListVM)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEntryView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.palette)
                            .resizable()
                            .foregroundStyle(Color.icon, .primary)
                            .scaleEffect(2)
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showingAddEntryView) {
                AddEntryView { newTransaction in
                    // Process the new entry
                    //self.transactionListVM.transactions.append(newTransaction)
                    self.transactionListVM.addTransaction(transa: newTransaction)
                    self.transactionListVM.saveToPersistingData()
                    showingAddEntryView = false
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        ContentView(transactionListVM: transactionListVM)
            .environmentObject(transactionListVM)
    }
}
