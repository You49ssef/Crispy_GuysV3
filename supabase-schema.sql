-- Schema Supabase pour Crispy Guys
-- Exécutez ce SQL dans le SQL Editor de votre projet Supabase

-- Activer l'extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table des catégories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des produits (menu items)
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  image_url TEXT,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des compléments (frites, boissons, sauces)
CREATE TABLE complements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  emoji TEXT,
  price DECIMAL(10,2) DEFAULT 0,
  type TEXT DEFAULT 'simple', -- 'simple' ou 'options'
  options JSONB, -- Pour les compléments avec options (ex: boissons)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour améliorer les performances
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_active ON products(active);
CREATE INDEX idx_complements_type ON complements(type);

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour updated_at
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_complements_updated_at BEFORE UPDATE ON complements
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS (Row Level Security) - Activer et configurer
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE complements ENABLE ROW LEVEL SECURITY;

-- Politiques RLS (lecture publique pour tous, écriture restreinte)
CREATE POLICY "Catégories - Lecture publique" ON categories
  FOR SELECT USING (true);

CREATE POLICY "Produits - Lecture publique" ON products
  FOR SELECT USING (true);

CREATE POLICY "Compléments - Lecture publique" ON complements
  FOR SELECT USING (true);

-- Politiques d'écriture (à ajuster selon vos besoins d'authentification)
CREATE POLICY "Catégories - Écriture" ON categories
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Produits - Écriture" ON products
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Compléments - Écriture" ON complements
  FOR ALL USING (true) WITH CHECK (true);

-- Données initiales (optionnel - catégories par défaut)
INSERT INTO categories (name) VALUES 
  ('Tacos'),
  ('Burgers'),
  ('Plats'),
  ('Sandwichs'),
  ('Promotions')
ON CONFLICT DO NOTHING;
