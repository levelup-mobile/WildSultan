

import SwiftUI
import UIKit
import Introspect

struct ShopView: View {
    @State var nc: UINavigationController?
    @State var money: Int = UserSavingsService.shared.money {
        didSet {
            UserSavingsService.shared.money = money
        }
    }
    
    @State var item = UserSavingsService.shared.item {
        didSet {
            UserSavingsService.shared.item = item
        }
    }
    
    @State var hero1: Int = UserSavingsService.shared.hero {
        didSet {
            UserSavingsService.shared.hero = hero1
        }
    }
    
    @State var boughtItems = UserSavingsService.shared.boughtItems {
        didSet {
            UserSavingsService.shared.boughtItems = boughtItems
        }
    }
    
    @State var gate = UserSavingsService.shared.gate {
        didSet {
            UserSavingsService.shared.gate = gate
        }
    }
    
    @State var boughtGates = UserSavingsService.shared.boughtGates {
        didSet {
            UserSavingsService.shared.boughtGates = boughtGates
        }
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    nc?.popViewController(animated: true)
                    SoundPlayer.shared.playClick()
                    ImpactFeedback.shared.makeImpackFeedback(.medium)
                } label: {
                    Image("buttonBack")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Spacer()
                Text("SHOP")
                    .foregroundColor(.white)
                    .font(.custom("JejuHallasan", size: 38))
                Spacer()
                HStack(spacing: 0) {
                    Image("coin")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.bottom, 4)
                    Text("\(money.withAbbreviation)")
                        .font(.custom("JejuHallasan", size: 32))
                        .foregroundColor(.orange)
                        .bold()
                }
            }
            .padding()
            Spacer()
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(boughtItems.enumerated()), id: \.offset) { el, of in
                            VStack {
                                VStack {
                                    Image("hero-\(el+1)-1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .padding()
                                .background {
                                    Image("bg-shop-stack")
                                        .resizable()
                                }
                                HStack(spacing: 0) {
                                    Text("\((el*50).withAbbreviation)")
                                        .foregroundColor(.orange)
                                        .font(.custom("JejuHallasan", size: 16))
                                        .padding(.trailing, 4)
                                    Image("coin")
                                        .resizable()
                                        .frame(width: 13, height: 13)
                                }
                                .opacity(of ? 0 : 1)
                                Button {
                                    if of {
                                        hero1 = el+1
                                        SoundPlayer.shared.playClick()
                                        ImpactFeedback.shared.makeImpackFeedback(.medium)
                                    } else {
                                        guard money >= el*50 else { return }
                                        money -= el*50
                                        boughtItems[el] = true
                                        SoundPlayer.shared.playClick()
                                        ImpactFeedback.shared.makeImpackFeedback(.medium)
                                    }
                                } label: {
                                    if of {
                                        ZStack {
                                            Image("button")
                                                .resizable()
                                                .frame(height: 40)
                                            Text(hero1 == el+1 ? "SELECTED" : "SELECT")
                                                .foregroundColor(.white)
                                                .font(.custom("JejuHallasan", size: 16))
                                                .padding(.bottom, 6)
                                                .padding(.trailing, 8)
                                        }
                                    } else {
                                        ZStack {
                                            Image("button")
                                                .resizable()
                                                .frame(height: 40)
                                            Text("BUY")
                                                .foregroundColor(.white)
                                                .font(.custom("JejuHallasan", size: 16))
                                                .padding(.bottom, 6)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                    
                                }
                                .padding(.vertical)
                            }
                            .frame(width: 120)
                            .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Image("bg-menu")
                .resizable()
                .ignoresSafeArea()
        )
        .introspectNavigationController { nc in
            DispatchQueue.main.async {
                self.nc = nc
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
