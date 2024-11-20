import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentNumber = ""
    @State private var result = 0.0
    @State private var lastOperation: String?

    var body: some View {
        VStack {
            Text(display)
                    .font(.largeTitle)
                    .padding()

            HStack {
                Button("1") { appendNumber("1") }
                Button("2") { appendNumber("2") }
                Button("3") { appendNumber("3") }
            }
            HStack {
                Button("4") { appendNumber("4") }
                Button("5") { appendNumber("5") }
                Button("6") { appendNumber("6") }
            }
            HStack {
                Button("7") { appendNumber("7") }
                Button("8") { appendNumber("8") }
                Button("9") { appendNumber("9") }
            }
            HStack {
                Button("0") { appendNumber("0") }
                Button("+") { performOperation("+") }
                Button("=") { calculateResult() }
            }
            HStack {
                Button("*") { performOperation("*") }
                Button("/") { performOperation("/") }
                Button("-") { performOperation("-") }
            }
            HStack {
                Button("%") { performOperation("%") }
                Button("log") { performOperation("log") }
                Button("^") { performOperation("^") }
            }
            Button("C") { clear() }
        }
    }

    private func appendNumber(_ number: String) {
        currentNumber += number
        display = currentNumber
    }

    private func performOperation(_ operation: String) {
        if let value = Double(currentNumber) {
            if let lastOp = lastOperation {
                switch lastOp {
                case "+":
                    result += value
                case "-":
                    result -= value
                case "*":
                    result *= value
                case "/":
                    result /= value
                case "%":
                    result = result * (value / 100)
                case "log":
                    result = log(value)
                case "^":
                    result = pow(result, value)
                default:
                    break
                }
            } else {
                result = value
            }
            lastOperation = operation
            currentNumber = ""
            display = "\(result)"
        } else if !currentNumber.isEmpty {
            lastOperation = operation
        }
    }

    private func calculateResult() {
        performOperation(lastOperation ?? "+")
        currentNumber = "\(result)"
        lastOperation = nil
    }

    private func clear() {
        display = "0"
        currentNumber = ""
        result = 0.0
        lastOperation = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
