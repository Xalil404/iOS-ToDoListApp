import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool // Binding to track when to hide the onboarding screens

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPageView(imageName: "1.circle", title: "Welcome", description: "Welcome to the To-Do List app!") // First screen
                    .tag(0)
                
                OnboardingPageView(imageName: "2.circle", title: "Organize", description: "Keep your tasks organized and get more done.") // Second screen
                    .tag(1)
                
                OnboardingPageView(imageName: "3.circle", title: "Get Started", description: "Create your first task and start being productive!") // Third screen
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle()) // Shows dots for page control

            Button(action: {
                if currentPage < 2 {
                    currentPage += 1
                } else {
                    showOnboarding = false // Dismiss onboarding
                }
            }) {
                Text(currentPage < 2 ? "Next" : "Get Started")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

struct OnboardingPageView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            Text(title)
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            Text(description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
    }
}

