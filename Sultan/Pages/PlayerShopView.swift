import SwiftUI
import UIKit
import Introspect

struct PlayerShopView: View {
    @State var nc: UINavigationController?
    @State var money: Int = UserSavingsService.shared.money {
        didSet {
            UserSavingsService.shared.money = money
        }
    }
    
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
                VStack {
                    VStack {
                        Image("hpBottle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 60)
                    }
                    .padding()
                    .background {
                        Image("bg-shop-stack")
                            .resizable()
                            .padding(-20)
                            .padding(.bottom)
                    }
                    HStack(spacing: 0) {
                                Text("\((100).withAbbreviation)")
                                    .foregroundColor(.orange)
                                    .font(.custom("JejuHallasan", size: 24))
                                    .padding(.trailing, 4)
                        Image("coin")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .padding(.top)
                    Button {
                        
                    } label: {
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
                    .padding(.vertical)
                }
                .frame(width: 120)
                .padding()
                VStack {
                    VStack {
                        Image("build-1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 60)
                    }
                    .padding()
                    .background {
                        Image("bg-shop-stack")
                            .resizable()
                            .padding(-20)
                            .padding(.bottom)
                    }
                    HStack(spacing: 0) {
                                Text("\((150).withAbbreviation)")
                                    .foregroundColor(.orange)
                                    .font(.custom("JejuHallasan", size: 24))
                                    .padding(.trailing, 4)
                        Image("coin")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .padding(.top)
                    Button {
                        
                    } label: {
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
                    .padding(.vertical)
                }
                .frame(width: 120)
                .padding()
                VStack {
                    VStack {
                        Image("superspell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                    }
                    .padding()
                    .background {
                        Image("bg-shop-stack")
                            .resizable()
                            .padding(-20)
                            .padding(.bottom)
                    }
                    HStack(spacing: 0) {
                                Text("\((100).withAbbreviation)")
                                    .foregroundColor(.orange)
                                    .font(.custom("JejuHallasan", size: 24))
                                    .padding(.trailing, 4)
                        Image("coin")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .padding(.top)
                    Button {
                        
                    } label: {
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
                    .padding(.vertical)
                }
                .frame(width: 120)
                .padding()
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Image("bg-shop")
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

struct PlayerShopViewProvider: PreviewProvider {
    static var previews: some View {
        PlayerShopView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
