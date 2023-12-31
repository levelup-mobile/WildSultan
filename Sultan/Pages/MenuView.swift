//
//  MenuView.swift
//  CrounCasino
//
//  Created by Pfriedrix on 17.08.2023.
//

import SwiftUI

struct MenuView: View {
    @State var nc: UINavigationController?
    @State var canShowBonus = UserSavingsService.shared.canGetBonus
    
    @State var level = UserSavingsService.shared.level
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Text("LEVEL \(level)")
                    .foregroundColor(.white)
                    .font(.custom("JejuHallasan", size: 28))
                    .padding()
                Button {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "game")
                    nc?.pushViewController(vc, animated: true)
                    SoundPlayer.shared.playClick()
                    ImpactFeedback.shared.makeImpackFeedback(.medium)
                } label: {
                    Image("buttonPlay")
                        .resizable()
                        .frame(width: 200, height: 70)
                }
                .padding(.vertical, 8)
                Button {
                    let vc = UIHostingController(rootView: ShopView())
                    nc?.pushViewController(vc, animated: true)
                    SoundPlayer.shared.playClick()
                    ImpactFeedback.shared.makeImpackFeedback(.medium)
                } label: {
                    Image("buttonShop")
                        .resizable()
                        .frame(width: 200, height: 70)
                }
            }
            Spacer()
        }
        .introspectNavigationController { nc in
            DispatchQueue.main.async {
                self.nc = nc
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(minHeight: 0, maxHeight: .infinity)
        .background(
            Image("bg-menu")
                .resizable()
                .ignoresSafeArea()
        )
        .overlay(alignment: .topLeading) {
            VStack(spacing: 0) {
                Button {
                    let vc = UIHostingController(rootView: SettingsView())
                    nc?.pushViewController(vc, animated: true)
                    SoundPlayer.shared.playClick()
                    ImpactFeedback.shared.makeImpackFeedback(.medium)
                } label: {
                    Image("buttonSettings")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                if canShowBonus {
                    Button {
                        let vc = UIHostingController(rootView: BonusView(canGetBonus: $canShowBonus))
                        nc?.pushViewController(vc, animated: true)
                        SoundPlayer.shared.playClick()
                        ImpactFeedback.shared.makeImpackFeedback(.medium)
                    } label: {
                        Image("buttonGift")
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            canShowBonus = UserSavingsService.shared.canGetBonus
            level = UserSavingsService.shared.level
        }
        .navigationBarHidden(true)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
