import SwiftUI
import UIKit

// MARK: - Section 1: AppLanguage enum
enum AppLanguage: String, CaseIterable, Identifiable, Hashable {
    case system, pl, en, de, es, fr, it, pt, uk, cs, sk, nl, ru
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .pl: return "Polski"
        case .en: return "English"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .fr: return "Français"
        case .it: return "Italiano"
        case .pt: return "Português"
        case .uk: return "Українська"
        case .cs: return "Čeština"
        case .sk: return "Slovenčina"
        case .nl: return "Nederlands"
        case .ru: return "Русский"
        }
    }
    
    var tabServers: String {
        switch self {
        case .pl: return "Serwery"
        case .en, .system: return "Servers"
        case .de: return "Server"
        case .es: return "Servidores"
        case .fr: return "Serveurs"
        case .it: return "Server"
        case .pt: return "Servidores"
        case .uk: return "Сервери"
        case .cs: return "Servery"
        case .sk: return "Servery"
        case .nl: return "Servers"
        case .ru: return "Серверы"
        }
    }
    
    var tabTerminal: String {
        return "Terminal"
    }
    
    var tabFiles: String {
        switch self {
        case .pl: return "Pliki"
        case .en, .system: return "Files"
        case .de: return "Dateien"
        case .es: return "Archivos"
        case .fr: return "Fichiers"
        case .it: return "File"
        case .pt: return "Arquivos"
        case .uk: return "Файли"
        case .cs: return "Soubory"
        case .sk: return "Súbory"
        case .nl: return "Bestanden"
        case .ru: return "Файлы"
        }
    }
    
    var tabSnippets: String {
        switch self {
        case .pl: return "Snippety"
        case .en, .system: return "Snippets"
        case .de: return "Schnipsel"
        case .es: return "Fragmentos"
        case .fr: return "Extraits"
        case .it: return "Frammenti"
        case .pt: return "Trechos"
        case .uk: return "Сніпети"
        case .cs: return "Úryvky"
        case .sk: return "Úryvky"
        case .nl: return "Fragmenten"
        case .ru: return "Сниппеты"
        }
    }
    
    var tabSettings: String {
        switch self {
        case .pl: return "Ustawienia"
        case .en, .system: return "Settings"
        case .de: return "Einstellungen"
        case .es: return "Ajustes"
        case .fr: return "Paramètres"
        case .it: return "Impostazioni"
        case .pt: return "Configurações"
        case .uk: return "Налаштування"
        case .cs: return "Nastavení"
        case .sk: return "Nastavenia"
        case .nl: return "Instellingen"
        case .ru: return "Настройки"
        }
    }
    
    var guestModeTitle: String {
        switch self {
        case .pl: return "Tryb gościa"
        case .en, .system: return "Guest mode"
        case .de: return "Gastmodus"
        case .es: return "Modo invitado"
        case .fr: return "Mode invité"
        case .it: return "Modalità ospite"
        case .pt: return "Modo convidado"
        case .uk: return "Гостьовий режим"
        case .cs: return "Režim hosta"
        case .sk: return "Režim hosťa"
        case .nl: return "Gastmodus"
        case .ru: return "Гостевой режим"
        }
    }
    
    var guestModeMessage: String {
        switch self {
        case .pl: return "Korzystaj z aplikacji bez zapisywania danych."
        case .en, .system: return "Use the app without saving data."
        case .de: return "Nutze die App ohne Daten zu speichern."
        case .es: return "Usa la aplicación sin guardar datos."
        case .fr: return "Utilisez l'application sans enregistrer de données."
        case .it: return "Usa l'app senza salvare dati."
        case .pt: return "Use o app sem salvar dados."
        case .uk: return "Використовуйте додаток без збереження даних."
        case .cs: return "Používejte aplikaci bez ukládání dat."
        case .sk: return "Používajte aplikáciu bez ukladania dát."
        case .nl: return "Gebruik de app zonder gegevens op te slaan."
        case .ru: return "Используйте приложение без сохранения данных."
        }
    }
    
    var continueAsGuest: String {
        switch self {
        case .pl: return "Przejdź jako gość"
        case .en, .system: return "Continue as guest"
        case .de: return "Als Gast fortfahren"
        case .es: return "Continuar como invitado"
        case .fr: return "Continuer en tant qu'invité"
        case .it: return "Continua come ospite"
        case .pt: return "Continuar como convidado"
        case .uk: return "Продовжити як гість"
        case .cs: return "Pokračovat jako host"
        case .sk: return "Pokračovať ako hosť"
        case .nl: return "Doorgaan als gast"
        case .ru: return "Продолжить как гость"
        }
    }
    
    var signIn: String {
        switch self {
        case .pl: return "Zaloguj"
        case .en, .system: return "Sign In"
        case .de: return "Anmelden"
        case .es: return "Iniciar sesión"
        case .fr: return "Se connecter"
        case .it: return "Accedi"
        case .pt: return "Entrar"
        case .uk: return "Увійти"
        case .cs: return "Přihlásit se"
        case .sk: return "Prihlásiť sa"
        case .nl: return "Inloggen"
        case .ru: return "Войти"
        }
    }
    
    var connect: String {
        switch self {
        case .pl: return "Połącz"
        case .en, .system: return "Connect"
        case .de: return "Verbinden"
        case .es: return "Conectar"
        case .fr: return "Connecter"
        case .it: return "Connetti"
        case .pt: return "Conectar"
        case .uk: return "Підключитися"
        case .cs: return "Připojit"
        case .sk: return "Pripojiť"
        case .nl: return "Verbinden"
        case .ru: return "Подключиться"
        }
    }
    
    var disconnect: String {
        switch self {
        case .pl: return "Rozłącz"
        case .en, .system: return "Disconnect"
        case .de: return "Trennen"
        case .es: return "Desconectar"
        case .fr: return "Déconnecter"
        case .it: return "Disconnetti"
        case .pt: return "Desconectar"
        case .uk: return "Відключитися"
        case .cs: return "Odpojit"
        case .sk: return "Odpojiť"
        case .nl: return "Verbreken"
        case .ru: return "Отключиться"
        }
    }
    
    var connected: String {
        switch self {
        case .pl: return "Połączono"
        case .en, .system: return "Connected"
        case .de: return "Verbunden"
        case .es: return "Conectado"
        case .fr: return "Connecté"
        case .it: return "Connesso"
        case .pt: return "Conectado"
        case .uk: return "Підключено"
        case .cs: return "Připojeno"
        case .sk: return "Pripojené"
        case .nl: return "Verbonden"
        case .ru: return "Подключено"
        }
    }
    
    var connecting: String {
        switch self {
        case .pl: return "Łączenie…"
        case .en, .system: return "Connecting…"
        case .de: return "Verbinden…"
        case .es: return "Conectando…"
        case .fr: return "Connexion…"
        case .it: return "Connessione in corso…"
        case .pt: return "Conectando…"
        case .uk: return "Підключення…"
        case .cs: return "Připojování…"
        case .sk: return "Pripájanie…"
        case .nl: return "Verbinden…"
        case .ru: return "Подключение…"
        }
    }
    
    var noServers: String {
        switch self {
        case .pl: return "Brak serwerów. Dodaj pierwszy serwer."
        case .en, .system: return "No servers. Add your first server."
        case .de: return "Keine Server. Füge deinen ersten Server hinzu."
        case .es: return "No hay servidores. Añade tu primer servidor."
        case .fr: return "Aucun serveur. Ajoutez votre premier serveur."
        case .it: return "Nessun server. Aggiungi il tuo primo server."
        case .pt: return "Nenhum servidor. Adicione seu primeiro servidor."
        case .uk: return "Немає серверів. Додайте свій перший сервер."
        case .cs: return "Žádné servery. Přidejte svůj první server."
        case .sk: return "Žiadne servery. Pridajte svoj prvý server."
        case .nl: return "Geen servers. Voeg je eerste server toe."
        case .ru: return "Нет серверов. Добавьте свой первый сервер."
        }
    }
    
    var addServer: String {
        switch self {
        case .pl: return "Dodaj serwer"
        case .en, .system: return "Add server"
        case .de: return "Server hinzufügen"
        case .es: return "Añadir servidor"
        case .fr: return "Ajouter un serveur"
        case .it: return "Aggiungi server"
        case .pt: return "Adicionar servidor"
        case .uk: return "Додати сервер"
        case .cs: return "Přidat server"
        case .sk: return "Pridať server"
        case .nl: return "Server toevoegen"
        case .ru: return "Добавить сервер"
        }
    }
    
    var editServer: String {
        switch self {
        case .pl: return "Edytuj serwer"
        case .en, .system: return "Edit server"
        case .de: return "Server bearbeiten"
        case .es: return "Editar servidor"
        case .fr: return "Modifier le serveur"
        case .it: return "Modifica server"
        case .pt: return "Editar servidor"
        case .uk: return "Редагувати сервер"
        case .cs: return "Upravit server"
        case .sk: return "Upraviť server"
        case .nl: return "Server bewerken"
        case .ru: return "Редактировать сервер"
        }
    }
    
    var addGroup: String {
        switch self {
        case .pl: return "Dodaj grupę"
        case .en, .system: return "Add group"
        case .de: return "Gruppe hinzufügen"
        case .es: return "Añadir grupo"
        case .fr: return "Ajouter un groupe"
        case .it: return "Aggiungi gruppo"
        case .pt: return "Adicionar grupo"
        case .uk: return "Додати групу"
        case .cs: return "Přidat skupinu"
        case .sk: return "Pridať skupinu"
        case .nl: return "Groep toevoegen"
        case .ru: return "Добавить группу"
        }
    }
    
    var serverName: String {
        switch self {
        case .pl: return "Nazwa"
        case .en, .system: return "Name"
        case .de: return "Name"
        case .es: return "Nombre"
        case .fr: return "Nom"
        case .it: return "Nome"
        case .pt: return "Nome"
        case .uk: return "Назва"
        case .cs: return "Název"
        case .sk: return "Názov"
        case .nl: return "Naam"
        case .ru: return "Название"
        }
    }
    
    var hostname: String {
        switch self {
        case .pl: return "Adres serwera"
        case .en, .system: return "Server address"
        case .de: return "Serveradresse"
        case .es: return "Dirección del servidor"
        case .fr: return "Adresse du serveur"
        case .it: return "Indirizzo del server"
        case .pt: return "Endereço do servidor"
        case .uk: return "Адреса сервера"
        case .cs: return "Adresa serveru"
        case .sk: return "Adresa servera"
        case .nl: return "Serveradres"
        case .ru: return "Адрес сервера"
        }
    }
    
    var port: String {
        return "Port"
    }
    
    var username: String {
        switch self {
        case .pl: return "Użytkownik"
        case .en, .system: return "Username"
        case .de: return "Benutzername"
        case .es: return "Usuario"
        case .fr: return "Nom d'utilisateur"
        case .it: return "Nome utente"
        case .pt: return "Usuário"
        case .uk: return "Користувач"
        case .cs: return "Uživatel"
        case .sk: return "Používateľ"
        case .nl: return "Gebruikersnaam"
        case .ru: return "Пользователь"
        }
    }
    
    var password: String {
        switch self {
        case .pl: return "Hasło"
        case .en, .system: return "Password"
        case .de: return "Passwort"
        case .es: return "Contraseña"
        case .fr: return "Mot de passe"
        case .it: return "Password"
        case .pt: return "Senha"
        case .uk: return "Пароль"
        case .cs: return "Heslo"
        case .sk: return "Heslo"
        case .nl: return "Wachtwoord"
        case .ru: return "Пароль"
        }
    }
    
    var authMethod: String {
        switch self {
        case .pl: return "Metoda uwierzytelniania"
        case .en, .system: return "Authentication method"
        case .de: return "Authentifizierungsmethode"
        case .es: return "Método de autenticación"
        case .fr: return "Méthode d'authentification"
        case .it: return "Metodo di autenticazione"
        case .pt: return "Método de autenticação"
        case .uk: return "Метод автентифікації"
        case .cs: return "Metoda autentizace"
        case .sk: return "Metóda overenia"
        case .nl: return "Authenticatiemethode"
        case .ru: return "Метод аутентификации"
        }
    }
    
    var noActiveSessions: String {
        switch self {
        case .pl: return "Brak aktywnych sesji SSH. Wybierz serwer z listy."
        case .en, .system: return "No active SSH sessions. Select a server from the list."
        case .de: return "Keine aktiven SSH-Sitzungen. Wähle einen Server aus der Liste."
        case .es: return "No hay sesiones SSH activas. Seleccione un servidor de la lista."
        case .fr: return "Aucune session SSH active. Sélectionnez un serveur dans la liste."
        case .it: return "Nessuna sessione SSH attiva. Seleziona un server dalla lista."
        case .pt: return "Nenhuma sessão SSH ativa. Selecione um servidor da lista."
        case .uk: return "Немає активних SSH сесій. Виберіть сервер зі списку."
        case .cs: return "Žádné aktivní SSH relace. Vyberte server ze seznamu."
        case .sk: return "Žiadne aktívne SSH relácie. Vyberte server zo zoznamu."
        case .nl: return "Geen actieve SSH-sessies. Selecteer een server uit de lijst."
        case .ru: return "Нет активных SSH сессий. Выберите сервер из списка."
        }
    }
    
    var sendCommand: String {
        switch self {
        case .pl: return "Wyślij"
        case .en, .system: return "Send"
        case .de: return "Senden"
        case .es: return "Enviar"
        case .fr: return "Envoyer"
        case .it: return "Invia"
        case .pt: return "Enviar"
        case .uk: return "Надіслати"
        case .cs: return "Odeslat"
        case .sk: return "Odoslať"
        case .nl: return "Verzenden"
        case .ru: return "Отправить"
        }
    }
    
    var clearTerminal: String {
        switch self {
        case .pl: return "Wyczyść"
        case .en, .system: return "Clear"
        case .de: return "Löschen"
        case .es: return "Limpiar"
        case .fr: return "Effacer"
        case .it: return "Pulisci"
        case .pt: return "Limpar"
        case .uk: return "Очистити"
        case .cs: return "Vyčistit"
        case .sk: return "Vyčistiť"
        case .nl: return "Wissen"
        case .ru: return "Очистить"
        }
    }
    
    var reconnect: String {
        switch self {
        case .pl: return "Połącz ponownie"
        case .en, .system: return "Reconnect"
        case .de: return "Neu verbinden"
        case .es: return "Reconectar"
        case .fr: return "Reconnecter"
        case .it: return "Riconnetti"
        case .pt: return "Reconectar"
        case .uk: return "Перепідключитися"
        case .cs: return "Znovu připojit"
        case .sk: return "Znovu pripojiť"
        case .nl: return "Opnieuw verbinden"
        case .ru: return "Переподключиться"
        }
    }
    
    var noSnippets: String {
        switch self {
        case .pl: return "Brak snippetów. Dodaj pierwszy snippet."
        case .en, .system: return "No snippets. Add your first snippet."
        case .de: return "Keine Schnipsel. Füge deinen ersten Schnipsel hinzu."
        case .es: return "No hay fragmentos. Añade tu primer fragmento."
        case .fr: return "Aucun extrait. Ajoutez votre premier extrait."
        case .it: return "Nessun frammento. Aggiungi il tuo primo frammento."
        case .pt: return "Nenhum trecho. Adicione seu primeiro trecho."
        case .uk: return "Немає сніпетів. Додайте свій перший сніпет."
        case .cs: return "Žádné úryvky. Přidejte svůj první úryvek."
        case .sk: return "Žiadne úryvky. Pridajte svoj prvý úryvok."
        case .nl: return "Geen fragmenten. Voeg je eerste fragment toe."
        case .ru: return "Нет сниппетов. Добавьте свой первый сниппет."
        }
    }
    
    var addSnippet: String {
        switch self {
        case .pl: return "Dodaj snippet"
        case .en, .system: return "Add snippet"
        case .de: return "Schnipsel hinzufügen"
        case .es: return "Añadir fragmento"
        case .fr: return "Ajouter un extrait"
        case .it: return "Aggiungi frammento"
        case .pt: return "Adicionar trecho"
        case .uk: return "Додати сніпет"
        case .cs: return "Přidat úryvek"
        case .sk: return "Pridať úryvok"
        case .nl: return "Fragment toevoegen"
        case .ru: return "Добавить сниппет"
        }
    }
    
    var editSnippet: String {
        switch self {
        case .pl: return "Edytuj snippet"
        case .en, .system: return "Edit snippet"
        case .de: return "Schnipsel bearbeiten"
        case .es: return "Editar fragmento"
        case .fr: return "Modifier l'extrait"
        case .it: return "Modifica frammento"
        case .pt: return "Editar trecho"
        case .uk: return "Редагувати сніпет"
        case .cs: return "Upravit úryvek"
        case .sk: return "Upraviť úryvok"
        case .nl: return "Fragment bewerken"
        case .ru: return "Редактировать сниппет"
        }
    }
    
    var snippetName: String {
        switch self {
        case .pl: return "Nazwa"
        case .en, .system: return "Name"
        case .de: return "Name"
        case .es: return "Nombre"
        case .fr: return "Nom"
        case .it: return "Nome"
        case .pt: return "Nome"
        case .uk: return "Назва"
        case .cs: return "Název"
        case .sk: return "Názov"
        case .nl: return "Naam"
        case .ru: return "Название"
        }
    }
    
    var snippetCommand: String {
        switch self {
        case .pl: return "Komenda"
        case .en, .system: return "Command"
        case .de: return "Befehl"
        case .es: return "Comando"
        case .fr: return "Commande"
        case .it: return "Comando"
        case .pt: return "Comando"
        case .uk: return "Команда"
        case .cs: return "Příkaz"
        case .sk: return "Príkaz"
        case .nl: return "Commando"
        case .ru: return "Команда"
        }
    }
    
    var snippetDescription: String {
        switch self {
        case .pl: return "Opis"
        case .en, .system: return "Description"
        case .de: return "Beschreibung"
        case .es: return "Descripción"
        case .fr: return "Description"
        case .it: return "Descrizione"
        case .pt: return "Descrição"
        case .uk: return "Опис"
        case .cs: return "Popis"
        case .sk: return "Popis"
        case .nl: return "Beschrijving"
        case .ru: return "Описание"
        }
    }
    
    var sendToTerminal: String {
        switch self {
        case .pl: return "Wyślij do terminala"
        case .en, .system: return "Send to terminal"
        case .de: return "An Terminal senden"
        case .es: return "Enviar al terminal"
        case .fr: return "Envoyer au terminal"
        case .it: return "Invia al terminale"
        case .pt: return "Enviar para o terminal"
        case .uk: return "Надіслати до терміналу"
        case .cs: return "Odeslat do terminálu"
        case .sk: return "Odoslať do terminálu"
        case .nl: return "Verzenden naar terminal"
        case .ru: return "Отправить в терминал"
        }
    }
    
    var settings: String {
        switch self {
        case .pl: return "Ustawienia"
        case .en, .system: return "Settings"
        case .de: return "Einstellungen"
        case .es: return "Ajustes"
        case .fr: return "Paramètres"
        case .it: return "Impostazioni"
        case .pt: return "Configurações"
        case .uk: return "Налаштування"
        case .cs: return "Nastavení"
        case .sk: return "Nastavenia"
        case .nl: return "Instellingen"
        case .ru: return "Настройки"
        }
    }
    
    var appearance: String {
        switch self {
        case .pl: return "Wygląd"
        case .en, .system: return "Appearance"
        case .de: return "Erscheinungsbild"
        case .es: return "Apariencia"
        case .fr: return "Apparence"
        case .it: return "Aspetto"
        case .pt: return "Aparência"
        case .uk: return "Вигляд"
        case .cs: return "Vzhled"
        case .sk: return "Vzhľad"
        case .nl: return "Uiterlijk"
        case .ru: return "Внешний вид"
        }
    }
    
    var appTheme: String {
        switch self {
        case .pl: return "Motyw aplikacji"
        case .en, .system: return "App theme"
        case .de: return "App-Design"
        case .es: return "Tema de la aplicación"
        case .fr: return "Thème de l'application"
        case .it: return "Tema dell'app"
        case .pt: return "Tema do aplicativo"
        case .uk: return "Тема додатку"
        case .cs: return "Motiv aplikace"
        case .sk: return "Motív aplikácie"
        case .nl: return "App-thema"
        case .ru: return "Тема приложения"
        }
    }
    
    var terminalTheme: String {
        switch self {
        case .pl: return "Motyw terminala"
        case .en, .system: return "Terminal theme"
        case .de: return "Terminal-Design"
        case .es: return "Tema del terminal"
        case .fr: return "Thème du terminal"
        case .it: return "Tema del terminale"
        case .pt: return "Tema do terminal"
        case .uk: return "Тема терміналу"
        case .cs: return "Motiv terminálu"
        case .sk: return "Motív terminálu"
        case .nl: return "Terminal-thema"
        case .ru: return "Тема терминала"
        }
    }
    
    var fontSize: String {
        switch self {
        case .pl: return "Rozmiar czcionki"
        case .en, .system: return "Font size"
        case .de: return "Schriftgröße"
        case .es: return "Tamaño de fuente"
        case .fr: return "Taille de police"
        case .it: return "Dimensione carattere"
        case .pt: return "Tamanho da fonte"
        case .uk: return "Розмір шрифту"
        case .cs: return "Velikost písma"
        case .sk: return "Veľkosť písma"
        case .nl: return "Lettergrootte"
        case .ru: return "Размер шрифта"
        }
    }
    
    var language: String {
        switch self {
        case .pl: return "Język"
        case .en, .system: return "Language"
        case .de: return "Sprache"
        case .es: return "Idioma"
        case .fr: return "Langue"
        case .it: return "Lingua"
        case .pt: return "Idioma"
        case .uk: return "Мова"
        case .cs: return "Jazyk"
        case .sk: return "Jazyk"
        case .nl: return "Taal"
        case .ru: return "Язык"
        }
    }
    
    var security: String {
        switch self {
        case .pl: return "Bezpieczeństwo"
        case .en, .system: return "Security"
        case .de: return "Sicherheit"
        case .es: return "Seguridad"
        case .fr: return "Sécurité"
        case .it: return "Sicurezza"
        case .pt: return "Segurança"
        case .uk: return "Безпека"
        case .cs: return "Bezpečnost"
        case .sk: return "Bezpečnosť"
        case .nl: return "Beveiliging"
        case .ru: return "Безопасность"
        }
    }
    
    var sshKeys: String {
        switch self {
        case .pl: return "Klucze SSH"
        case .en, .system: return "SSH keys"
        case .de: return "SSH-Schlüssel"
        case .es: return "Claves SSH"
        case .fr: return "Clés SSH"
        case .it: return "Chiavi SSH"
        case .pt: return "Chaves SSH"
        case .uk: return "Ключі SSH"
        case .cs: return "SSH klíče"
        case .sk: return "SSH kľúče"
        case .nl: return "SSH-sleutels"
        case .ru: return "Ключи SSH"
        }
    }
    
    var importKey: String {
        switch self {
        case .pl: return "Importuj klucz"
        case .en, .system: return "Import key"
        case .de: return "Schlüssel importieren"
        case .es: return "Importar clave"
        case .fr: return "Importer une clé"
        case .it: return "Importa chiave"
        case .pt: return "Importar chave"
        case .uk: return "Імпортувати ключ"
        case .cs: return "Importovat klíč"
        case .sk: return "Importovať kľúč"
        case .nl: return "Sleutel importeren"
        case .ru: return "Импортировать ключ"
        }
    }
    
    var deleteKey: String {
        switch self {
        case .pl: return "Usuń klucz"
        case .en, .system: return "Delete key"
        case .de: return "Schlüssel löschen"
        case .es: return "Eliminar clave"
        case .fr: return "Supprimer la clé"
        case .it: return "Elimina chiave"
        case .pt: return "Excluir chave"
        case .uk: return "Видалити ключ"
        case .cs: return "Odstranit klíč"
        case .sk: return "Odstrániť kľúč"
        case .nl: return "Sleutel verwijderen"
        case .ru: return "Удалить ключ"
        }
    }
    
    var connection: String {
        switch self {
        case .pl: return "Połączenie"
        case .en, .system: return "Connection"
        case .de: return "Verbindung"
        case .es: return "Conexión"
        case .fr: return "Connexion"
        case .it: return "Connessione"
        case .pt: return "Conexão"
        case .uk: return "З'єднання"
        case .cs: return "Připojení"
        case .sk: return "Pripojenie"
        case .nl: return "Verbinding"
        case .ru: return "Соединение"
        }
    }
    
    var timeout: String {
        switch self {
        case .pl: return "Timeout (sekundy)"
        case .en, .system: return "Timeout (seconds)"
        case .de: return "Zeitüberschreitung (Sekunden)"
        case .es: return "Tiempo de espera (segundos)"
        case .fr: return "Délai d'attente (secondes)"
        case .it: return "Timeout (secondi)"
        case .pt: return "Tempo limite (segundos)"
        case .uk: return "Таймаут (секунди)"
        case .cs: return "Časový limit (sekundy)"
        case .sk: return "Časový limit (sekundy)"
        case .nl: return "Time-out (seconden)"
        case .ru: return "Тайм-аут (секунды)"
        }
    }
    
    var about: String {
        switch self {
        case .pl: return "O aplikacji"
        case .en, .system: return "About"
        case .de: return "Über"
        case .es: return "Acerca de"
        case .fr: return "À propos"
        case .it: return "Informazioni"
        case .pt: return "Sobre"
        case .uk: return "Про програму"
        case .cs: return "O aplikaci"
        case .sk: return "O aplikácii"
        case .nl: return "Over"
        case .ru: return "О приложении"
        }
    }
    
    var version: String {
        switch self {
        case .pl: return "Wersja"
        case .en, .system: return "Version"
        case .de: return "Version"
        case .es: return "Versión"
        case .fr: return "Version"
        case .it: return "Versione"
        case .pt: return "Versão"
        case .uk: return "Версія"
        case .cs: return "Verze"
        case .sk: return "Verzia"
        case .nl: return "Versie"
        case .ru: return "Версия"
        }
    }
    
    var notes: String {
        switch self {
        case .pl: return "Notatki"
        case .en, .system: return "Notes"
        case .de: return "Notizen"
        case .es: return "Notas"
        case .fr: return "Notes"
        case .it: return "Note"
        case .pt: return "Notas"
        case .uk: return "Нотатки"
        case .cs: return "Poznámky"
        case .sk: return "Poznámky"
        case .nl: return "Notities"
        case .ru: return "Заметки"
        }
    }
    
    var save: String {
        switch self {
        case .pl: return "Zapisz"
        case .en, .system: return "Save"
        case .de: return "Speichern"
        case .es: return "Guardar"
        case .fr: return "Enregistrer"
        case .it: return "Salva"
        case .pt: return "Salvar"
        case .uk: return "Зберегти"
        case .cs: return "Uložit"
        case .sk: return "Uložiť"
        case .nl: return "Opslaan"
        case .ru: return "Сохранить"
        }
    }
    
    var cancel: String {
        switch self {
        case .pl: return "Anuluj"
        case .en, .system: return "Cancel"
        case .de: return "Abbrechen"
        case .es: return "Cancelar"
        case .fr: return "Annuler"
        case .it: return "Annulla"
        case .pt: return "Cancelar"
        case .uk: return "Скасувати"
        case .cs: return "Zrušit"
        case .sk: return "Zrušiť"
        case .nl: return "Annuleren"
        case .ru: return "Отмена"
        }
    }
    
    var delete: String {
        switch self {
        case .pl: return "Usuń"
        case .en, .system: return "Delete"
        case .de: return "Löschen"
        case .es: return "Eliminar"
        case .fr: return "Supprimer"
        case .it: return "Elimina"
        case .pt: return "Excluir"
        case .uk: return "Видалити"
        case .cs: return "Odstranit"
        case .sk: return "Odstrániť"
        case .nl: return "Verwijderen"
        case .ru: return "Удалить"
        }
    }
    
    var edit: String {
        switch self {
        case .pl: return "Edytuj"
        case .en, .system: return "Edit"
        case .de: return "Bearbeiten"
        case .es: return "Editar"
        case .fr: return "Modifier"
        case .it: return "Modifica"
        case .pt: return "Editar"
        case .uk: return "Редагувати"
        case .cs: return "Upravit"
        case .sk: return "Upraviť"
        case .nl: return "Bewerken"
        case .ru: return "Редактировать"
        }
    }
    
    var close: String {
        switch self {
        case .pl: return "Zamknij"
        case .en, .system: return "Close"
        case .de: return "Schließen"
        case .es: return "Cerrar"
        case .fr: return "Fermer"
        case .it: return "Chiudi"
        case .pt: return "Fechar"
        case .uk: return "Закрити"
        case .cs: return "Zavřít"
        case .sk: return "Zatvoriť"
        case .nl: return "Sluiten"
        case .ru: return "Закрыть"
        }
    }
    
    var refresh: String {
        switch self {
        case .pl: return "Odśwież"
        case .en, .system: return "Refresh"
        case .de: return "Aktualisieren"
        case .es: return "Actualizar"
        case .fr: return "Actualiser"
        case .it: return "Aggiorna"
        case .pt: return "Atualizar"
        case .uk: return "Оновити"
        case .cs: return "Obnovit"
        case .sk: return "Obnoviť"
        case .nl: return "Vernieuwen"
        case .ru: return "Обновить"
        }
    }
    
    var newFolder: String {
        switch self {
        case .pl: return "Nowy folder"
        case .en, .system: return "New folder"
        case .de: return "Neuer Ordner"
        case .es: return "Nueva carpeta"
        case .fr: return "Nouveau dossier"
        case .it: return "Nuova cartella"
        case .pt: return "Nova pasta"
        case .uk: return "Нова папка"
        case .cs: return "Nová složka"
        case .sk: return "Nový priečinok"
        case .nl: return "Nieuwe map"
        case .ru: return "Новая папка"
        }
    }
    
    var folderName: String {
        switch self {
        case .pl: return "Nazwa folderu"
        case .en, .system: return "Folder name"
        case .de: return "Ordnername"
        case .es: return "Nombre de carpeta"
        case .fr: return "Nom du dossier"
        case .it: return "Nome cartella"
        case .pt: return "Nome da pasta"
        case .uk: return "Назва папки"
        case .cs: return "Název složky"
        case .sk: return "Názov priečinka"
        case .nl: return "Mapnaam"
        case .ru: return "Имя папки"
        }
    }
    
    var copyPath: String {
        switch self {
        case .pl: return "Kopiuj ścieżkę"
        case .en, .system: return "Copy path"
        case .de: return "Pfad kopieren"
        case .es: return "Copiar ruta"
        case .fr: return "Copier le chemin"
        case .it: return "Copia percorso"
        case .pt: return "Copiar caminho"
        case .uk: return "Копіювати шлях"
        case .cs: return "Kopírovat cestu"
        case .sk: return "Kopírovať cestu"
        case .nl: return "Pad kopiëren"
        case .ru: return "Копировать путь"
        }
    }
    
    var monitoring: String {
        switch self {
        case .pl: return "Monitoring"
        case .en, .system: return "Monitoring"
        case .de: return "Überwachung"
        case .es: return "Monitoreo"
        case .fr: return "Surveillance"
        case .it: return "Monitoraggio"
        case .pt: return "Monitoramento"
        case .uk: return "Моніторинг"
        case .cs: return "Monitorování"
        case .sk: return "Monitorovanie"
        case .nl: return "Monitoring"
        case .ru: return "Мониторинг"
        }
    }
    
    var cpu: String { return "CPU" }
    var memory: String {
        switch self {
        case .pl: return "Pamięć"
        case .en, .system: return "Memory"
        case .de: return "Speicher"
        case .es: return "Memoria"
        case .fr: return "Mémoire"
        case .it: return "Memoria"
        case .pt: return "Memória"
        case .uk: return "Пам'ять"
        case .cs: return "Paměť"
        case .sk: return "Pamäť"
        case .nl: return "Geheugen"
        case .ru: return "Память"
        }
    }
    var disk: String {
        switch self {
        case .pl: return "Dysk"
        case .en, .system: return "Disk"
        case .de: return "Festplatte"
        case .es: return "Disco"
        case .fr: return "Disque"
        case .it: return "Disco"
        case .pt: return "Disco"
        case .uk: return "Диск"
        case .cs: return "Disk"
        case .sk: return "Disk"
        case .nl: return "Schijf"
        case .ru: return "Диск"
        }
    }
    var uptime: String { return "Uptime" }
    
    var guestModeRequiresConnection: String {
        switch self {
        case .pl: return "Ta sekcja wymaga połączenia z serwerem."
        case .en, .system: return "This section requires a connection to a server."
        case .de: return "Dieser Abschnitt erfordert eine Verbindung zu einem Server."
        case .es: return "Esta sección requiere una conexión a un servidor."
        case .fr: return "Cette section nécessite une connexion à un serveur."
        case .it: return "Questa sezione richiede una connessione a un server."
        case .pt: return "Esta seção requer uma conexão a um servidor."
        case .uk: return "Цей розділ вимагає підключення до сервера."
        case .cs: return "Tato sekce vyžaduje připojení k serveru."
        case .sk: return "Táto sekcia vyžaduje pripojenie k serveru."
        case .nl: return "Dit gedeelte vereist een verbinding met een server."
        case .ru: return "Этот раздел требует подключения к серверу."
        }
    }
}

