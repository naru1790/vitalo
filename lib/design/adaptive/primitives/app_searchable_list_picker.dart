// @frozen
// Tier-1 composite primitive.
// Owns: searchable list selection with visual styling.
// Must NOT: perform async data fetching, call DateTime.now(), perform navigation, show feedback.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../widgets/app_text.dart';
import '../widgets/app_text_field.dart';
import '../../tokens/colors/app_colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/icons.dart' as icons;

/// Generic callback for building list item widgets.
typedef SearchableListItemBuilder<T> =
    Widget Function(BuildContext context, T item, bool isSelected);

/// Generic callback for extracting searchable text from an item.
typedef SearchableTextExtractor<T> = String Function(T item);

/// Tier-1 searchable list picker with optional pinned section.
///
/// Displays a search field and a scrollable list of items.
/// Filters items as user types. Tapping an item selects it.
///
/// When [pinnedItems] is provided, shows them in a separate section
/// at the top (e.g., "Popular" countries).
///
/// This widget is constraint-safe and works inside modal sheets.
class AppSearchableListPicker<T> extends StatefulWidget {
  const AppSearchableListPicker({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.searchTextExtractor,
    required this.onItemSelected,
    this.pinnedItems = const [],
    this.pinnedSectionTitle,
    this.allSectionTitle,
    this.selectedItem,
    this.searchHint = 'Search...',
    this.emptyMessage = 'No results found',
    this.itemHeight = 52.0,
  });

  /// Pre-loaded list of all items.
  final List<T> items;

  /// Items to pin at top (e.g., popular countries).
  final List<T> pinnedItems;

  /// Title for pinned section (e.g., "Popular").
  final String? pinnedSectionTitle;

  /// Title for all items section (e.g., "All Countries").
  final String? allSectionTitle;

  /// Builder for each list item.
  final SearchableListItemBuilder<T> itemBuilder;

  /// Extracts searchable text from an item.
  final SearchableTextExtractor<T> searchTextExtractor;

  /// Called when an item is tapped.
  final ValueChanged<T> onItemSelected;

  /// Currently selected item (for visual indication).
  final T? selectedItem;

  /// Placeholder text for search field.
  final String searchHint;

  /// Message shown when filter returns no results.
  final String emptyMessage;

  /// Height of each list item.
  final double itemHeight;

  @override
  State<AppSearchableListPicker<T>> createState() =>
      _AppSearchableListPickerState<T>();
}

class _AppSearchableListPickerState<T>
    extends State<AppSearchableListPicker<T>> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(AppSearchableListPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset search when items change
    if (oldWidget.items != widget.items) {
      _searchController.clear();
      _query = '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text.toLowerCase().trim();
    });
  }

  List<T> _filterItems(List<T> items) {
    if (_query.isEmpty) return items;
    return items.where((item) {
      final text = widget.searchTextExtractor(item).toLowerCase();
      return text.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final spacing = Spacing.of;

    final isSearching = _query.isNotEmpty;
    final filteredPinned = isSearching ? <T>[] : widget.pinnedItems;
    final filteredAll = _filterItems(widget.items);

    // When searching, don't show pinned section
    final showPinnedSection = !isSearching && filteredPinned.isNotEmpty;
    final showAllSection = filteredAll.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: AppTextField(
            controller: _searchController,
            placeholder: widget.searchHint,
            leadingIcon: icons.AppIcon.navSearch,
          ),
        ),

        SizedBox(height: spacing.sm),

        // Results list - Flexible with loose fit is constraint-safe
        Flexible(
          fit: FlexFit.loose,
          child: !showPinnedSection && !showAllSection
              ? _EmptyState(message: widget.emptyMessage)
              : ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Pinned section
                    if (showPinnedSection) ...[
                      if (widget.pinnedSectionTitle != null)
                        _SectionHeader(title: widget.pinnedSectionTitle!),
                      ...filteredPinned.map((item) => _buildItem(item, colors)),
                    ],

                    // All items section
                    if (showAllSection) ...[
                      if (widget.allSectionTitle != null && showPinnedSection)
                        _SectionHeader(title: widget.allSectionTitle!),
                      ...filteredAll.map((item) => _buildItem(item, colors)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildItem(T item, AppColors colors) {
    final isSelected = widget.selectedItem == item;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onItemSelected(item),
      child: Container(
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: isSelected ? colors.stateSelected : null,
          border: Border(
            bottom: BorderSide(color: colors.neutralDivider, width: 0.5),
          ),
        ),
        child: widget.itemBuilder(context, item, isSelected),
      ),
    );
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final colors = AppColorScope.of(context).colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      color: colors.neutralSurface,
      child: AppText(
        title,
        variant: AppTextVariant.caption,
        color: AppTextColor.secondary,
      ),
    );
  }
}

/// Empty state widget.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        message,
        variant: AppTextVariant.body,
        color: AppTextColor.secondary,
      ),
    );
  }
}
