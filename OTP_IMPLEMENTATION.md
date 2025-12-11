# Email OTP Authentication Implementation

## Overview

Replaced the problematic deep link email verification flow with a simpler, more reliable Email OTP system.

## Changes Made

### 1. AuthService Updates (`lib/core/services/auth_service.dart`)

- **Modified `signUp` method**: Now uses `signInWithOtp` instead of `signUp` to trigger OTP email
- **Added `verifyOtp` method**: New method to verify the 6-digit code
  ```dart
  Future<String?> verifyOtp({
    required String email,
    required String token,
    required OtpType type,
  })
  ```

### 2. New OTP Verification Screen (`lib/features/auth/presentation/otp_verification_screen.dart`)

Created a fully branded OTP verification screen with:

- **Solar Mode Design**: Stone 100 background, White surface card, Orange primary accents
- **6-digit OTP Input**: Individual digit boxes with auto-focus and auto-advance
- **Auto-submit**: Automatically verifies when all 6 digits are entered
- **Resend Code**: Allows users to request a new OTP
- **Error Handling**: Uses VitaloSnackBar for user-friendly error messages
- **Loading State**: Shows CircularProgressIndicator during verification

#### Key Features:

- Clean, professional UI with proper spacing and typography
- Keyboard-friendly with automatic focus management
- Clear visual feedback with primary color borders on focus
- Backspace support to move between inputs
- Auto-navigation to dashboard on success

### 3. SignUp Screen Updates (`lib/features/auth/presentation/signup_screen.dart`)

- **Removed**: Old `_showVerificationDialog` method and dialog UI
- **Added**: Navigation to OTP screen after successful signup
  ```dart
  context.push('/auth/otp-verification', extra: {
    'email': _emailController.text.trim(),
    'otpType': OtpType.email,
  });
  ```
- **Added Import**: `package:supabase_flutter/supabase_flutter.dart` for OtpType enum

### 4. Router Updates (`lib/core/router.dart`)

- **Added Route**: New `/auth/otp-verification` route
- **Added Import**: OtpVerificationScreen
- **Route Configuration**: Accepts email and otpType parameters via extra

### 5. Main App Cleanup (`lib/main.dart`)

- **Removed**: DeepLinkService import and initialization
- **Cleaned**: Removed deep link listener from VitaloApp build method
- **Result**: Simpler, more maintainable initialization

### 6. DeepLinkService Cleanup (`lib/core/services/deep_link_service.dart`)

- **Marked as TODO**: Service preserved for potential future OAuth deep links
- **Removed**: Unused context reference
- **Cleaned**: Removed go_router import

## User Flow

1. **Sign Up**: User enters email, password, and full name on SignUpScreen
2. **OTP Sent**: System sends 6-digit code to user's email via Supabase
3. **Navigate to OTP Screen**: User is automatically redirected to OtpVerificationScreen
4. **Enter Code**: User types the 6-digit code (auto-submits when complete)
5. **Verification**: System verifies the code with Supabase
6. **Success**: User is logged in and redirected to /dashboard

## Error Handling

All error scenarios are handled with branded VitaloSnackBar notifications:

- **Network errors**: "Network error. Please check your internet connection."
- **Invalid code**: "Verification failed. Please check the code and try again."
- **Expired code**: User can tap "Resend code" to get a new one
- **General errors**: "Verification failed. Please try again."

## Design Specifications

### Colors (Solar Mode)

- Background: `#F5F5F4` (Stone 100)
- Surface: `#FFFFFF` (White)
- Primary: `#F97316` (Solar Orange)
- Text Primary: `#1C1917` (Stone 900)
- Text Secondary: `#78716C` (Stone 500)
- Outline: `#D6D3D1` (Stone 300)

### Spacing & Sizing

- Card padding: 32px
- OTP digit box: 48x56px
- Border radius: 8px (inputs), 12px (card)
- Button: StadiumBorder (pill shape), 16px vertical padding

### Typography

- Heading: headlineSmall, bold, onBackground color
- Subtext: bodyMedium, onSurfaceVariant color
- Email: bodyMedium, bold, onBackground color
- Button: 16px, semibold (w600)

## Testing Checklist

- [ ] Sign up with new email - should receive OTP code
- [ ] Enter correct 6-digit code - should log in and redirect to dashboard
- [ ] Enter incorrect code - should show error and clear inputs
- [ ] Test resend code functionality
- [ ] Test keyboard navigation between inputs
- [ ] Test backspace navigation
- [ ] Test loading states during verification
- [ ] Verify auto-focus on first input
- [ ] Verify auto-submit on 6th digit
- [ ] Test error messages display correctly
- [ ] Verify dark mode support

## Supabase Configuration

Make sure your Supabase project is configured for Email OTP:

1. Go to Authentication > Providers > Email
2. Enable "Email OTP" option
3. Optionally customize OTP email template
4. Set OTP expiration time (default: 60 minutes)

## Future Enhancements

- [ ] Add OTP expiration timer (e.g., "Code expires in 5:00")
- [ ] Add "Didn't receive code?" help text
- [ ] Rate limiting for resend code
- [ ] Analytics tracking for OTP flow
- [ ] Support for SMS OTP as alternative
- [ ] Remember device option after verification

## Migration Notes

### What Was Removed

- Deep link email verification flow
- `_showVerificationDialog` in SignUpScreen
- DeepLinkService initialization in main.dart
- Context reference in DeepLinkService

### What Was Kept

- Deep link manifest configuration (for future OAuth)
- DeepLinkService file (marked as TODO for OAuth)
- All existing auth methods (login, OAuth, reset password)
- VitaloSnackBar for consistent error messaging

### Breaking Changes

None - this is a complete refactor of the verification flow but doesn't affect existing login or other auth features.

## Troubleshooting

### User Not Receiving OTP Email

1. Check Supabase Auth settings
2. Verify email provider is configured
3. Check spam/junk folder
4. Ensure internet permissions in AndroidManifest.xml

### OTP Verification Fails

1. Verify Supabase URL and anon key are correct
2. Check network connectivity
3. Ensure OTP hasn't expired
4. Try resending code

### Navigation Issues

1. Verify router configuration includes /auth/otp-verification
2. Check that context.push is called with correct parameters
3. Ensure OtpVerificationScreen import in router.dart

## Dependencies

No new dependencies added. Uses existing packages:

- `supabase_flutter`: For authentication and OTP
- `go_router`: For navigation
- `flutter/material.dart`: For UI components
- `flutter/services.dart`: For input formatting

## Files Modified

1. `lib/core/services/auth_service.dart` - Added verifyOtp, modified signUp
2. `lib/features/auth/presentation/otp_verification_screen.dart` - NEW FILE
3. `lib/features/auth/presentation/signup_screen.dart` - Navigation update
4. `lib/core/router.dart` - Added OTP route
5. `lib/main.dart` - Removed deep link service
6. `lib/core/services/deep_link_service.dart` - Cleanup

## Commit Message Suggestion

```
feat: Replace deep link email verification with OTP flow

- Add AuthService.verifyOtp method for OTP verification
- Create branded OtpVerificationScreen with 6-digit input
- Update SignUpScreen to navigate to OTP screen
- Remove problematic deep link verification flow
- Clean up DeepLinkService initialization
- Improve error handling with VitaloSnackBar

BREAKING CHANGE: Email verification now uses OTP instead of magic links
```
