
import SwiftUI
import Introspect

struct SettingsView: View {
    @State var nc: UINavigationController?
    @State var sound = UserSavingsService.shared.sound {
        didSet {
            UserSavingsService.shared.sound = sound
        }
    }
    @State var music = UserSavingsService.shared.music {
        didSet {
            UserSavingsService.shared.music = music
        }
    }
    @State var vibrations = UserSavingsService.shared.vibrations {
        didSet {
            UserSavingsService.shared.vibrations = vibrations
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        Text("Sound")
                            .font(.custom("JejuHallasan", size: 24))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.horizontal)
                        Button {
                            sound.toggle()
                            SoundPlayer.shared.playClick()
                            ImpactFeedback.shared.makeImpackFeedback(.medium)
                        } label: {
                            ZStack {
                                Image(sound ? "off" : "on")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 1)
                                    .offset(x: sound ? -10 : 10)
                            }
                            .background {
                                Image("bg-picker")
                                    .resizable()
                                    .frame(width: 50, height: 30)
                            }
                        }
                    }
                    VStack {
                        Text("Music")
                            .font(.custom("JejuHallasan", size: 24))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.horizontal)
                        Button {
                            music.toggle()
                            SoundPlayer.shared.playClick()
                            ImpactFeedback.shared.makeImpackFeedback(.medium)
                            SoundPlayer.shared.playBackgroundMusic()
                        } label: {
                            ZStack {
                                Image(music ? "off" : "on")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 1)
                                    .offset(x: music ? -10 : 10)
                            }
                            .background {
                                Image("bg-picker")
                                    .resizable()
                                    .frame(width: 50, height: 30)
                            }
                        }
                    }
                    VStack {
                        Text("Vibrations")
                            .font(.custom("JejuHallasan", size: 24))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.horizontal)
                        Button {
                            vibrations.toggle()
                            SoundPlayer.shared.playClick()
                            ImpactFeedback.shared.makeImpackFeedback(.medium)
                        } label: {
                            ZStack {
                                Image(vibrations ? "off" : "on")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 1)
                                    .offset(x: vibrations ? -10 : 10)
                            }
                            .background {
                                Image("bg-picker")
                                    .resizable()
                                    .frame(width: 50, height: 30)
                            }
                        }
                    }
                }
                Button {
                    guard let url = URL(string: "https://astonishing-forger-248.notion.site/Privacy-Policy-30d3167e696e49f49122ae984609171e?pvs=4") else { return }
                    UIApplication.shared.open(url)
                    SoundPlayer.shared.playClick()
                    ImpactFeedback.shared.makeImpackFeedback(.medium)
                } label: {
                    Text("privacy policy".uppercased())
                        .foregroundColor(.white)
                        .underline()
                        .font(.custom("JejuHallasan", size: 18))
                }
                .padding(.top, 30)
            }
            .frame(width: 400, height: 200)
            .background {
                Image("bg-stack")
                    .resizable()
            }
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
        .overlay(alignment: .top) {
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
            }
            .padding()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
