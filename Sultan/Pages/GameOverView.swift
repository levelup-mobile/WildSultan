

import SwiftUI
import Introspect

enum Winning {
    case first, second, draw
}

struct GameOverView: View {
    @State var nc: UINavigationController?
    @State var isWin: Winning
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                Text("GAME OVER")
                    .foregroundColor(.orange)
                    .font(.custom("JejuHallasan", size: 32))
                Spacer()
                if isWin == .draw {
                    Text("DRAW")
                        .foregroundColor(.gray)
                        .font(.custom("JejuHallasan", size: 28))
                        .bold()
                } else {
                    Text(isWin == .first ? "PLAYER 1 WIN": "PLAYER 1 WIN")
                        .foregroundColor(.gray)
                        .font(.custom("JejuHallasan", size: 22))
                        .bold()
                }
                Spacer()
                VStack {
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
                        .frame(width: 200, height: 70)
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
                        .frame(width: 200, height: 70)
                    }
                }
                Spacer()
            }
            .frame(width: 270, height: 290)
            .background {
                Color.white
                    .border(.gray, width: 4)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            Image("bg-gameOver").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().scaledToFill()
        )
        .introspectNavigationController { nc in
            self.nc = nc
        }
        .onAppear {
            if isWin != .draw {
                UserSavingsService.shared.money += Int.random(in: 25...50)
            }
        }
    }
}

struct GameOverPreview: PreviewProvider {
    static var previews: some View {
        GameOverView(isWin: .draw)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
