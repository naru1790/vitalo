// @frozen
// DOCUMENT CONTENT PRIMITIVE: SECTION
// ═══════════════════════════════════════════════════════════════════════════
//
// Intent: Encodes reading hierarchy and vertical rhythm for document content.
//
// This is a DocumentPage-only content primitive.
// It structures title + body pairs with consistent vertical spacing.
//
// Encodes:
// - Section title using AppTextVariant.label
// - Section body using AppTextVariant.body
// - Bottom spacing for vertical rhythm (Spacing.of.lg)
//
// This widget MUST NOT:
// - Be used outside DocumentPage
// - Own scroll behavior
// - Apply horizontal padding or width constraints
// - Contain interactive elements
//
// DocumentPage owns layout, scroll, and page padding.
// This widget owns only section-level reading structure.
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../adaptive/widgets/app_text.dart';
import '../tokens/spacing.dart';

/// Document section primitive.
///
/// Structures title + body pairs with consistent vertical rhythm.
/// For use exclusively within [DocumentPage] content.
///
/// Owns:
/// - Section title (label variant)
/// - Section body (body variant)
/// - Bottom spacing for rhythm
///
/// Does NOT own:
/// - Scroll behavior
/// - Horizontal padding
/// - Width constraints
class AppDocumentSection extends StatelessWidget {
  const AppDocumentSection({
    super.key,
    required this.title,
    required this.content,
  });

  /// Section heading text.
  final String title;

  /// Section body text.
  final String content;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, variant: AppTextVariant.label),
          SizedBox(height: spacing.sm),
          AppText(content, variant: AppTextVariant.body),
        ],
      ),
    );
  }
}
