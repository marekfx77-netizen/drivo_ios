# 📞 Callo — Dark Premium VoIP & Dialer na iOS 17+ (iPhone 15)

Nowoczesna, dopracowana aplikacja do połączeń głosowych i zarządzania komunikacją na system **iOS 17+**, zaprojektowana w ultraciemnym stylu **Dark Premium / Glassmorphism** (w estetyce aplikacji Uber Black, Drivo oraz Bolt Premium).

Aplikacja jest w pełni przygotowana do bezpośredniej kompilacji do niepodpisanego pliku `.ipa` za pośrednictwem darmowego środowiska **GitHub Actions (`macos-14`)** i instalacji na dowolnym iPhonie za pomocą narzędzia **Sideloadly** (bez konieczności posiadania płatnego konta Apple Developer).

---

## 📸 Funkcjonalności i Ekrany

### 1. Ekran Klawiatury (Keypad / Dialer)
- Klawiatura numeryczna 3×4 ze zoptymalizowaną haptyką Taptic Engine (`rigid` / `light`).
- Inteligentne formatowanie numeru w locie (standardy `+48 XXX XXX XXX` oraz `XXX XXX XXX`).
- Długie naciśnięcie klawisza `0` wstawia symbol międzynarodowy `+`.
- Szybkie usuwanie (pojedyncze dotknięcie usuwa ostatnią cyfrę, przytrzymanie czyści cały numer).
- Dynamiczny przycisk **"Dodaj do kontaktów"** pojawiający się automatycznie po wprowadzeniu cyfr.
- Duży, neonowo-zielony przycisk nawiązywania połączenia (`#00D68F`) z podwójną poświatą neonową (*ambient glow*).

### 2. Ekran Aktywnego Połączenia (In-Call Screen)
- Animowany na żywo korektor dźwięku (**HD Voice Soundwave Visualizer**) reagujący na symulowaną mowę rozmówcy.
- Odliczający stoper trwania połączenia (`00:00`).
- Wskaźnik bezpieczeństwa: `HD VOICE • 256-BIT SZYFROWANIE` (symulacja SRTP / E2EE).
- Duży, pulsujący awatar z obracającym się ringiem gradientowym.
- Pływająca siatka 6 przycisków sterujących:
  - **Wycisz (Mute)** z czerwonym wyróżnieniem,
  - **Klawiatura DTMF** do wybierania tonowego (np. infolinie i automatyczne centrale IVR),
  - **Dźwięk / Głośnik** z selektorem urządzeń wyjściowych (*iPhone*, *Głośnomówiący*, *AirPods Pro*),
  - **Dodaj rozmówcę** (konferencja),
  - **FaceTime / Wideo**,
  - **Wstrzymaj (Hold)**.
- Czerwony, sprężysty przycisk zakończenia rozmowy z automatycznym zapisem do historii połączeń.

### 3. Ostatnie Połączenia (Recents)
- Przełącznik segmentowy: **Wszystkie** oraz **Nieodebrane** (wyróżnione kolorem czerwonym).
- Szczegółowe metadane: czas trwania rozmowy, względna data ("12 min temu", "Wczoraj"), ikony kierunku połączenia.
- Przycisk szybkiego oddzwaniania (*1-Tap Callback*).

### 4. Kontakty (Contacts)
- Błyskawiczna wyszukiwarka filtrująca listę po imieniu, nazwisku i numerze w czasie rzeczywistym.
- Pozioma karuzela ulubionych kontaktów (**Ulubione**) z neonowymi pierścieniami.
- Pełna karta kontaktu (**Contact Details**) z przyciskami Zadzwoń, Wiadomość, FaceTime, E-mail oraz statusem ochrony E2EE.

### 5. Poczta Głosowa (Voicemail) & Ustawienia
- Odtwarzacz audio z animowanym paskiem postępu odsłuchu wiadomości.
- **Inteligentna transkrypcja AI** (Whisper HD) prezentująca treść nagranej wiadomości w formie tekstu.
- Panel ustawień:
  - Automatyczne wyciszanie nieznanych numerów (*Silence Unknown Callers*),
  - Włącznik jakości HD Voice+ (kodek Opus),
  - Sprzężenie zwrotne Taptic Engine,
  - Wybór dzwonków (Neon Pulse, Cosmic Bell, Minimal Glass, Obsidian Glow).

---

## ⚡ Błyskawiczny Podgląd w Przeglądarce (Web Prototype)

Aplikacja zawiera pełny, autonomiczny prototyp w pliku `preview/index.html` z symulacją iPhone 15 Pro i silnikiem syntezy dźwięków DTMF (Web Audio API):

1. Przejdź do folderu `preview/`:
   ```powershell
   cd preview
   ```
2. Otwórz plik `index.html` bezpośrednio w dowolnej nowoczesnej przeglądarce (kliknij dwukrotnie w Eksploratorze Windows lub wpisz):
   ```powershell
   Start-Process index.html
   ```
3. Możesz także uruchomić lekki serwer HTTP:
   ```powershell
   python -m http.server 8080
   ```
   I otworzyć adres `http://localhost:8080`.

---

## 🚀 Automatyczna Kompilacja .ipa na GitHub Actions i Instalacja przez Sideloadly

Projekt posiada gotowy workflow w `.github/workflows/build-ipa.yml`, który buduje plik `.ipa` na maszynie `macos-14` w chmurze GitHuba bez konieczności posiadania komputera Mac.

