class Setting < ApplicationRecord
  THEMES = {
    "rustico"           => { name: "Rustico",           bg: "#F7F1DE", primary: "#9D6638", secondary: "#B0BA99", dark: "#4E220F", font: "Lora" },
    "pastell_cafe"      => { name: "Pastell Café",      bg: "#FDF4D2", primary: "#A290B7", secondary: "#B0CDE6", dark: "#946D6D", font: "Quicksand" },
    "trattoria_rosso"   => { name: "Trattoria Rosso",   bg: "#FFF6F6", primary: "#DB1A1A", secondary: "#8CC7C4", dark: "#2C687B", font: "Playfair Display" },
    "feuerofen"         => { name: "Feuerofen",         bg: "#F6F1E9", primary: "#FF8400", secondary: "#FFD93D", dark: "#4F200D", font: "Poppins" },
    "goldkorn"          => { name: "Goldkorn",          bg: "#FCEFCB", primary: "#E9A319", secondary: "#FAD59A", dark: "#A86523", font: "Cormorant Garamond" },
    "bio_garten"        => { name: "Bio Garten",        bg: "#FDF6ED", primary: "#A1BC98", secondary: "#DCCFC0", dark: "#778873", font: "Nunito" },
    "steakhouse_noir"   => { name: "Steakhouse Noir",   bg: "#E1DCC9", primary: "#412D15", secondary: "#1F150C", dark: "#000000", font: "Cinzel" },
    "kaffeehaus"        => { name: "Kaffeehaus",        bg: "#FFF8F0", primary: "#C08552", secondary: "#8C5A3C", dark: "#4B2E2B", font: "Josefin Sans" },
    "meeresblau"        => { name: "Meeresblau",        bg: "#E3F2FD", primary: "#2196F3", secondary: "#90CAF9", dark: "#0D47A1", font: "Raleway" },
    "feuerglut"         => { name: "Feuerglut",         bg: "#FBEAE6", primary: "#C3110C", secondary: "#E6501B", dark: "#280905", font: "Oswald" },
    "nebelstein"        => { name: "Nebelstein",        bg: "#E1F1DD", primary: "#87A7B3", secondary: "#CDC7BE", dark: "#766161", font: "Karla" },
    "waldhuette"        => { name: "Waldhütte",         bg: "#E4D6A9", primary: "#995F2F", secondary: "#978F66", dark: "#622B14", font: "Merriweather" },
    "mitternachtsbeere" => { name: "Mitternachtsbeere", bg: "#F3F4F4", primary: "#853953", secondary: "#612D53", dark: "#2C2C2C", font: "Marcellus" },
    # FIX: "dark" war fälschlich D5DBB3 (hell) – jetzt korrekt der dunkelste Ton der Palette
    "senffeld"          => { name: "Senffeld",          bg: "#FFF8D9", primary: "#EBA83A", secondary: "#D5DBB3", dark: "#BB371A", font: "Comfortaa" },
    # FIX: "dark" war fälschlich FBE6C2 (hell) – jetzt korrekt das dunkle Waldgrün
    "wiesengruen"       => { name: "Wiesengrün",        bg: "#FFF8CF", primary: "#76C457", secondary: "#FBE6C2", dark: "#2A7C13", font: "Fredoka" },
    # FIX: "dark" war fälschlich FFD758 (hell) – jetzt korrekt das dunkle Petrol
    "lagune"            => { name: "Lagune",            bg: "#FCE59A", primary: "#2BBBD7", secondary: "#FFD758", dark: "#218DAE", font: "Baloo 2" },
    "bernstein_bar"     => { name: "Bernstein Bar",     bg: "#F7F7F7", primary: "#854836", secondary: "#FFB22C", dark: "#000000", font: "Bebas Neue" },
    # FIX: Palette hatte GAR keinen dunklen Ton (alles Pastell) – dunkles Beeren-Rot ergänzt,
    # Font geändert wie gewünscht
    "fruchteis"         => { name: "Fruchteis",         bg: "#EEF8CD", primary: "#FF9D9D", secondary: "#FFC5AA", dark: "#B23A48", font: "Bubblegum Sans" },
    "kintsugi"          => { name: "Kintsugi",          bg: "#F5F1E8", primary: "#D4AF37", secondary: "#8B6914", dark: "#0D0D0D", font: "Spectral" }
  }.freeze

  def self.current
    first_or_create!(theme: "rustico")
  end

  def theme_data
    base = THEMES.fetch(theme, THEMES["rustico"])
    base.merge(
      primary_text: self.class.contrast_text(base[:primary]),
      secondary_text: self.class.contrast_text(base[:secondary]),
      # Für Links/Outline-Buttons: ist "primary" sehr hell (z.B. Pastelltöne),
      # nutzen wir stattdessen die dunkle Theme-Farbe, damit Text auf hellem
      # Hintergrund immer lesbar bleibt.
      link_color: self.class.luminance(base[:primary]) > 190 ? base[:dark] : base[:primary]
    )
  end

  # Berechnet die "wahrgenommene Helligkeit" einer Hex-Farbe (0 = schwarz, 255 = weiss).
  def self.luminance(hex)
    r, g, b = hex.delete("#").scan(/../).map { |c| c.to_i(16) }
    (0.299 * r) + (0.587 * g) + (0.114 * b)
  end

  # Wählt automatisch dunklen oder hellen Text, je nachdem wie hell der
  # Hintergrund ist – so bleibt Text auf JEDER Preset-Farbe lesbar, auch bei
  # zukünftig hinzugefügten Presets, ohne dass wir das manuell festlegen müssen.
  def self.contrast_text(hex)
    luminance(hex) > 150 ? "#212529" : "#FFFFFF"
  end
end