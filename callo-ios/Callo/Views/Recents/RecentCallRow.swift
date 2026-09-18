import SwiftUI

public struct RecentCallRow: View {
    public let record: CallRecord
    public let onCall: () -> Void
    
    public init(record: CallRecord, onCall: @escaping () -> Void) {
        self.record = record
        self.onCall = onCall
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            // Ikona kierunku połączenia
            ZStack {
                Circle()
                    .fill(iconBackgroundColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            // Informacje o rozmówcy
            VStack(alignment: .leading, spacing: 4) {
                Text(record.displayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(record.direction == .missed ? AppTheme.endCallRed : AppTheme.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    if record.direction != .missed {
                        Text(record.formattedDuration)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Text("•")
                            .foregroundColor(AppTheme.textTertiary)
                    }
                    
                    Text(record.relativeTimeFormatted)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    if record.isEncrypted {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 9))
                            .foregroundColor(AppTheme.neonPurple)
                    }
                }
            }
            
            Spacer()
            
            // Przycisk natychmiastowego oddzwonienia (1-tap call)
            Button(action: onCall) {
                ZStack {
                    Circle()
                        .fill(AppTheme.callGreen.opacity(0.15))
                        .frame(width: 38, height: 38)
                        .overlay(Circle().stroke(AppTheme.callGreen.opacity(0.3), lineWidth: 1))
                    
                    Image(systemName: "phone.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.callGreen)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    private var iconName: String {
        switch record.direction {
        case .incoming:
            return "phone.arrow.down.left"
        case .outgoing:
            return "phone.arrow.up.right"
        case .missed:
            return "phone.arrow.down.left"
        }
    }
    
    private var iconColor: Color {
        switch record.direction {
        case .incoming:
            return AppTheme.callGreen
        case .outgoing:
            return AppTheme.neonBlue
        case .missed:
            return AppTheme.endCallRed
        }
    }
    
    private var iconBackgroundColor: Color {
        switch record.direction {
        case .incoming:
            return AppTheme.callGreen
        case .outgoing:
            return AppTheme.neonBlue
        case .missed:
            return AppTheme.endCallRed
        }
    }
}