// MARK: - Section 2: ContentView
struct ContentView: View {
    @EnvironmentObject var appSession: SSHAppSession
    @AppStorage("appLanguage") private var appLanguage = "system"
    private var lang: AppLanguage { AppLanguage(rawValue: appLanguage) ?? .system }
    
    var body: some View {
        if appSession.servers.isEmpty && !appSession.isGuestMode {
            GuestAccessView(lang: lang)
        } else {
            MainTabView(lang: lang)
        }
    }
}

// MARK: - Section 3: GuestAccessView
struct GuestAccessView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "terminal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            VStack(spacing: 10) {
                Text("SSH Mobile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(lang.guestModeMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    appSession.enterGuestMode()
                }) {
                    Text(lang.continueAsGuest)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Section 4: MainTabView
struct MainTabView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ServersView(lang: lang)
                .tabItem {
                    Label(lang.tabServers, systemImage: "server.rack")
                }
                .tag(0)
            
            TerminalTabsView(lang: lang)
                .tabItem {
                    Label(lang.tabTerminal, systemImage: "terminal")
                }
                .tag(1)
            
            SFTPView(lang: lang)
                .tabItem {
                    Label(lang.tabFiles, systemImage: "folder")
                }
                .tag(2)
            
            SnippetsView(lang: lang)
                .tabItem {
                    Label(lang.tabSnippets, systemImage: "bolt")
                }
                .tag(3)
            
            SettingsView(lang: lang)
                .tabItem {
                    Label(lang.tabSettings, systemImage: "gear")
                }
                .tag(4)
        }
    }
}

