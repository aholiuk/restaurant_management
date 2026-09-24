# Restaurant Management

Multiuser-Applikation für Modul 223 (BBZBL) – zentrale Plattform für Restaurantbetriebe: Kunden bestellen ohne eigenes Konto (Vor Ort, Abholung oder Lieferung), Mitarbeitende (Service, Küche, Bar, Chef) verwalten die Bestellungen, das Menü und das Personal über eine rollenbasierte Oberfläche.

## Technologie-Stack

- Ruby 3.3.12
- Rails 8.1.3.1
- SQLite (Entwicklung & Test)
- Pundit (Policy-basierte Autorisierung)

## Voraussetzungen

- Ruby 3.3.x (empfohlen: über einen Versionsmanager wie `mise`, `rbenv` oder `rvm`)
- Bundler

## Installation

bundle install
rails db:create
rails db:migrate

## Demo-Daten / erster Chef-Account

Da sich niemand selbst registrieren kann (nur der Chef legt Mitarbeitende an), muss der erste Account manuell erstellt werden:

rails console

```ruby
Employee.create!(name: "Anna Holiuk", email: "anna@restaurant.test", password: "geheim123456", password_confirmation: "geheim123456", role: "manager")
```

## Demo-Konten (Testdaten via Fixtures)

| Rolle   | E-Mail                | Passwort     |
| ------- | --------------------- | ------------ |
| Chef    | anna@restaurant.test  | geheim123456 |
| Service | lisa@restaurant.test  | geheim123456 |
| Küche   | marco@restaurant.test | geheim123456 |
| Bar     | sara@restaurant.test  | geheim123456 |

## Server starten

rails server

- Kundenseite (Speisekarte): `http://localhost:3000/`
- Mitarbeiter-Login: `http://localhost:3000/session/new`

## Tests ausführen

bin/rails test

Testkonzept und Nachweis siehe [`docs/testing.md`](docs/testing.md).
