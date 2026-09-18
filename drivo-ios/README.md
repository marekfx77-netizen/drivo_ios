# 🚗 Drivo — Aplikacja iOS (SwiftUI)

Dopracowana aplikacja do zamawiania przejazdów w stylu Bolt / Uber, stworzona pod iOS 17+ (iPhone 15).

---

## 📱 Jak zbudować plik `.ipa` przez GitHub Actions:

### Krok 1: Utwórz nowe repozytorium na GitHub
1. Wejdź na [github.com/new](https://github.com/new)
2. Nazwij repozytorium np. `drivo-ios`
3. Ustaw jako **Public** lub **Private**
4. Kliknij **Create repository**

### Krok 2: Wgraj pliki projektu
Możesz wgrać pliki z folderu `drivo-ios` bezpośrednio przez przeglądarkę (kliknij *uploading an existing file* na GitHubie) lub przez Git / GitHub Desktop:
- `.github/workflows/build-ipa.yml`
- `Drivo.xcodeproj`
- `Drivo/`
- `.gitignore`

### Krok 3: Automatyczny build `.ipa`
1. Po wgraniu plików wejdź w zakładkę **Actions** w Twoim repozytorium na GitHubie.
2. Zobaczysz uruchomiony workflow **"Build Drivo iOS IPA"**.
3. Kompilacja potrwa około 2-4 minut na maszynie wirtualnej macOS w chmurze Apple.
4. Gdy workflow zakończy się zielonym ptaszkiem `✓`, kliknij w ten build.
5. Na dole w sekcji **Artifacts** kliknij **`Drivo-ipa`** — pobierze się spakowany plik `Drivo.ipa`!

---

## 📲 Jak zainstalować na iPhonie przez Sideloadly:

1. Podłącz iPhone kablem USB do komputera.
2. Otwórz program **Sideloadly**.
3. Przeciągnij pobrany plik `Drivo.ipa` w okno Sideloadly.
4. Wpisz swój Apple ID (w polu "Apple ID").
5. Kliknij **Start**.
6. Po chwili aplikacja **Drivo** pojawi się na ekranie Twojego iPhone'a!
7. *(Tylko za pierwszym razem)* Na iPhonie wejdź w:
   **Ustawienia → Ogólne → VPN i zarządzanie urządzeniem → Twój Apple ID → Zaufaj**.

---

## ✨ Zawartość aplikacji:
- **Splash Screen**: animowane logo i wejście
- **Ekran Główny**: mapa MapKit z przełącznikiem **Satelita / Klasyczna**, szybkie kafelki (Dom, Praca, Ulubione), banner rabatowy `-25%`, historia ostatnich miejsc
- **Wyszukiwarka**: pole adresu, filtry kategorii, podpowiedzi
- **Wybór przejazdu**: 3 klasy aut (Eco, Comfort, XL), podgląd trasy, wyliczanie czasu i ceny, kod promocyjny, metody płatności
- **Śledzenie przejazdu w czasie rzeczywistym**: licznik ETA, dane kierowcy, numery rejestracyjne, przyciski akcji (telefon, SMS, bezpieczeństwo)
- **Historia przejazdów**: lista zrealizowanych kursów ze statusami
- **Profil użytkownika**: statystyki (przejazdy, kilometry, wydatki), metody płatności, ustawienia
