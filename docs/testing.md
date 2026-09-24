# Testkonzept und Testnachweis

## Testbefehl

Alle Tests ausführen:

bin/rails test

Aktueller Stand: **39 Tests, 104 Assertions, 0 Failures, 0 Errors** (Stand: 24.09.2026).

## Was getestet wurde

### 1. Authentifizierung und Berechtigungen

- Erfolgreicher und fehlgeschlagener Login (falsches Passwort, unbekannte E-Mail)
- Zugriff auf geschützte Seiten ohne Login wird zum Login umgeleitet
- Rollenbasierte Zugriffskontrolle (Pundit): Chef darf Registrierung/Benutzerverwaltung/Menüverwaltung, andere Rollen werden abgewiesen
- **Direkte Requests auf fremde Datensätze:** ein Server-Mitarbeiter kann die Daten eines anderen Mitarbeiters nicht per direktem PATCH-Request ändern; Bar-Mitarbeiter kann eine Bestellung mit reinem Küchen-Artikel nicht per direktem PATCH-Request vorantreiben
- Chef kann sich nicht selbst löschen (Selbstschutz)

Ergebnis: alle Tests grün (`test/controllers/sessions_controller_test.rb`, `registrations_controller_test.rb`, `employees_controller_test.rb`)

### 2. Kernfunktion (zentrale Fachregel: Verfügbarkeit von Menüartikeln)

- **Model-Ebene:** `Order.place!` akzeptiert eine Bestellung bei verfügbarem Artikel, lehnt sie bei ausverkauftem Artikel ab (`MenuItem::SoldOutError`), verhindert bei zwei aufeinanderfolgenden Anfragen für den letzten Artikel die zweite
- **Controller-Ebene:** Checkout über HTTP erstellt bei Erfolg eine Bestellung; bei ausverkauftem Artikel bleibt der Warenkorb erhalten und es erscheint eine Fehlermeldung, keine neue Bestellung wird angelegt
- Statusübergänge (`advance_status!`): gültige Übergänge werden akzeptiert und protokolliert (Aktivitätsprotokoll mit Zeitstempel und Mitarbeiter), ungültige Sprünge werden abgelehnt

Ergebnis: alle Tests grün (`test/models/order_test.rb`, `test/controllers/orders_controller_test.rb`)

### 3. Benutzerprofil

- Eigenes Profil ansehen, Name ändern
- Passwortänderung: schlägt mit falschem aktuellem Passwort fehl, gelingt mit korrektem
- E-Mail-Änderung: wird zunächst nur als "unbestätigt" gespeichert, erst nach Aufruf des Bestätigungslinks aktiv

Ergebnis: alle Tests grün (`test/controllers/profiles_controller_test.rb`)

## Aussagekraft der Tests (Nachweis)

Um zu zeigen, dass die Tests echte Fehler erkennen und nicht nur zufällig grün sind, wurde die zentrale Prüfung in `Order.place!` (Verfügbarkeitsprüfung) testweise auskommentiert:

- **Vorher (mit Fehler):** 32 Tests, 3 Failures (`test_place!_lehnt_einen_ausverkauften_Artikel_ab`, `test_place!_lässt_bei_zwei_Anfragen_für_den_letzten_Artikel_nur_eine_zu`, sowie ein Controller-Test)
- **Nachher (Fehler behoben):** 32 Tests, 0 Failures

Dies bestätigt, dass die Testsuite echte Regressionen der Kernregel zuverlässig erkennt.