### Krok 1: Wypchnięcie projektu na GitHub
1. Utwórz nowe repozytorium na swoim profilu GitHub (np. `callo-ios`).
2. W folderze `callo-ios` zainicjalizuj gita i wyślij kod:
   ```bash
   git init
   git add .
   git commit -m "Initial commit - Callo iOS app"
   git branch -M main
   git remote add origin https://github.com/TWOJA_NAZWA_UZYTKOWNIKA/callo-ios.git
   git push -u origin main
   ```

### Krok 2: Pobranie gotowego pliku .ipa
1. Wejdź w zakładkę **Actions** w swoim repozytorium GitHub.
2. Zobaczysz uruchomione zadanie **Kompilacja Callo IPA (Sideloadly)**.
3. Po zakończeniu (ok. 2–3 minuty) kliknij w szczegóły workflow i w sekcji **Artifacts** pobierz spakowany plik `Callo-iOS-Unsigned-IPA.zip`.
4. Rozpakuj archiwum – otrzymasz plik `Callo.ipa`.

### Krok 3: Wgranie na iPhone przez Sideloadly
1. Pobierz i zainstaluj darmowy program [Sideloadly](https://sideloadly.io/) (na Windows lub macOS).
2. Podłącz iPhone'a kablem USB do komputera i odblokuj ekran (wybierz "Ufaj temu komputerowi", jeśli pojawi się zapytanie).
3. Uruchom Sideloadly:
   - W polu **iDevice** wybierz swojego iPhone'a.
   - W polu **Apple ID** wpisz swój prywatny, darmowy adres e-mail Apple ID.
   - Przeciągnij i upuść pobrany plik `Callo.ipa` w pole ikony w Sideloadly.
4. Kliknij przycisk **Start**. Podaj hasło do swojego konta Apple ID (oraz kod 2FA wysłany na Twój telefon).
5. Sideloadly automatycznie podpisze pakiet Twoim darmowym certyfikatem deweloperskim i zainstaluje aplikację **Callo** na Twoim telefonie.

### Krok 4: Pierwsze uruchomienie na iOS
1. Na telefonie przejdź do: **Ustawienia -> Ogólne -> VPN i zarządzanie urządzeniami**.
2. Kliknij w swoje konto Apple ID w sekcji *Aplikacja dewelopera* i wybierz **Zaufaj [Twój Apple ID]**.
3. Uruchom aplikację **Callo** z ekranu głównego!

---

## 💻 Struktura Projektu

```
callo-ios/
├── .github/
│   └── workflows/
│       └── build-ipa.yml           # Workflow kompilacji Xcode na macos-14
├── Callo/
│   ├── App/
│   │   ├── CalloApp.swift          # @main, konfiguracja AVAudioSession
│   │   └── Info.plist              # Uprawnienia mikrofonu i tryb VoIP
│   ├── Theme/
│   │   ├── AppTheme.swift          # Tokeny kolorów HEX, gradienty, akcenty
│   │   └── GlassCardModifier.swift # Efekty matowego szkła i poświaty neonowej
│   ├── Managers/
│   │   ├── DialerStateManager.swift# Stan połączenia, timer, historia, kontakty
│   │   ├── HapticsManager.swift    # Obsługa Taptic Engine (UIImpactFeedback)
│   │   └── SoundwaveManager.swift  # Dynamiczny generator fali dźwiękowej
│   ├── Models/
│   │   ├── Contact.swift           # Model kontaktu i ulubionych
│   │   ├── CallRecord.swift        # Historia połączeń (odebrane/nieodebrane)
│   │   └── VoicemailItem.swift     # Poczta głosowa z transkrypcją AI
│   ├── Views/
│   │   ├── ContentView.swift       # Główny dock zakładek i nawigacja
│   │   ├── Keypad/
│   │   │   ├── KeypadView.swift    # Klawiatura z dynamicznym formatowaniem
│   │   │   └── DialerKeyButton.swift# Klawisz cyfry ze szkła z reakcją spring
│   │   ├── InCall/
│   │   │   ├── InCallView.swift    # Pełnoekranowy ekran trwającego połączenia
│   │   │   ├── SoundwaveVisualizer.swift # Korektor dźwięku na żywo
│   │   │   └── AudioRoutePickerSheet.swift # Wybór głośnika / AirPods
│   │   ├── Recents/
│   │   │   ├── RecentsView.swift   # Filtrowanie historii połączeń
│   │   │   └── RecentCallRow.swift # Wiersz z czasem trwania i oddzwanianiem
│   │   ├── Contacts/
│   │   │   ├── ContactsView.swift  # Wyszukiwarka i karuzela ulubionych
│   │   │   └── ContactDetailSheet.swift # Karta kontaktu z akcjami
│   │   ├── Voicemail/
│   │   │   ├── VoicemailView.swift # Lista nagrań poczty głosowej
│   │   │   └── VoicemailRow.swift  # Odtwarzacz audio i transkrypcja AI
│   │   └── Settings/
│   │       └── SettingsSheet.swift # Wyciszanie nieznanych, dzwonki, szyfrowanie
│   └── Assets.xcassets/            # Zasoby graficzne, kolory i ikony
├── Callo.xcodeproj/
│   └── project.pbxproj             # Plik projektu Xcode (iOS 17+)
└── preview/
    └── index.html                  # Interaktywny prototyp PWA z dźwiękami DTMF
```
