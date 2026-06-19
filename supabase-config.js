// Supabase Configuration
// Remplacez ces valeurs par vos vraies clés Supabase
const SUPABASE_CONFIG = {
  url: 'https://dixparntguicqukyrkyz.supabase.co/rest/v1/', // Ex: https://xyzcompany.supabase.co
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpeHBhcm50Z3VpY3F1a3lya3l6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4MTg4OTEsImV4cCI6MjA5NzM5NDg5MX0.FePmSzeRkdGvUtPTFfvK6ZApo3THTQlVs6pMzbWPpmw', // Clé publique (anon key)
  storageBucket: 'product-images' // Nom du bucket pour les images
};

// Initialisation du client Supabase
const supabase = window.supabase.createClient(
  SUPABASE_CONFIG.url,
  SUPABASE_CONFIG.anonKey
);
