class Setting < ApplicationRecord
  THEMES = {
    "rustico"         => { name: "Rustico",          bg: "#F7F1DE", primary: "#9D6638", secondary: "#B0BA99", dark: "#4E220F", font: "Lora" },
    "pastell_cafe"    => { name: "Pastell Café",      bg: "#FDF4D2", primary: "#A290B7", secondary: "#B0CDE6", dark: "#946D6D", font: "Quicksand" },
    "trattoria_rosso" => { name: "Trattoria Rosso",   bg: "#FFF6F6", primary: "#DB1A1A", secondary: "#8CC7C4", dark: "#2C687B", font: "Playfair Display" },
    "feuerofen"       => { name: "Feuerofen",         bg: "#F6F1E9", primary: "#FF8400", secondary: "#FFD93D", dark: "#4F200D", font: "Poppins" },
    "goldkorn"        => { name: "Goldkorn",          bg: "#FCEFCB", primary: "#E9A319", secondary: "#FAD59A", dark: "#A86523", font: "Cormorant Garamond" },
    "bio_garten"      => { name: "Bio Garten",        bg: "#FDF6ED", primary: "#A1BC98", secondary: "#DCCFC0", dark: "#778873", font: "Nunito" },
    "steakhouse_noir" => { name: "Steakhouse Noir",   bg: "#E1DCC9", primary: "#412D15", secondary: "#1F150C", dark: "#000000", font: "Cinzel" },
    "kaffeehaus"      => { name: "Kaffeehaus",        bg: "#FFF8F0", primary: "#C08552", secondary: "#8C5A3C", dark: "#4B2E2B", font: "Josefin Sans" },
    "meeresblau"      => { name: "Meeresblau",        bg: "#E3F2FD", primary: "#2196F3", secondary: "#90CAF9", dark: "#0D47A1", font: "Raleway" }
  }.freeze

  # Singleton-Pattern: es gibt genau eine globale Theme-Einstellung für die
  # ganze Applikation (nicht pro Benutzer). first_or_create! legt beim
  # allerersten Zugriff automatisch eine Zeile mit dem Default-Theme an.
  def self.current
    first_or_create!(theme: "rustico")
  end

  def theme_data
    THEMES.fetch(theme, THEMES["rustico"])
  end
end