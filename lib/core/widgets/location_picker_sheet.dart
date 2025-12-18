import 'dart:ui';

import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/cupertino.dart';

import '../theme.dart';

/// Result from location picker containing country and optional state
class LocationResult {
  final String countryName;
  final String countryCode;
  final String? stateName;
  final String? stateCode;
  final String? flag;

  const LocationResult({
    required this.countryName,
    required this.countryCode,
    this.stateName,
    this.stateCode,
    this.flag,
  });

  /// Formatted display string
  String get displayName {
    if (stateName != null) return '$stateName, $countryName';
    return countryName;
  }

  /// Short display with flag
  String get displayWithFlag => '${flag ?? ''} $displayName'.trim();
}

/// Popular country codes for quick access
const _popularCountryCodes = ['IN', 'US', 'GB', 'CA', 'AU', 'DE', 'FR', 'AE'];

/// Animation duration for drill-down transitions
const _kTransitionDuration = Duration(milliseconds: 250);

/// A modern, animated drill-down bottom sheet for selecting country and state.
///
/// UX Principles:
/// - **Fitts's Law**: Large 48dp+ touch targets for easy tapping
/// - **Hick's Law**: Two-step flow reduces choices at each step
/// - **Error Prevention**: States are filtered by selected country
/// - **Animated Hierarchy**: Slide transitions reinforce drill-down navigation
///
/// Flow:
/// 1. User taps Location → Sheet rises (70% height)
/// 2. Focus 1: User sees countries, taps "India"
/// 3. Transition: Sheet slides left → states view
/// 4. Focus 2: User taps "Maharashtra"
/// 5. Completion: Sheet closes, returns "Maharashtra, India"
class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({
    super.key,
    this.initialCountryCode,
    this.initialStateCode,
    required this.onLocationSelected,
  });

  final String? initialCountryCode;
  final String? initialStateCode;
  final ValueChanged<LocationResult> onLocationSelected;

  /// Shows the location picker as a modal bottom sheet.
  static Future<LocationResult?> show({
    required BuildContext context,
    String? initialCountryCode,
    String? initialStateCode,
  }) async {
    return showCupertinoModalPopup<LocationResult>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LocationPickerSheet(
        initialCountryCode: initialCountryCode,
        initialStateCode: initialStateCode,
        onLocationSelected: (result) => Navigator.pop(context, result),
      ),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet>
    with SingleTickerProviderStateMixin {
  // Data
  List<csc.Country> _allCountries = [];
  List<csc.Country> _popularCountries = [];
  List<csc.State> _states = [];
  bool _isLoading = true;
  bool _isLoadingStates = false;

  // Selection state
  csc.Country? _selectedCountry;
  csc.State? _selectedState;

  // UI state - 0 = countries, 1 = states
  int _currentStep = 0;
  String _searchQuery = '';

  // Controllers
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final countries = await csc.getAllCountries();

    final popular = <csc.Country>[];
    final others = <csc.Country>[];

    for (final country in countries) {
      if (_popularCountryCodes.contains(country.isoCode)) {
        popular.add(country);
      } else {
        others.add(country);
      }
    }

    popular.sort(
      (a, b) => _popularCountryCodes
          .indexOf(a.isoCode)
          .compareTo(_popularCountryCodes.indexOf(b.isoCode)),
    );
    others.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _allCountries = [...popular, ...others];
      _popularCountries = popular;
      _isLoading = false;
    });
  }

  Future<void> _loadStates(String countryCode) async {
    setState(() => _isLoadingStates = true);

    final states = await csc.getStatesOfCountry(countryCode);
    states.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _states = states;
      _isLoadingStates = false;
    });
  }

  void _onCountrySelected(csc.Country country) {
    // Clear search and unfocus
    _searchController.clear();
    _searchFocusNode.unfocus();

    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _searchQuery = '';
      _currentStep = 1;
    });

    // Load states and animate to next page
    _loadStates(country.isoCode);
    _pageController.animateToPage(
      1,
      duration: _kTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void _onStateSelected(csc.State? state) {
    setState(() => _selectedState = state);

    // Auto-complete: close sheet immediately when state is selected
    _completeSelection();
  }

  void _onBack() {
    _searchController.clear();
    _searchFocusNode.unfocus();

    setState(() {
      _searchQuery = '';
      _currentStep = 0;
    });

    _pageController.animateToPage(
      0,
      duration: _kTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void _completeSelection() {
    if (_selectedCountry == null) return;

    widget.onLocationSelected(
      LocationResult(
        countryName: _selectedCountry!.name,
        countryCode: _selectedCountry!.isoCode,
        stateName: _selectedState?.name,
        stateCode: _selectedState?.isoCode,
        flag: _selectedCountry!.flag,
      ),
    );
  }

  List<csc.Country> _getFilteredCountries() {
    if (_searchQuery.isEmpty) return _allCountries;
    final query = _searchQuery.toLowerCase();
    return _allCountries
        .where((c) => c.name.toLowerCase().startsWith(query))
        .toList();
  }

  List<csc.State> _getFilteredStates() {
    if (_searchQuery.isEmpty) return _states;
    final query = _searchQuery.toLowerCase();
    return _states
        .where((s) => s.name.toLowerCase().startsWith(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    // Use fixed height - 50% of screen for compact presentation
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadiusLarge),
              ),
              border: Border(
                top: BorderSide(
                  color: labelColor.withValues(alpha: 0.1),
                  width: LiquidGlass.borderWidth,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildDragHandle(),
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (page) {
                            setState(() => _currentStep = page);
                          },
                          children: [_buildCountriesPage(), _buildStatesPage()],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      width: 36,
      height: 5,
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildHeader() {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Back button with animated visibility
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _currentStep == 1
                ? CupertinoButton(
                    key: const ValueKey('back'),
                    padding: EdgeInsets.zero,
                    minSize: AppSpacing.touchTargetMin,
                    onPressed: _onBack,
                    child: Icon(CupertinoIcons.back, color: primaryColor),
                  )
                : const SizedBox(
                    key: ValueKey('spacer'),
                    width: AppSpacing.touchTargetMin,
                  ),
          ),

          // Animated title
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _currentStep == 0
                  ? Column(
                      key: const ValueKey('country-title'),
                      children: [
                        Text(
                          'Select Country',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: labelColor,
                          ),
                        ),
                        Text(
                          'For personalized health insights',
                          style: TextStyle(fontSize: 13, color: secondaryLabel),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('state-title'),
                      children: [
                        Text(
                          'Select State',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: labelColor,
                          ),
                        ),
                        if (_selectedCountry != null)
                          Text(
                            '${_selectedCountry!.flag} ${_selectedCountry!.name}',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryLabel,
                            ),
                          ),
                      ],
                    ),
            ),
          ),

          // Step indicator
          _buildStepIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepDot(0),
        const SizedBox(width: AppSpacing.xs),
        _buildStepDot(1),
      ],
    );
  }

  Widget _buildStepDot(int step) {
    final isActive = _currentStep >= step;
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : separatorColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSearchBar() {
    final fillColor = CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: CupertinoTextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        placeholder: _currentStep == 0
            ? 'Search countries...'
            : 'Search states...',
        prefix: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Icon(
            CupertinoIcons.search,
            color: secondaryLabel,
            size: AppSpacing.iconSizeSmall,
          ),
        ),
        suffix: _searchQuery.isNotEmpty
            ? CupertinoButton(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                minSize: 0,
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: secondaryLabel,
                  size: AppSpacing.iconSizeSmall,
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 1: Countries Page
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCountriesPage() {
    final filteredCountries = _getFilteredCountries();
    final showPopular = _searchQuery.isEmpty;

    if (filteredCountries.isEmpty) {
      return _buildEmptyState('No countries found');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: showPopular
          ? _popularCountries.length + filteredCountries.length + 2
          : filteredCountries.length,
      itemBuilder: (context, index) {
        if (showPopular) {
          // Popular section
          if (index == 0) {
            return _buildSectionHeader('Popular');
          }
          if (index <= _popularCountries.length) {
            return _buildCountryTile(_popularCountries[index - 1]);
          }
          // All countries section
          if (index == _popularCountries.length + 1) {
            return _buildSectionHeader('All Countries');
          }
          final allIndex = index - _popularCountries.length - 2;
          if (allIndex < filteredCountries.length) {
            return _buildCountryTile(filteredCountries[allIndex]);
          }
          return const SizedBox.shrink();
        }

        return _buildCountryTile(filteredCountries[index]);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: secondaryLabel,
        ),
      ),
    );
  }

  Widget _buildCountryTile(csc.Country country) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onCountrySelected(country),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.touchTargetMin),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                country.name,
                style: TextStyle(fontSize: 17, color: labelColor),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: secondaryLabel,
              size: AppSpacing.iconSize,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 2: States Page
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatesPage() {
    if (_isLoadingStates) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final filteredStates = _getFilteredStates();
    final hasStates = _states.isNotEmpty;

    if (!hasStates && _searchQuery.isNotEmpty) {
      return _buildEmptyState('No states found');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: filteredStates.length + 1, // +1 for skip option
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSkipStateTile(hasStates);
        }
        if (index - 1 < filteredStates.length) {
          return _buildStateTile(filteredStates[index - 1]);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkipStateTile(bool hasStates) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onStateSelected(null),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.touchTargetMin),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: separatorColor, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(CupertinoIcons.globe, color: primaryColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasStates ? 'Country only' : 'No states available',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  Text(
                    hasStates
                        ? 'Continue without selecting state'
                        : 'Tap to continue with ${_selectedCountry?.name ?? "country"}',
                    style: TextStyle(fontSize: 13, color: secondaryLabel),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.arrow_right,
              color: primaryColor,
              size: AppSpacing.iconSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateTile(csc.State state) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onStateSelected(state),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.touchTargetMin),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.location,
              color: secondaryLabel,
              size: AppSpacing.iconSize,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                state.name,
                style: TextStyle(fontSize: 17, color: labelColor),
              ),
            ),
            Icon(
              CupertinoIcons.arrow_right,
              color: secondaryLabel,
              size: AppSpacing.iconSizeSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.search, size: 48, color: secondaryLabel),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: TextStyle(fontSize: 17, color: secondaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
