import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loggedInUser: String = ""

    var body: some View {
        if isLoggedIn {
            // Ekran po zalogowaniu
            VStack {
                Text("Witaj, \(loggedInUser)!")
                    .font(.largeTitle)
                    .padding()
                Button(action: logout) {
                    Text("Wyloguj")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(10.0)
                }
            }
        } else {
            // Ekran logowania
            VStack {
                TextField("Username", text: $username)
                    .autocapitalization(.none) // Wyłącza dużą literę na początku
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Button(action: login) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }

                Text(message)
                    .padding()
                    .foregroundColor(.red)
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    func login() {
        guard let url = URL(string: "http://127.0.0.1:8000/login") else { return }

        let body: [String: String] = ["username": username, "password": password]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else { return }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.loggedInUser = username
                    self.isLoggedIn = true
                }
            } else {
                let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = decodedResponse as? [String: Any], let detail = json["detail"] as? String {
                    DispatchQueue.main.async {
                        self.message = detail
                    }
                }
            }
        }.resume()
    }

    func logout() {
        self.isLoggedIn = false
        self.username = ""
        self.password = ""
        self.message = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
