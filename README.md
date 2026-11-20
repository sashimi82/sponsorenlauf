# Sponsorenlauf – Rundenzähler (Unihockey Tösstal)

Web-App zum Zählen der Runden und Bonus-Meter am Sponsorenlauf. Läuft auf jedem Handy im Browser,
alle Geräte schreiben in dieselbe Supabase-Datenbank und sehen Änderungen live.

## Einrichten
1. **Supabase:** Die Tabellen `slauf_players`, `slauf_laps`, `slauf_config` liegen im Projekt *praxisna*
   (Script: `setup.sql`). URL und publishable Key stehen oben in `index.html`.
3. **GitHub Pages:** Settings › Pages › Source «Deploy from a branch», Branch `main`, Ordner `/ (root)`.

## Bedienung
- **Zählen:** Spieler:in antippen, dann Loch auf der Torwand (180 / 90 / 60 / 30 m Bonus) oder «+1 Runde · kein Treffer».
- **Rangliste:** Runden gesamt = (gelaufene Runden × Rundenlänge + Bonus-Meter) ÷ Rundenlänge, abgerundet.
  Download als PDF und CSV (Excel).
- **Spieler:innen:** erfassen, bearbeiten, löschen; ☆ markiert die eigene Gruppe (pro Gerät).
- Ohne Netz werden Einträge auf dem Gerät gemerkt und automatisch nachgeschickt.
- Tipp: Auf dem Handy «Zum Home-Bildschirm hinzufügen» – dann startet die App wie eine normale App.
- Nach dem Lauf: Daten im Tab Spieler:innen löschen oder in Supabase `delete from slauf_players;` ausführen.
