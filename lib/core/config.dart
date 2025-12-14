/// Centralized app configuration
/// Default values are for LOCAL DEVELOPMENT only.
/// For production, override via --dart-define or CI/CD environment variables.
class AppConfig {
  AppConfig._();

  // ──────────────────────────────────────────────────────────────────────────
  // Supabase
  // ──────────────────────────────────────────────────────────────────────────

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gttouytwcvjcolvbgyhc.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_VZ0nZU5r0oDCtF8PoCKhqA_-g2NQHNf',
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Cloudflare Turnstile (Captcha)
  // ──────────────────────────────────────────────────────────────────────────

  static const turnstileSiteKey = String.fromEnvironment(
    'TURNSTILE_SITE_KEY',
    defaultValue: '0x4AAAAAACGksNbU_nDQoBBz',
  );

  static const turnstileBaseUrl = String.fromEnvironment(
    'TURNSTILE_BASE_URL',
    defaultValue: 'https://cricalgo.com',
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Environment
  // ──────────────────────────────────────────────────────────────────────────

  static const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static bool get isDev => environment == 'dev';
  static bool get isStaging => environment == 'staging';
  static bool get isProd => environment == 'prod';
}
