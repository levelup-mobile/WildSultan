

import SwiftUI
import Introspect

struct BonusView: View {
    @State var money = Int.random(in: 20...100)
    @Binding var canGetBonus: Bool
    @State var nc: UINavigationController?
    @State var isOpenBonus = false
    
    var body: some View {
        VStack {
            Spacer()
            if canGetBonus {
                VStack {
                    Spacer()
                    Text("DAILY\nBONUS")
                        .font(.custom("JejuHallasan", size: 42))
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                    Spacer()
                    if isOpenBonus {
                        HStack(spacing: 0) {
                            Image("coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 35)
                                .padding(.bottom, 8)
                            Text("+\(money)")
                                .bold()
                                .foregroundColor(.orange)
                                .font(.custom("JejuHallasan", size: 42))
                        }
                        .padding(.horizontal)
                        Spacer()
                        Button {
                            UserSavingsService.shared.money += money
                            UserSavingsService.shared.lastTimeGetBonus = Date()
                            canGetBonus = false
                            SoundPlayer.shared.playClick()
                            ImpactFeedback.shared.makeImpackFeedback(.medium)
                            nc?.popViewController(animated: true)
                        } label: {
                            ZStack {
                                Image("button")
                                    .resizable()
                                    .frame(width: 200, height: 70)
                                Text("GET")
                                    .foregroundColor(.white)
                                    .font(.custom("JejuHallasan", size: 29))
                                    .padding(.bottom, 10)
                                    .padding(.trailing, 8)
                            }
                        }
                        .disabled(!canGetBonus)
                        .opacity(canGetBonus ? 1 : 0.5)
                    } else {
                        Image("gift")
                            .resizable()
                            .frame(width: 180, height: 180)
                        Spacer()
                        Text("TAP TO OPEN")
                            .foregroundColor(.white)
                            .font(.custom("JejuHallasan", size: 28))
                    }
                }
            }
            Spacer()
        }
        .onTapGesture {
            withAnimation {
                isOpenBonus = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            Image("bg-bonus").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().scaledToFill()
        )
        .introspectNavigationController { nc in
            DispatchQueue.main.async {
                self.nc = nc
            }
        }
    }
    
}

struct BonusPreview: PreviewProvider {
    static var previews: some View {
        BonusView(canGetBonus: .constant(true))
            .previewInterfaceOrientation(.landscapeLeft )
    }
}