// MARK: - Section 5: ServersView
struct ServersView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage
    @State private var showingAddServer = false
    @State private var showingAddGroup = false
    @State private var serverToEdit: SSHServer?

    var body: some View {
        NavigationStack {
            List {
                if appSession.servers.isEmpty {
                    Text(lang.noServers)
                        .foregroundColor(.secondary)
                        .listRowBackground(Color.clear)
                } else {
                    groupedContent
                    ungroupedContent
                }
            }
            .navigationTitle(lang.tabServers)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddServer = true }) {
                            Label(lang.addServer, systemImage: "server.rack")
                        }
                        Button(action: { showingAddGroup = true }) {
                            Label(lang.addGroup, systemImage: "folder.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddServer) {
                AddEditServerView(lang: lang, serverToEdit: nil)
            }
            .sheet(item: $serverToEdit) { server in
                AddEditServerView(lang: lang, serverToEdit: server)
            }
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView(lang: lang)
            }
        }
    }

    @ViewBuilder
    private var groupedContent: some View {
        ForEach(appSession.groups) { group in
            DisclosureGroup(
                isExpanded: Binding(
                    get: { group.isExpanded },
                    set: { _ in appSession.toggleGroupExpanded(group) }
                )
            ) {
                ForEach(appSession.servers(inGroup: group.id)) { server in
                    serverRow(server)
                }
            } label: {
                HStack {
                    Circle()
                        .fill(Color(hex: group.colorHex) ?? .blue)
                        .frame(width: 10, height: 10)
                    Text(group.name).font(.headline)
                }
            }
        }
    }

    @ViewBuilder
    private var ungroupedContent: some View {
        let ungrouped = appSession.ungroupedServers()
        if !ungrouped.isEmpty {
            Section(header: Text("Inne")) {
                ForEach(ungrouped) { server in
                    serverRow(server)
                }
            }
        }
    }

    private func serverRow(_ server: SSHServer) -> some View {
        NavigationLink(destination: ServerDetailView(server: server, lang: lang)) {
            ServerRow(server: server)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                appSession.deleteServer(server)
            } label: {
                Label(lang.delete, systemImage: "trash")
            }
        }
        .contextMenu {
            Button { serverToEdit = server } label: {
                Label(lang.edit, systemImage: "pencil")
            }
            Button(role: .destructive) { appSession.deleteServer(server) } label: {
                Label(lang.delete, systemImage: "trash")
            }
        }
    }
}


