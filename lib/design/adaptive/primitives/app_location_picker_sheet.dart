// @adaptive-composite
// Semantics: Two-step location picker sheet content
// Owns: sheet-level location selection UX with country → state flow
// Emits: LocationResult via Navigator.pop
// Must NOT:
//  - fetch user data
//  - navigate routes (except pop with value)
//  - show global feedback (snackbars, toasts, dialogs)
//  - use Expanded, Spacer, or other constraint-unsafe widgets

import 'package:flutter/widgets.dart';

import '../models/location_selection.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';
import 'app_searchable_list_picker.dart';
import '../../tokens/spacing.dart';
import '../../tokens/icons.dart' as icons;

// Re-export for callers' convenience.
export '../models/location_selection.dart';

/// Two-step location picker sheet.
///
/// Step 1: Select country from searchable list
/// Step 2: Select state from searchable list (if country has states)
///
/// Uses state-based step switching.
/// Returns the selected location via `Navigator.pop(context, result)`.
class AppLocationPickerSheet extends StatefulWidget {
  const AppLocationPickerSheet({
    super.key,
    required this.countries,
    required this.statesLoader,
    this.popularCountries = const [],
    this.initialCountryCode,
    this.initialStateCode,
  });

  /// Pre-loaded list of countries.
  final List<LocationCountry> countries;

  /// Popular countries shown at top of list.
  final List<LocationCountry> popularCountries;

  /// Function to load states for a given country code.
  final Future<List<LocationState>> Function(String countryCode) statesLoader;

  /// Initial country code (ISO 2-letter code).
  final String? initialCountryCode;

  /// Initial state code.
  final String? initialStateCode;

  @override
  State<AppLocationPickerSheet> createState() => _AppLocationPickerSheetState();
}

class _AppLocationPickerSheetState extends State<AppLocationPickerSheet> {
  // Current step
  _Step _currentStep = _Step.country;

  // Selections
  LocationCountry? _selectedCountry;
  LocationState? _selectedState;

  // States data
  List<LocationState> _states = [];
  bool _loadingStates = false;

  @override
  void initState() {
    super.initState();
    _initializeFromInitialValues();
  }

