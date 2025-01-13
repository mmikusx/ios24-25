import SwiftUI
import Combine

struct ContentView: View {
    @State private var name: String = ""
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    @State private var amount: String = ""
    @State private var message: String? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Payment Details")) {
                    TextField("Name", text: $name)
                            .textContentType(.name)
                            .autocapitalization(.words)

                    HStack {
                        Image(systemName: "creditcard")
                        TextField("Card Number", text: $cardNumber)
                                .keyboardType(.numberPad)
                                .onReceive(Just(cardNumber)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered.count <= 16 {
                                        cardNumber = filtered
                                    } else {
                                        cardNumber = String(filtered.prefix(16))
                                    }
                                }
                    }

                    TextField("Expiration Date (MM/YY)", text: $expirationDate)
                            .keyboardType(.numbersAndPunctuation)
                            .onReceive(Just(expirationDate)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered.count > 4 {
                                    expirationDate = String(filtered.prefix(4))
                                } else {
                                    expirationDate = filtered
                                }
                                if expirationDate.count > 2 {
                                    expirationDate.insert("/", at: expirationDate.index(expirationDate.startIndex, offsetBy: 2))
                                }
                            }

                    SecureField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                            .onReceive(Just(cvv)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered.count <= 3 {
                                    cvv = filtered
                                } else {
                                    cvv = String(filtered.prefix(3))
                                }
                            }

                    AmountTextField(amount: $amount)
                }

                Section {
                    Button(action: {
                        submitPayment()
                    }) {
                        Text("Submit Payment")
                    }
                }

                if let message = message {
                    Section {
                        Text(message)
                                .foregroundColor(.green)
                    }
                }
            }
                    .navigationTitle("Payment Form")
        }
    }

    func submitPayment() {
        guard let url = URL(string: "http://localhost:8000/payment") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParameters = "name=\(name)&card_number=\(cardNumber)&expiration_date=\(expirationDate)&cvv=\(cvv)&amount=\(amount)"
        request.httpBody = bodyParameters.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        DispatchQueue.main.async {
                            message = "Failed to process payment."
                        }
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let messageResponse = json["message"] as? String {
                            DispatchQueue.main.async {
                                message = messageResponse
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            message = "Unexpected server response."
                        }
                    }
                }.resume()
    }
}

struct AmountTextField: View {
    @Binding var amount: String

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .onReceive(Just(amount)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        amount = filtered
                    }

            Text("$")
                    .foregroundColor(.gray)
                    .opacity(0.6)
                    .padding(.trailing, 8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}