// MARK: - Section 6: ServerRow
struct ServerRow: View {
    @EnvironmentObject var appSession: SSHAppSession
    let server: SSHServer
    
    var body: some View {
        HStack {
            Image(systemName: server.sfxIconName)
                .foregroundColor(Color(hex: server.colorHex) ?? .blue)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                Text("\(server.host):\(server.port)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if appSession.activeSessions.contains(where: { $0.server.id == server.id }) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Section 7: ServerDetailView
struct ServerDetailView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let server: SSHServer
    let lang: AppLanguage
    @State private var showingConnectSheet = false
    @State private var serverToEdit: SSHServer?
    
    var isConnected: Bool {
        appSession.activeSessions.contains(where: { $0.server.id == server.id })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: server.sfxIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(server.colorHex ?? "007AFF"))
                
                Text(server.name)
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(title: lang.hostname, value: server.host)
                    DetailRow(title: lang.port, value: "\(server.port)")
                    DetailRow(title: lang.username, value: server.username)
                    DetailRow(title: lang.authMethod, value: server.authMethod == .password ? lang.password : lang.sshKeys)
                    if !server.notes.isEmpty {
                        DetailRow(title: lang.notes, value: server.notes)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                
                if isConnected {
                    ResourceStatsCard(lang: lang) // Example placeholder without real data injection
                        .padding(.vertical)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            appSession.selectedSessionId = appSession.activeSessions.first(where: { $0.server.id == server.id })?.id
                            // Navigation would be handled via tab change in a full implementation, skipping for brevity
                        }) {
                            Label(lang.tabTerminal, systemImage: "terminal")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            // Switch to SFTP tab logic
                        }) {
                            Label(lang.tabFiles, systemImage: "folder")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    Button(action: {
                        showingConnectSheet = true
                    }) {
                        Text(lang.connect)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle(server.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { serverToEdit = server }) {
                        Label(lang.edit, systemImage: "pencil")
                    }
                    Button(role: .destructive, action: {
                        appSession.deleteServer(server)
                    }) {
                        Label(lang.delete, systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingConnectSheet) {
            ConnectSheetView(server: server, lang: lang)
        }
        .sheet(item: $serverToEdit) { srv in
            AddEditServerView(lang: lang, serverToEdit: srv)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

// MARK: - Section 8: ConnectSheetView
struct ConnectSheetView: View {
    @EnvironmentObject var appSession: SSHAppSession
    @Environment(\.dismiss) var dismiss
    let server: SSHServer
    let lang: AppLanguage
    
    @State private var password = ""
    @State private var selectedKey = ""
    @State private var isConnecting = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(lang.authMethod)) {
                    if server.authMethod == .password {
                        SecureField(lang.password, text: $password)
                        // In real implementation: Add biometric logic here
                    } else {
                        Picker(lang.sshKeys, selection: $selectedKey) {
                            Text("Default Key").tag("default")
                            // Real impl: Foreach on SSHKeychain.allPrivateKeyNames()
                        }
                    }
                }
                
                Button(action: connect) {
                    HStack {
                        Spacer()
                        if isConnecting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text(lang.connect)
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(isConnecting || (server.authMethod == .password && password.isEmpty))
            }
            .navigationTitle(lang.connect)
            .navigationBarItems(leading: Button(lang.cancel) { dismiss() })
        }
    }
    
    func connect() {
        isConnecting = true
        Task {
            // Simulate connection delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            DispatchQueue.main.async {
                appSession.openSession(for: server)
                dismiss()
            }
        }
    }
}

// MARK: - Section 9: AddEditServerView
struct AddEditServerView: View {
    @EnvironmentObject var appSession: SSHAppSession
    @Environment(\.dismiss) var dismiss
    let lang: AppLanguage
    let serverToEdit: SSHServer?
    
    @State private var name = ""
    @State private var host = ""
    @State private var port = "22"
    @State private var username = ""
    @State private var authMethod: SSHAuthMethod = .password
    @State private var password = ""
    @State private var selectedKey = ""
    @State private var selectedGroupId: UUID?
    @State private var iconName = "server.rack"
    @State private var colorHex = "007AFF"
    @State private var notes = ""
    
    let icons = ["server.rack", "desktopcomputer", "laptopcomputer", "display", "externaldrive", "cloud", "network"]
    let colors = ["007AFF", "34C759", "FF3B30", "FF9500", "AF52DE", "8E8E93"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Server Info")) {
                    TextField(lang.serverName, text: $name)
                    TextField(lang.hostname, text: $host)
                    TextField(lang.port, text: $port)
                        .keyboardType(.numberPad)
                    TextField(lang.username, text: $username)
                }
                
                Section(header: Text(lang.authMethod)) {
                    Picker(lang.authMethod, selection: $authMethod) {
                        Text(lang.password).tag(SSHAuthMethod.password)
                        Text(lang.sshKeys).tag(SSHAuthMethod.privateKey)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if authMethod == .password {
                        SecureField(lang.password, text: $password)
                    } else {
                        Picker(lang.sshKeys, selection: $selectedKey) {
                            Text("Select Key").tag("")
                        }
                    }
                }
                
                Section(header: Text(lang.appearance)) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                        }
                    }
                    Picker("Color", selection: $colorHex) {
                        ForEach(colors, id: \.self) { color in
                            Circle().fill(Color(hex: color) ?? .blue).tag(color)
                        }
                    }
                }
                
                Section(header: Text(lang.notes)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(serverToEdit == nil ? lang.addServer : lang.editServer)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(lang.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(lang.save) { save() }
                        .disabled(name.isEmpty || host.isEmpty || username.isEmpty)
                }
            }
            .onAppear {
                if let server = serverToEdit {
                    name = server.name
                    host = server.host
                    port = "\(server.port)"
                    username = server.username
                    authMethod = server.authMethod
                    iconName = server.sfxIconName
                    colorHex = server.colorHex
                    notes = server.notes
                }
            }
        }
    }
    
