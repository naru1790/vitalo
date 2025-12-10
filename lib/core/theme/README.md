# Vitalo Design System

## Overview

Vitalo uses a feature-first architecture with a centralized design system to ensure consistency across the app.

## Design Principles

- **Intelligent Wellness**: AI-powered, adaptive, evolving
- **Soft Tech Aesthetic**: Warm, organic, human-centered
- **Hope & Growth**: Encouraging, motivational, forward-looking

---

## 🎨 Colors

### Light Theme (Solar Mode)

- **Primary**: Solar Orange `#F97316` - Energy, motivation, vitality
- **Secondary**: Gold `#F59E0B` - Rewards, achievements
- **Background**: Stone 100 `#F5F5F4` - Warm, clean base
- **Surface**: White `#FFFFFF` - Cards, dialogs
- **Text**: Stone 900 `#1C1917` - High contrast

### Dark Theme (Lunar Mode)

- **Primary**: Lunar Indigo `#818CF8` - Calm intelligence
- **Secondary**: Violet `#A78BFA` - Mindfulness
- **Background**: Slate 900 `#0F172A` - Deep, immersive
- **Surface**: Slate 800 `#1E293B` - Cards, dialogs
- **Text**: Slate 50 `#F8FAFC` - High contrast

### Semantic Colors

- **Success**: Emerald `#10B981`
- **Warning**: Gold `#F59E0B`
- **Error**: Rose `#E11D48`
- **Info**: Indigo `#4F46E5`

**Usage**: Import from `app_colors.dart`

```dart
import 'package:vitalo/core/theme/app_colors.dart';
color: AppColors.primary,
```

---

## 📐 Spacing

Based on 4px unit system for consistency.

### Scale

- `xs`: 8px
- `sm`: 12px
- `md`: 16px
- `lg`: 20px
- `xl`: 24px
- `xxl`: 32px
- `xxxl`: 40px
- `huge`: 48px
- `massive`: 56px
- `giant`: 64px

### Component Spacing

- Button height: 60px
- Button radius: 24px
- Card radius: 20px
- Card padding: 20px
- Icon size: 24px
- Page padding: 24px (horizontal), 32px (vertical)
- Max content width: 480px

**Usage**: Import from `app_spacing.dart`

```dart
import 'package:vitalo/core/theme/app_spacing.dart';
padding: EdgeInsets.all(AppSpacing.xl),
```

---

## 🔤 Typography

### Font Families

- **Display/Headings**: Poppins (modern, friendly)
- **Body/Content**: Inter (readable, clean)

### Text Styles

#### Display (Hero Headlines)

- `displayLarge`: 56px, Bold - App logo, major headlines
- `displayMedium`: 45px, Bold - Feature headlines
- `displaySmall`: 36px, SemiBold - Section heroes

#### Headlines (Section Headers)

- `headlineLarge`: 32px, Bold - Page titles
- `headlineMedium`: 28px, SemiBold - Feature sections
- `headlineSmall`: 24px, SemiBold - Card headers

#### Titles (Component Headers)

- `titleLarge`: 22px, SemiBold - Dialog titles
- `titleMedium`: 18px, SemiBold - Card titles
- `titleSmall`: 16px, SemiBold - List headers

#### Body (Content)

- `bodyLarge`: 16px, Regular - Main content
- `bodyMedium`: 14px, Regular - Secondary content
- `bodySmall`: 12px, Regular - Captions

#### Labels (Buttons/Tags)

- `labelLarge`: 18px, Bold - Primary buttons
- `labelMedium`: 14px, SemiBold - Secondary buttons
- `labelSmall`: 12px, SemiBold - Tags, chips

**Usage**: Use theme text styles

```dart
Text(
  'Vitalo',
  style: Theme.of(context).textTheme.displayLarge,
)
```

---

## 🧩 Components

### Buttons

#### Primary Button

Main CTAs, high-priority actions

```dart
VitaloPrimaryButton(
  onPressed: () {},
  label: 'Start Journey',
  icon: Icons.arrow_forward,
  isLoading: false,
)
```

#### Secondary Button

Alternative actions, medium priority

```dart
VitaloSecondaryButton(
  onPressed: () {},
  label: 'Learn More',
  icon: Icons.info_outline,
)
```

#### Text Button

Tertiary actions, low priority

```dart
VitaloTextButton(
  onPressed: () {},
  label: 'Skip',
)
```

### Cards

```dart
VitaloCard(
  header: Text('Health Index'),
  onTap: () {},
  child: Column(
    children: [
      // Card content
    ],
  ),
)
```

### Mascot

The FluxMascot represents 3 health dimensions:

- Outer layer: Physical health
- Middle layer: Nutritional health
- Core layer: Mental health

```dart
FluxMascot(
  size: 220,
  themeMode: Theme.of(context).brightness,
)
```

---

## 🎭 Animation Guidelines

- **Mascot animations**: Slow, organic (6-15s loops)
- **Button press**: Quick scale bounce (150ms)
- **Page transitions**: Smooth fade/slide (300ms)
- **Loading states**: Subtle pulse (1-2s)

---

## 📱 Layout Guidelines

### Mobile-First

- Max content width: 480px
- Horizontal padding: 24px
- Touch targets: min 48x48px
- Safe area aware

### Responsive Spacing

- Mobile: Use `md`, `lg`, `xl` spacing
- Tablet: Scale up to `xl`, `xxl`, `xxxl`
- Desktop: Use `huge`, `massive` for sections

---

## ✅ Checklist for New Screens

- [ ] Import `AppSpacing` for consistent spacing
- [ ] Use theme text styles (not hardcoded fonts)
- [ ] Use `VitaloPrimaryButton`/`VitaloSecondaryButton`
- [ ] Wrap content in `ConstrainedBox` (maxWidth: 480)
- [ ] Apply `AppSpacing.pageHorizontalPadding`
- [ ] Use semantic colors from `AppColors`
- [ ] Test both light and dark themes
- [ ] Ensure touch targets ≥ 48px
- [ ] Add loading/empty states

---

## 🚀 Future Enhancements

- [ ] Download custom Poppins & Inter fonts
- [ ] Add claymorphism depth effects
- [ ] Implement organic blob backgrounds
- [ ] Add haptic feedback to buttons
- [ ] Create icon system (custom Vitalo icons)
