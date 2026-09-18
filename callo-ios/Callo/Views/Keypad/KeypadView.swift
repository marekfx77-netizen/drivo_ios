import SwiftUI

public struct KeypadView: View {
    @ObservedObject var state: DialerStateManager
    @State private var isAddContactPresented: Bool = false
    @State private var newContactName: String = ""
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    public var body: some View {
        ZStack {
            AppTheme.bgDeep.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Spacer(minLength: 20)
                
                // MARK: - Displayed Phone Number
                VStack(spacing: 8) {
                    Text(state.formattedDigits.isEmpty ? " " : state.formattedDigits)
                        .font(.system(size: state.rawDigits.count > 10 ? 32 : 40, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(height: 52)
                        .padding(.horizontal, 24)
                    
                    if !state.rawDigits.isEmpty {
                        Button(action: {
                            HapticsManager.shared.selectionChanged()
                            isAddContactPresented = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Dodaj do kontaktów")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(AppTheme.neonPurple)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 14)
                            .background(AppTheme.neonPurple.opacity(0.15))
                            .clipShape(Capsule())
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Text(" ")
                            .font(.system(size: 14))
                            .frame(height: 25)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state.rawDigits.isEmpty)
                
                Spacer(minLength: 10)
                
                // MARK: - 3x4 Keypad Grid
                VStack(spacing: 14) {
                    HStack(spacing: 24) {
                        DialerKeyButton(digit: "1", letters: "") { state.appendDigit("1") }
                        DialerKeyButton(digit: "2", letters: "ABC") { state.appendDigit("2") }
                        DialerKeyButton(digit: "3", letters: "DEF") { state.appendDigit("3") }
                    }
                    
                    HStack(spacing: 24) {
                        DialerKeyButton(digit: "4", letters: "GHI") { state.appendDigit("4") }
                        DialerKeyButton(digit: "5", letters: "JKL") { state.appendDigit("5") }
                        DialerKeyButton(digit: "6", letters: "MNO") { state.appendDigit("6") }
                    }
                    
                    HStack(spacing: 24) {
                        DialerKeyButton(digit: "7", letters: "PQRS") { state.appendDigit("7") }
                        DialerKeyButton(digit: "8", letters: "TUV") { state.appendDigit("8") }
                        DialerKeyButton(digit: "9", letters: "WXYZ") { state.appendDigit("9") }
                    }
                    
                    HStack(spacing: 24) {
                        DialerKeyButton(digit: "*", letters: "") { state.appendDigit("*") }
                        
                        // Klawisz 0 z obsługą długiego naciśnięcia wpisującego '+'
                        Button(action: {
                            state.appendDigit("0")
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                VStack(spacing: -1) {
                                    Text("0")
                                        .font(.system(size: 34, weight: .light, design: .rounded))
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text("+")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                            .frame(width: 78, height: 78)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.45).onEnded { _ in
                                HapticsManager.shared.keyPress()
                                state.appendDigit("+")
                            }
                        )
                        
                        DialerKeyButton(digit: "#", letters: "") { state.appendDigit("#") }
                    }
                }
                
                // MARK: - Bottom Action Bar (Call Button & Backspace)
                HStack(spacing: 24) {
                    // Placeholder lewy dla symetrii
                    Color.clear
                        .frame(width: 78, height: 78)
                    
                    // Duży zielony przycisk połączenia z poświatą neonową
                    Button(action: {
                        state.startCall()
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.callGradient)
                                .shadow(color: AppTheme.callGreen.opacity(0.55), radius: 18, x: 0, y: 6)
                                .shadow(color: AppTheme.callGreen.opacity(0.3), radius: 32, x: 0, y: 12)
                            
                            Image(systemName: "phone.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 78, height: 78)
                    }
                    .scaleEffect(state.rawDigits.isEmpty ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state.rawDigits.isEmpty)
                    
                    // Przycisk kasowania Backspace
                    if !state.rawDigits.isEmpty {
                        Button(action: {
                            state.deleteDigit()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                Image(systemName: "delete.left.fill")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(width: 78, height: 78)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                                state.clearDigits()
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Color.clear
                            .frame(width: 78, height: 78)
                    }
                }
                .padding(.top, 10)
                
                Spacer(minLength: 90) // Miejsce na pływający tab bar
            }
            .padding(.horizontal, 24)
        }
        // Arkusz dodawania nowego kontaktu
        .sheet(isPresented: $isAddContactPresented) {
            AddContactSheet(initialPhone: state.formattedDigits) { name, phone in
                state.addContact(name: name, phoneNumber: phone)
                state.clearDigits()
                isAddContactPresented = false
            }
        }
    }
}

// MARK: - Szybki arkusz dodania kontaktu
private struct AddContactSheet: View {
    let initialPhone: String
    let onSave: (String, String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var phone: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        TextField("Imię i nazwisko", text: $name)
                            .padding()
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppTheme.borderGlass, lineWidth: 1))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        TextField("Numer telefonu", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppTheme.borderGlass, lineWidth: 1))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        guard !name.isEmpty else { return }
                        onSave(name, phone)
                    }) {
                        Text("Zapisz kontakt")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(AppTheme.primaryGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: AppTheme.neonPurple.opacity(0.4), radius: 10, y: 4)
                    }
                    .disabled(name.isEmpty)
                    .opacity(name.isEmpty ? 0.5 : 1.0)
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Nowy kontakt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary)
                }
            }
        }
        .onAppear {
            phone = initialPhone
        }
    }
}
