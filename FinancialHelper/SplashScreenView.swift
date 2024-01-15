//
//  SplashScreenView.swift
//  FinancialHelper
//
//  Created by Tomáš Jahoda on 15.01.2024.
//

import SwiftUI

struct SplashScreenView: View {
    @ObservedObject public var transactionListVM: TransactionListViewModel
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isActive{
            ContentView(transactionListVM: transactionListVM)
                    .environmentObject(transactionListVM)
        } else {
            VStack{
                VStack{
                    Image("piggybank")
                        .resizable()
                        .frame(width: 300, height:  300)
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                    Text("Financial Helper")
                        .font(Font.custom("Baskerville-Bold",
                                          size:26))
                        .foregroundColor(.black.opacity(80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
        
        
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(transactionListVM: TransactionListViewModel())
    }
}