  void _initializeFromInitialValues() {
    // Find initial country
    if (widget.initialCountryCode != null) {
      try {
        _selectedCountry = widget.countries.firstWhere(
          (c) => c.isoCode == widget.initialCountryCode,
        );
        // If initial state code is also provided, auto-load states
        if (widget.initialStateCode != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedCountry != null) {
              _onCountrySelected(_selectedCountry!);
            }
          });
        }
      } catch (_) {
        // TODO(logging): Log country code not found for debugging
        // Country code not found in list - silently ignore and show all countries
      }
    }
  }

  Future<void> _onCountrySelected(LocationCountry country) async {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _loadingStates = true;
    });

    // Load states for selected country
    final states = await widget.statesLoader(country.isoCode);

    if (!mounted) return;

    if (states.isEmpty) {
      // No states — confirm directly
      _confirmSelection();
    } else {
      // Find initial state if matches this country
      LocationState? initialState;
      if (widget.initialStateCode != null &&
          widget.initialCountryCode == country.isoCode) {
        try {
          initialState = states.firstWhere(
            (s) => s.isoCode == widget.initialStateCode,
          );
        } catch (_) {
          // TODO(logging): Log state code not found for debugging
          // State code not found in country's states - silently ignore
        }
      }

      setState(() {
        _states = states;
        _selectedState = initialState;
        _loadingStates = false;
        _currentStep = _Step.state;
      });
    }
  }

  void _onStateSelected(LocationState state) {
    setState(() => _selectedState = state);
    // Immediately confirm on state tap (country requires state step first)
    _confirmSelection();
  }

  void _goBackToCountry() {
    setState(() {
      _currentStep = _Step.country;
      _states = [];
      _selectedState = null;
    });
  }

  void _confirmSelection() {
    if (_selectedCountry == null) return;

    final result = LocationResult(
      country: _selectedCountry!,
      state: _selectedState,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final screenHeight = MediaQuery.sizeOf(context).height;
    // Use 75% of screen height, capped at 600px for tablets
    final sheetHeight = (screenHeight * 0.75).clamp(300.0, 600.0);

    return SizedBox(
      height: sheetHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with back button on state step
          _Header(
            title: _currentStep == _Step.country
                ? 'Select Country'
                : 'Select State',
            showBack: _currentStep == _Step.state,
            onBack: _goBackToCountry,
            subtitle: _currentStep == _Step.state
                ? '${_selectedCountry?.flag ?? ''} ${_selectedCountry?.name ?? ''}'
                      .trim()
                : null,
          ),

          SizedBox(height: spacing.sm),

          // Content - Flexible with loose fit is constraint-safe
          // (unlike Expanded which requires bounded constraints)
          Flexible(
            fit: FlexFit.loose,
            child: _loadingStates
                ? const Center(
                    child: AppText(
                      'Loading...',
                      variant: AppTextVariant.body,
                      color: AppTextColor.secondary,
                    ),
                  )
                : _currentStep == _Step.country
                ? _CountryList(
                    countries: widget.countries,
                    popularCountries: widget.popularCountries,
                    selectedCountry: _selectedCountry,
                    onCountrySelected: _onCountrySelected,
                  )
                : _StateList(
                    states: _states,
                    selectedState: _selectedState,
                    onStateSelected: _onStateSelected,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Internal step enum.
enum _Step { country, state }

/// Header with optional back button.
class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    this.showBack = false,
    this.onBack,
    this.subtitle,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: onBack,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(right: spacing.sm),
                    child: const AppIcon(
                      icons.AppIcon.navBack,
                      size: AppIconSize.medium,
                      color: AppIconColor.primary,
                    ),
                  ),
                ),
              Flexible(
                fit: FlexFit.loose,
                child: AppText(
                  title,
                  variant: AppTextVariant.title,
                  color: AppTextColor.primary,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: spacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                subtitle!,
                variant: AppTextVariant.caption,
                color: AppTextColor.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Country selection list with popular countries section.
class _CountryList extends StatelessWidget {
  const _CountryList({
    required this.countries,
    required this.popularCountries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  final List<LocationCountry> countries;
  final List<LocationCountry> popularCountries;
  final LocationCountry? selectedCountry;
  final ValueChanged<LocationCountry> onCountrySelected;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return AppSearchableListPicker<LocationCountry>(
      items: countries,
      pinnedItems: popularCountries,
      pinnedSectionTitle: 'Popular',
      allSectionTitle: 'All Countries',
      selectedItem: selectedCountry,
      searchHint: 'Search countries...',
      emptyMessage: 'No countries found',
      searchTextExtractor: (country) => country.name,
      onItemSelected: onCountrySelected,
      itemBuilder: (context, country, isSelected) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            AppText(country.flag ?? '', variant: AppTextVariant.title),
            SizedBox(width: spacing.sm),
            Flexible(
              fit: FlexFit.loose,
              child: AppText(
                country.name,
                variant: isSelected
                    ? AppTextVariant.title
                    : AppTextVariant.body,
                color: isSelected ? AppTextColor.primary : AppTextColor.primary,
              ),
            ),
            if (isSelected)
              const AppIcon(
                icons.AppIcon.actionConfirm,
                size: AppIconSize.small,
                color: AppIconColor.primary,
              ),
          ],
        ),
      ),
    );
  }
}

/// State selection list.
class _StateList extends StatelessWidget {
  const _StateList({
    required this.states,
    required this.selectedState,
    required this.onStateSelected,
  });

  final List<LocationState> states;
  final LocationState? selectedState;
  final ValueChanged<LocationState> onStateSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return AppSearchableListPicker<LocationState>(
      items: states,
      selectedItem: selectedState,
      searchHint: 'Search states...',
      emptyMessage: 'No states found',
      searchTextExtractor: (state) => state.name,
      onItemSelected: onStateSelected,
      itemBuilder: (context, state, isSelected) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: AppText(
                state.name,
                variant: isSelected
                    ? AppTextVariant.title
                    : AppTextVariant.body,
                color: isSelected ? AppTextColor.primary : AppTextColor.primary,
              ),
            ),
            if (isSelected)
              const AppIcon(
                icons.AppIcon.actionConfirm,
                size: AppIconSize.small,
                color: AppIconColor.primary,
              ),
          ],
        ),
      ),
    );
  }
}
