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
  // Google Sign-In
  // ──────────────────────────────────────────────────────────────────────────

  /// Web client ID - Used for serverClientId on both platforms
  /// REQUIRED for Supabase token exchange
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '602124410968-oovj226gimqlvnufce3g7n0l0t4e5d30.apps.googleusercontent.com',
  );

  /// iOS client ID - Used for iOS-specific OAuth
  /// REQUIRED for iOS Info.plist CFBundleURLSchemes
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '602124410968-j668liquqqt1ljlildl99g42akecsrtu.apps.googleusercontent.com',
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
