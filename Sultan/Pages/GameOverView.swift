

import SwiftUI
import Introspect

enum Winning {
    case win, lose
}

struct GameOverView: View {
    @State var nc: UINavigationController?
    @State var isWin: Winning
    @State var earnMoney = Int.random(in: 25...50)
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("GAME OVER")
                    .foregroundColor(.orange)
                    .font(.custom("JejuHallasan", size: 32))
                Text(isWin == .win ? "YOU WIN": "YOU LOSE")
                    .foregroundColor(.gray)
                    .font(.custom("JejuHallasan", size: 22))
                    .bold()
                HStack(spacing: 2) {
                    Text("YOU EARN:")
                        .foregroundColor(.white)
                        .font(.custom("JejuHallasan", size: 20))
                        .padding(.trailing)
                    Text(earnMoney.withAbbreviation)
                        .foregroundColor(.white)
                        .font(.custom("JejuHallasan", size: 20))
                    Image("coin")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.opacity(isWin == .win ? 1 : 0)
                .padding(.bottom)
            }
            .frame(width: 270, height: 150)
            .background {
               Image("bg-stack")
                    .resizable()
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Button {
                        nc?.popToRootViewController(animated: true)
                        SoundPlayer.shared.playClick()
                        ImpactFeedback.shared.makeImpackFeedback(.medium)
                    } label: {
                        ZStack {
                            Image("button")
                                .resizable()
                            Text("MENU")
                                .foregroundColor(.white)
                                .font(.custom("JejuHallasan", size: 22))
                                .padding(.bottom, 8)
                                .padding(.trailing, 10)
                        }
                        .frame(width: 100, height: 70)
                    }
                    Button {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "game") as! GameViewController
                        nc?.pushViewController(vc, animated: true)
                        SoundPlayer.shared.playClick()
                        ImpactFeedback.shared.makeImpackFeedback(.medium)
                    } label: {
                        ZStack {
                            Image("button")
                                .resizable()
                            Text("PLAY AGAIN")
                                .foregroundColor(.white)
                                .font(.custom("JejuHallasan", size: 22))
                                .padding(.bottom, 8)
                                .padding(.trailing, 10)
                        }
                        .frame(width: 100, height: 70)
                    }
                }
                .offset(y: 35)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            Image("bg-menu").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().scaledToFill()
        )
        .introspectNavigationController { nc in
            self.nc = nc
        }
        .onAppear {
            if isWin != .win {
                UserSavingsService.shared.money += earnMoney
                UserSavingsService.shared.level += 1
            }
        }
    }
}

struct GameOverPreview: PreviewProvider {
    static var previews: some View {
        GameOverView(isWin: .win)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