    func save() {
        let server = SSHServer(
            id: serverToEdit?.id ?? UUID(),
            name: name,
            host: host,
            port: Int(port) ?? 22,
            username: username,
            authMethod: authMethod,
            groupId: selectedGroupId,
            sfxIconName: iconName,
            colorHex: colorHex,
            notes: notes
        )
        if authMethod == .password && !password.isEmpty {
            SSHKeychain.savePassword(password, for: server.id)
        }
        if serverToEdit != nil {
            appSession.updateServer(server)
        } else {
            appSession.addServer(server)
        }
        dismiss()
    }

}

// MARK: - Section 10: AddGroupView
struct AddGroupView: View {
    @EnvironmentObject var appSession: SSHAppSession
    @Environment(\.dismiss) var dismiss
    let lang: AppLanguage
    
    @State private var name = ""
    @State private var colorHex = "007AFF"
    let colors = ["007AFF", "34C759", "FF3B30", "FF9500", "AF52DE", "8E8E93"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Group Name", text: $name)
                    Picker("Color", selection: $colorHex) {
                        ForEach(colors, id: \.self) { color in
                            Circle().fill(Color(hex: color) ?? .blue).tag(color)
                        }
                    }
                }
            }
            .navigationTitle(lang.addGroup)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(lang.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(lang.save) {
                        let group = SSHServerGroup(name: name, colorHex: colorHex)
                        appSession.addGroup(group)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Section 11: TerminalTabsView
struct TerminalTabsView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if appSession.activeSessions.isEmpty {
                    emptyState
                } else {
                    tabStrip
                    terminalArea
                }
            }
            .navigationTitle(lang.tabTerminal)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "terminal")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(lang.noActiveSessions)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    private var tabStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(appSession.activeSessions) { session in
                    sessionTab(for: session)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 6)
        .background(Color(UIColor.secondarySystemBackground))
    }

    private func sessionTab(for session: SSHActiveSession) -> some View {
        let isSelected = appSession.selectedSessionId == session.id
        return Button(action: { appSession.selectedSessionId = session.id }) {
            HStack(spacing: 6) {
                Text(session.server.name)
                    .font(.subheadline)
                Button(action: { appSession.closeSession(session) }) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var terminalArea: some View {
        if let session = appSession.activeSessions.first(where: { $0.id == appSession.selectedSessionId }) {
            TerminalSessionView(lang: lang, server: session.server)
        } else if let first = appSession.activeSessions.first {
            TerminalSessionView(lang: lang, server: first.server)
        } else {
            Spacer()
        }
    }
}

// MARK: - Section 12: TerminalSessionView
struct TerminalSessionView: View {
    let lang: AppLanguage
    let server: SSHServer
    @StateObject private var terminal: SSHTerminal
    @State private var commandInput = ""
    
    init(lang: AppLanguage, server: SSHServer) {
        self.lang = lang
        self.server = server
        self._terminal = StateObject(wrappedValue: SSHTerminal(server: server))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .fill(terminal.isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                Text(terminal.statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: { terminal.clearOutput() }) {
                    Image(systemName: "trash")
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(terminal.lines) { line in
                            TerminalLineView(line: line)
                                .id(line.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: terminal.lines.count) {
                    if let last = terminal.lines.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(currentScheme.backgroundColor)
            
            HStack {
                TextField(lang.sendCommand, text: $commandInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onSubmit {
                        sendCommand()
                    }
                
                Button(action: sendCommand) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(commandInput.isEmpty || !terminal.isConnected)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
        }
        .onAppear {
            if !terminal.isConnected && !terminal.isConnecting {
                if server.authMethod == .privateKey {
                    let key = SSHKeychain.allPrivateKeyNames().first ?? "default"
                    Task {
                        await terminal.connectWithKey(keyName: key)
                    }
                } else if let pwd = SSHKeychain.loadPassword(for: server.id) {
                    Task {
                        await terminal.connect(password: pwd)
                    }
                }
            }
        }
    }

    @AppStorage("terminalColorScheme") private var terminalColorScheme = "standard"
    private var currentScheme: TerminalColorScheme {
        TerminalColorScheme(rawValue: terminalColorScheme) ?? .standard
    }

    private func sendCommand() {
        let cmd = commandInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cmd.isEmpty else { return }
        commandInput = ""
        Task {
            await terminal.sendCommand(cmd)
        }
    }
}

// MARK: - Section 13: TerminalLineView
struct TerminalLineView: View {
    let line: TerminalLine
    @AppStorage("terminalFontSize") private var fontSize = 12.0
    @AppStorage("terminalColorScheme") private var terminalColorScheme = "standard"
    
    private var currentScheme: TerminalColorScheme {
        TerminalColorScheme(rawValue: terminalColorScheme) ?? .standard
    }

    var body: some View {
        Text(line.content)
            .font(.custom("Menlo", size: fontSize))
            .foregroundColor(line.isError ? .red : (line.isCommand ? currentScheme.promptColor : currentScheme.textColor))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


// MARK: - Section 14: SFTPView
struct SFTPView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage

    var body: some View {
        NavigationStack {
            if let session = appSession.activeSessions.first {
                SFTPBrowserView(lang: lang, server: session.server)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "folder.badge.questionmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text(lang.noActiveSessions)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .navigationTitle(lang.tabFiles)
            }
        }
    }
}

// MARK: - Section 15: SFTPBrowserView
struct SFTPBrowserView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage
    @StateObject private var sftpManager: SFTPManager
    @State private var showingNewFolder = false
    @State private var newFolderName = ""
    @State private var selectedItem: SFTPItem?

    init(lang: AppLanguage, server: SSHServer) {
        self.lang = lang
        self._sftpManager = StateObject(wrappedValue: SFTPManager(server: server))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Breadcrumb bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(sftpManager.breadcrumbs) { crumb in
                        Button(crumb.name) {
                            Task { await sftpManager.navigateTo(path: crumb.path) }
                        }
                        .font(.caption)
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                        if crumb.path != sftpManager.currentPath {
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
            }
            .background(Color(UIColor.secondarySystemBackground))

            if sftpManager.isLoading {
                ProgressView().padding()
                Spacer()
            } else {
                List {
                    ForEach(sftpManager.items) { item in
                        SFTPFileRow(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if item.isDirectory {
                                    Task { await sftpManager.navigateTo(path: item.path) }
                                } else {
                                    selectedItem = item
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task { await sftpManager.deleteItem(item) }
                                } label: {
                                    Label(lang.delete, systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(sftpManager.currentPath == "/" ? lang.tabFiles : (sftpManager.currentPath as NSString).lastPathComponent)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showingNewFolder = true }) {
                    Image(systemName: "folder.badge.plus")
                }
                Button(action: { Task { await sftpManager.refresh() } }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if sftpManager.currentPath != "/" {
                    Button(action: { Task { await sftpManager.navigateToParent() } }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .alert(lang.newFolder, isPresented: $showingNewFolder) {
            TextField(lang.folderName, text: $newFolderName)
            Button(lang.cancel, role: .cancel) { newFolderName = "" }
            Button(lang.save) {
                Task { await sftpManager.createFolder(name: newFolderName); newFolderName = "" }
            }
        }
        .sheet(item: $selectedItem) { item in
            FileViewerView(item: item, sftpManager: sftpManager, lang: lang)
        }
        .onAppear {
            if !sftpManager.isConnected {
                if let password = SSHKeychain.loadPassword(for: sftpManager.server.id) {
                    Task { await sftpManager.connect(password: password) }
                }
            }
        }
    }

}

// MARK: - Section 16: SFTPFileRow
struct SFTPFileRow: View {
    let item: SFTPItem
    
    var body: some View {
        HStack {
            Image(systemName: item.isDirectory ? "folder.fill" : "doc.fill")
                .foregroundColor(item.isDirectory ? .blue : .gray)
            VStack(alignment: .leading) {
                Text(item.name)
                Text("\(item.size) bytes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Section 17: FileViewerView
struct FileViewerView: View {
    let item: SFTPItem
    @ObservedObject var sftpManager: SFTPManager
    let lang: AppLanguage
    @Environment(\.dismiss) private var dismiss

    @State private var content: String = ""
    @State private var isLoading: Bool = true
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?
    @State private var isTextFile: Bool = true

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else if !isTextFile {
                    VStack(spacing: 12) {
                        Image(systemName: item.iconName)
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text(item.name)
                            .font(.headline)
                        Text(item.displaySize)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TextEditor(text: $content)
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(lang.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isTextFile && !isLoading {
                        Button(action: saveFile) {
                            if isSaving {
                                ProgressView()
                            } else {
                                Text(lang.save)
                                    .bold()
                            }
                        }
                        .disabled(isSaving)
                    }
                }
            }
            .task {
                await loadFile()
            }
        }
    }

    private func loadFile() async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await sftpManager.readFile(item)
            if let text = String(data: data, encoding: .utf8) {
                content = text
                isTextFile = true
            } else if let text = String(data: data, encoding: .ascii) {
                content = text
                isTextFile = true
            } else {
                isTextFile = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func saveFile() {
        guard let data = content.data(using: .utf8) else { return }
        isSaving = true
        Task {
            do {
                try await sftpManager.writeFile(data: data, atPath: item.path)
                await MainActor.run {
                    isSaving = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}


// MARK: - Section 18: SnippetsView
struct SnippetsView: View {
    @EnvironmentObject var appSession: SSHAppSession
    let lang: AppLanguage
    @State private var showingAddSnippet = false
    
    var body: some View {
        NavigationStack {
            List {
                if appSession.snippets.isEmpty {
                    Text(lang.noSnippets)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(appSession.snippets) { snippet in
                        SnippetRow(snippet: snippet, lang: lang)
                            .swipeActions {
                                Button(role: .destructive) {
                                    appSession.deleteSnippet(snippet)
                                } label: {
                                    Label(lang.delete, systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle(lang.tabSnippets)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSnippet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSnippet) {
                AddEditSnippetView(lang: lang)
            }
        }
    }
}

// MARK: - Section 19: SnippetRow
struct SnippetRow: View {
    let snippet: SSHSnippet
    let lang: AppLanguage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.yellow)
                Text(snippet.name)
                    .font(.headline)
            }
            Text(snippet.command)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            if !snippet.description.isEmpty {
                Text(snippet.description)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Section 20: AddEditSnippetView
struct AddEditSnippetView: View {
    @EnvironmentObject var appSession: SSHAppSession
    @Environment(\.dismiss) var dismiss
    let lang: AppLanguage
    
    @State private var name = ""
    @State private var command = ""
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(lang.snippetName, text: $name)
                TextEditor(text: $command)
                    .frame(height: 100)
                TextField(lang.snippetDescription, text: $description)
            }
            .navigationTitle(lang.addSnippet)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(lang.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(lang.save) {
                        let snippet = SSHSnippet(name: name, command: command, description: description)
                        appSession.addSnippet(snippet)
                        dismiss()
                    }
                    .disabled(name.isEmpty || command.isEmpty)
                }
            }
        }
    }
}

// MARK: - Section 21: SettingsView
struct SettingsView: View {
    let lang: AppLanguage
    @AppStorage("appLanguage") private var appLanguage = "system"
    @AppStorage("appearanceMode") private var appearanceMode = "system"
    @AppStorage("terminalFontSize") private var terminalFontSize = 12.0
    @AppStorage("terminalColorScheme") private var terminalColorScheme = "standard"

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(lang.appearance)) {
                    Picker(lang.appTheme, selection: $appearanceMode) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    Picker(lang.terminalTheme, selection: $terminalColorScheme) {
                        ForEach(TerminalColorScheme.allCases) { scheme in
                            Text(scheme.displayName).tag(scheme.rawValue)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(lang.fontSize): \(Int(terminalFontSize)) pt")
                        Slider(value: $terminalFontSize, in: 9...24, step: 1)
                    }
                }
                
                Section(header: Text(lang.security)) {
                    HStack {
                        Label(SSHKeychain.biometryTypeName, systemImage: "faceid")
                        Spacer()
                        Text(SSHKeychain.isBiometryAvailable ? "Dostępne" : "Niedostępne")
                            .foregroundColor(.secondary)
                    }
                    NavigationLink(destination: SSHKeysView(lang: lang)) {
                        Label(lang.sshKeys, systemImage: "key.fill")
                    }
                }

                Section(header: Text(lang.language)) {
                    Picker(lang.language, selection: $appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language.rawValue)
                        }
                    }
                }
                
                Section(header: Text(lang.about)) {
                    HStack {
                        Text(lang.version)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(lang.tabSettings)
        }
    }
}

// MARK: - Section 22: SSHKeysView
struct SSHKeysView: View {
    let lang: AppLanguage
    @State private var keys: [String] = []
    @State private var showingAddKey = false
    @State private var newKeyName = ""
    @State private var newKeyContent = ""

    var body: some View {
        List {
            if keys.isEmpty {
                Text(lang.sshKeys)
                    .foregroundColor(.secondary)
            } else {
                ForEach(keys, id: \.self) { key in
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.accentColor)
                        Text(key)
                            .font(.headline)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            SSHKeychain.deletePrivateKey(name: key)
                            refreshKeys()
                        } label: {
                            Label(lang.delete, systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle(lang.sshKeys)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddKey = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddKey) {
            NavigationStack {
                Form {
                    TextField("Nazwa klucza", text: $newKeyName)
                    TextEditor(text: $newKeyContent)
                        .frame(height: 150)
                }
                .navigationTitle(lang.importKey)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(lang.cancel) {
                            newKeyName = ""
                            newKeyContent = ""
                            showingAddKey = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(lang.save) {
                            let name = newKeyName.trimmingCharacters(in: .whitespacesAndNewlines)
                            let content = newKeyContent.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !name.isEmpty && !content.isEmpty {
                                SSHKeychain.savePrivateKey(content, name: name)
                                refreshKeys()
                                newKeyName = ""
                                newKeyContent = ""
                                showingAddKey = false
                            }
                        }
                        .disabled(newKeyName.isEmpty || newKeyContent.isEmpty)
                    }
                }
            }
        }
        .onAppear {
            refreshKeys()
        }
    }

    private func refreshKeys() {
        keys = SSHKeychain.allPrivateKeyNames()
    }
}

// MARK: - Section 23: ResourceStatsCard
struct ResourceStatsCard: View {
    let lang: AppLanguage
    var stats: ServerResourceStats? = nil

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(lang.cpu)
                Spacer()
                if let stats {
                    Text(stats.cpuText).font(.caption).foregroundColor(.secondary)
                }
                ProgressView(value: stats != nil ? stats!.cpuPercent / 100.0 : 0.2)
                    .frame(width: 100)
            }
            HStack {
                Text(lang.memory)
                Spacer()
                if let stats {
                    Text(stats.memText).font(.caption).foregroundColor(.secondary)
                }
                ProgressView(value: stats != nil ? stats!.memPercent : 0.4)
                    .frame(width: 100)
            }
            HStack {
                Text(lang.disk)
                Spacer()
                if let stats {
                    Text(stats.diskText).font(.caption).foregroundColor(.secondary)
                }
                ProgressView(value: stats != nil ? stats!.diskPercent : 0.3)
                    .frame(width: 100)
            }
            if let stats {
                HStack {
                    Text("Uptime")
                    Spacer()
                    Text(stats.uptimeText).font(.caption).foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}



