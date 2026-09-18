import SwiftUI

public struct ContactsView: View {
    @ObservedObject var state: DialerStateManager
    @State private var searchText: String = ""
    @State private var selectedContact: Contact?
    @State private var isAddContactPresented: Bool = false
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    private var favoriteContacts: [Contact] {
        state.contacts.filter { $0.isFavorite }
    }
    
    private var filteredContacts: [Contact] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return state.contacts.sorted { $0.name < $1.name }
        } else {
            let query = searchText.lowercased()
            return state.contacts.filter {
                $0.name.lowercased().contains(query) ||
                $0.phoneNumber.contains(query)
            }.sorted { $0.name < $1.name }
        }
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Search Bar
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Szukaj kontaktu...", text: $searchText)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppTheme.textTertiary)
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(AppTheme.bgSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppTheme.borderGlass, lineWidth: 1))
                        .padding(.horizontal, 20)
                        
                        // MARK: - Favorites Carousel
                        if searchText.isEmpty && !favoriteContacts.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ULUBIONE")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(1.2)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(favoriteContacts) { fav in
                                            Button(action: {
                                                selectedContact = fav
                                            }) {
                                                VStack(spacing: 8) {
                                                    ZStack {
                                                        Circle()
                                                            .stroke(
                                                                LinearGradient(
                                                                    colors: fav.gradientColors,
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                ),
                                                                lineWidth: 2
                                                            )
                                                            .frame(width: 64, height: 64)
                                                        
                                                        Circle()
                                                            .fill(AppTheme.bgSurface)
                                                            .frame(width: 58, height: 58)
                                                            .overlay(
                                                                Text(fav.initials)
                                                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                                    .foregroundColor(.white)
                                                            )
                                                    }
                                                    
                                                    Text(fav.name.components(separatedBy: " ").first ?? fav.name)
                                                        .font(.system(size: 13, weight: .medium))
                                                        .foregroundColor(AppTheme.textPrimary)
                                                        .lineLimit(1)
                                                        .frame(width: 68)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // MARK: - Contacts List
                        VStack(alignment: .leading, spacing: 10) {
                            Text("WSZYSTKIE KONTAKTY (\(filteredContacts.count))")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1.2)
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.horizontal, 20)
                            
                            LazyVStack(spacing: 6) {
                                ForEach(filteredContacts) { contact in
                                    contactRow(contact)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Kontakty")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddContactPresented = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppTheme.neonPurple)
                    }
                }
            }
        }
        .sheet(item: $selectedContact) { contact in
            ContactDetailSheet(contact: contact, state: state)
        }
        .sheet(isPresented: $isAddContactPresented) {
            AddContactFullSheet { newC in
                state.contacts.append(newC)
                isAddContactPresented = false
            }
        }
    }
    
    @ViewBuilder
    private func contactRow(_ contact: Contact) -> some View {
        Button(action: {
            selectedContact = contact
        }) {
            HStack(spacing: 14) {
                Circle()
                    .fill(AppTheme.bgSurface)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(contact.initials)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .overlay(Circle().stroke(Color.white.opacity(0.08), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(contact.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(contact.phoneNumber)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                Button(action: {
                    state.startCall(number: contact.phoneNumber, contactName: contact.name)
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.callGreen.opacity(0.12))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "phone.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.callGreen)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(Color.white.opacity(0.025))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.05), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Arkusz dodawania kontaktu z kontaktów
private struct AddContactFullSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Contact) -> Void
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var company: String = ""
    @State private var isFav: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                VStack(spacing: 18) {
                    VStack(spacing: 12) {
                        customField(placeholder: "Imię i nazwisko", text: $name)
                        customField(placeholder: "Numer telefonu", text: $phone, keyboard: .phonePad)
                        customField(placeholder: "Adres e-mail", text: $email, keyboard: .emailAddress)
                        customField(placeholder: "Stanowisko / Firma", text: $company)
                        
                        Toggle("Dodaj do ulubionych", isOn: $isFav)
                            .tint(AppTheme.neonPurple)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .padding(.top, 14)
                    
                    Button(action: {
                        guard !name.isEmpty && !phone.isEmpty else { return }
                        let newC = Contact(
                            name: name,
                            phoneNumber: phone,
                            email: email,
                            company: company.isEmpty ? nil : company,
                            isFavorite: isFav
                        )
                        onSave(newC)
                    }) {
                        Text("Zapisz")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppTheme.primaryGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(name.isEmpty || phone.isEmpty)
                    .opacity(name.isEmpty || phone.isEmpty ? 0.5 : 1.0)
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Nowy kontakt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
        }
    }
    
    @ViewBuilder
    private func customField(placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(AppTheme.bgSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppTheme.borderGlass, lineWidth: 1))
            .foregroundColor(AppTheme.textPrimary)
    }
}
