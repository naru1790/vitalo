import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';

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
    return showModalBottomSheet<LocationResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      // Smooth transition animation
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;

    // Use fixed height - 50% of screen for compact presentation
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.cardRadiusLarge),
          ),
        ),
        child: Column(
          children: [
            _buildDragHandle(colorScheme),
            _buildHeader(colorScheme),
            _buildSearchBar(colorScheme),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
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
    );
  }

  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

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
                ? IconButton(
                    key: const ValueKey('back'),
                    onPressed: _onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back to countries',
                    style: IconButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                    ),
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
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'For personalized health insights',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('state-title'),
                      children: [
                        Text(
                          'Select State',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (_selectedCountry != null)
                          Text(
                            '${_selectedCountry!.flag} ${_selectedCountry!.name}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
            ),
          ),

          // Step indicator
          _buildStepIndicator(colorScheme),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepDot(0, colorScheme),
        const SizedBox(width: AppSpacing.xs),
        _buildStepDot(1, colorScheme),
      ],
    );
  }

  Widget _buildStepDot(int step, ColorScheme colorScheme) {
    final isActive = _currentStep >= step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: _currentStep == 0
              ? 'Search countries...'
              : 'Search states...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 1: Countries Page
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCountriesPage() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filteredCountries = _getFilteredCountries();
    final showPopular = _searchQuery.isEmpty;

    if (filteredCountries.isEmpty) {
      return _buildEmptyState('No countries found', colorScheme);
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
            return _buildSectionHeader('Popular', textTheme, colorScheme);
          }
          if (index <= _popularCountries.length) {
            return _buildCountryTile(
              _popularCountries[index - 1],
              colorScheme,
              textTheme,
            );
          }
          // All countries section
          if (index == _popularCountries.length + 1) {
            return _buildSectionHeader('All Countries', textTheme, colorScheme);
          }
          final allIndex = index - _popularCountries.length - 2;
          if (allIndex < filteredCountries.length) {
            return _buildCountryTile(
              filteredCountries[allIndex],
              colorScheme,
              textTheme,
            );
          }
          return const SizedBox.shrink();
        }

        return _buildCountryTile(
          filteredCountries[index],
          colorScheme,
          textTheme,
        );
      },
    );
  }

  Widget _buildSectionHeader(
    String title,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCountryTile(
    csc.Country country,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onCountrySelected(country),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.touchTargetMin,
          ),
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
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 2: States Page
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatesPage() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoadingStates) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredStates = _getFilteredStates();
    final hasStates = _states.isNotEmpty;

    if (!hasStates && _searchQuery.isNotEmpty) {
      return _buildEmptyState('No states found', colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: filteredStates.length + 1, // +1 for skip option
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSkipStateTile(colorScheme, textTheme, hasStates);
        }
        if (index - 1 < filteredStates.length) {
          return _buildStateTile(
            filteredStates[index - 1],
            colorScheme,
            textTheme,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkipStateTile(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool hasStates,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onStateSelected(null),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.touchTargetMin,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.public_rounded,
                  color: colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStates ? 'Country only' : 'No states available',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      hasStates
                          ? 'Continue without selecting state'
                          : 'Tap to continue with ${_selectedCountry?.name ?? "country"}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: colorScheme.primary,
                size: AppSpacing.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateTile(
    csc.State state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onStateSelected(state),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.touchTargetMin,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  state.name,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: colorScheme.onSurfaceVariant,
                size: AppSpacing.iconSizeSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
