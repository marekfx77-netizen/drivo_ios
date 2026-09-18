import SwiftUI

public struct ContactDetailSheet: View {
    public let contact: Contact
    @ObservedObject var state: DialerStateManager
    @Environment(\.dismiss) private var dismiss
    
    public init(contact: Contact, state: DialerStateManager) {
        self.contact = contact
        self.state = state
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Avatar & Header
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: contact.gradientColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: 106, height: 106)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppTheme.bgSurface, AppTheme.bgElevated],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 96, height: 96)
                                    .overlay(
                                        Text(contact.initials)
                                            .font(.system(size: 36, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                    )
                            }
                            .padding(.top, 16)
                            
                            VStack(spacing: 4) {
                                Text(contact.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                if let comp = contact.company {
                                    Text(comp)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                        }
                        
                        // MARK: - Action Buttons (Call, Msg, Video, Mail)
                        HStack(spacing: 18) {
                            quickActionButton(icon: "phone.fill", label: "Zadzwoń", color: AppTheme.callGreen) {
                                dismiss()
                                state.startCall(number: contact.phoneNumber, contactName: contact.name)
                            }
                            
                            quickActionButton(icon: "message.fill", label: "Wiadomość", color: AppTheme.neonBlue) {
                                // Akcja wiadomości
                            }
                            
                            quickActionButton(icon: "video.fill", label: "FaceTime", color: AppTheme.neonPurple) {
                                dismiss()
                                state.startCall(number: contact.phoneNumber, contactName: contact.name)
                            }
                            
                            quickActionButton(icon: "envelope.fill", label: "E-mail", color: AppTheme.warningYellow) {
                                // Akcja email
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Contact Details Card
                        VStack(spacing: 16) {
                            detailRow(icon: "phone", title: "telefon komórkowy", value: contact.phoneNumber)
                            
                            if !contact.email.isEmpty {
                                Divider().background(Color.white.opacity(0.08))
                                detailRow(icon: "envelope", title: "e-mail prywatny", value: contact.email)
                            }
                            
                            Divider().background(Color.white.opacity(0.08))
                            detailRow(icon: "lock.shield", title: "szyfrowanie połączeń", value: "Aktywne (E2EE Callo Protect)")
                        }
                        .padding(20)
                        .background(AppTheme.bgSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppTheme.borderGlass, lineWidth: 1))
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                        .foregroundColor(AppTheme.neonPurple)
                }
            }
        }
    }
    
    @ViewBuilder
    private func quickActionButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.18))
                        .frame(width: 54, height: 54)
                        .overlay(Circle().stroke(color.opacity(0.35), lineWidth: 1))
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.neonPurple)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
        }
    }
}
