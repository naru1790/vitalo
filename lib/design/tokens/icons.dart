import 'dart:io' show Platform;

// ════════════════════════════════════════════════════════════════════════════
// INTERNAL IMPORTS — DO NOT USE ELSEWHERE
// ════════════════════════════════════════════════════════════════════════════
// These imports are STRICTLY INTERNAL to this resolver.
// Importing CupertinoIcons or Icons directly in any other file is forbidden.
// All icon access MUST go through AppIcons.resolve(AppIcon.*).
// ════════════════════════════════════════════════════════════════════════════
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons, IconData;

/// Semantic icon identifiers.
///
/// Icons are semantic identifiers, not visual assets.
/// Meaning is defined here. Rendering is platform-specific.
///
/// Direct usage of platform icon sets outside this file is forbidden.
enum AppIcon {
  // ──────────────────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────────────────
  navBack,
  navForward,
  navHome,
  navMenu,
  navSettings,
  navProfile,
  navSearch,
  navExternal,

  // ──────────────────────────────────────────────────────────
  // Actions
  // ──────────────────────────────────────────────────────────
  actionAdd,
  actionRemove,
  actionDelete,
  actionEdit,
  actionSave,
  actionConfirm,
  actionCancel,
  actionClose,
  actionShare,
  actionSend,
  actionCopy,
  actionDuplicate,
  actionUndo,
  actionRedo,
  actionRefresh,
  actionSync,
  actionFilter,
  actionSort,
  actionMore,
  actionBookmark,
  actionFavorite,
  actionDownload,
  actionUpload,

  // ──────────────────────────────────────────────────────────
  // States
  // ──────────────────────────────────────────────────────────
  stateExpanded,
  stateCollapsed,
  stateVisible,
  stateHidden,
  stateLocked,
  stateUnlocked,
  stateOn,
  stateOff,
  stateSelected,
  stateDeselected,
  statePlaying,
  statePaused,

  // ──────────────────────────────────────────────────────────
  // Feedback
  // ──────────────────────────────────────────────────────────
  feedbackSuccess,
  feedbackWarning,
  feedbackError,
  feedbackInfo,
  feedbackHelp,
  feedbackLoading,
  feedbackEmpty,
  feedbackCelebration,
  feedbackNotification,

  // ──────────────────────────────────────────────────────────
  // System & Utility
  // ──────────────────────────────────────────────────────────
  systemCamera,
  systemPhotos,
  systemLocation,
  systemCalendar,
  systemTime,
  systemNotificationSettings,
  systemPrivacy,
  systemSecurity,
  systemLanguage,
  systemAccessibility,
}

/// Icon resolver.
///
/// Maps semantic icon identifiers to platform-appropriate icons.
/// This is the ONLY place where platform icon sets may be referenced.
abstract final class AppIcons {
  AppIcons._();

  /// Resolve a semantic icon to a platform-specific [IconData].
  static IconData resolve(AppIcon icon) {
    try {
      if (Platform.isIOS) {
        return _ios(icon);
      }
      if (Platform.isAndroid) {
        return _android(icon);
      }
    } catch (_) {
      // Platform unavailable (e.g., web)
    }
    return _android(icon);
  }

  // ──────────────────────────────────────────────────────────
  // iOS (CupertinoIcons)
  // ──────────────────────────────────────────────────────────
  static IconData _ios(AppIcon icon) {
    switch (icon) {
      // Navigation
      case AppIcon.navBack:
        return CupertinoIcons.back;
      case AppIcon.navForward:
        return CupertinoIcons.forward;
      case AppIcon.navHome:
        return CupertinoIcons.home;
      case AppIcon.navMenu:
        return CupertinoIcons.bars;
      case AppIcon.navSettings:
        return CupertinoIcons.settings;
      case AppIcon.navProfile:
        return CupertinoIcons.person;
      case AppIcon.navSearch:
        return CupertinoIcons.search;
      case AppIcon.navExternal:
        return CupertinoIcons.arrow_up_right_square;

      // Actions
      case AppIcon.actionAdd:
        return CupertinoIcons.add;
      case AppIcon.actionRemove:
        return CupertinoIcons.minus;
      case AppIcon.actionDelete:
        return CupertinoIcons.trash;
      case AppIcon.actionEdit:
        return CupertinoIcons.pencil;
      case AppIcon.actionSave:
        // Modern save metaphor: arrow into container (not legacy floppy disk)
        return CupertinoIcons.square_arrow_down;
      case AppIcon.actionConfirm:
        return CupertinoIcons.checkmark;
      case AppIcon.actionCancel:
        // Cancel = abandon operation. Distinct from close (xmark).
        // Minus-circle: "remove/negate this action" — not dismissal.
        return CupertinoIcons.minus_circle;
      case AppIcon.actionClose:
        return CupertinoIcons.xmark;
      case AppIcon.actionShare:
        return CupertinoIcons.share;
      case AppIcon.actionSend:
        return CupertinoIcons.paperplane;
      case AppIcon.actionCopy:
        return CupertinoIcons.doc_on_clipboard;
      case AppIcon.actionDuplicate:
        return CupertinoIcons.doc_on_doc;
      case AppIcon.actionUndo:
        return CupertinoIcons.arrow_uturn_left;
      case AppIcon.actionRedo:
        return CupertinoIcons.arrow_uturn_right;
      case AppIcon.actionRefresh:
        return CupertinoIcons.refresh;
      case AppIcon.actionSync:
        return CupertinoIcons.arrow_2_circlepath;
      case AppIcon.actionFilter:
        return CupertinoIcons.slider_horizontal_3;
      case AppIcon.actionSort:
        return CupertinoIcons.sort_down;
      case AppIcon.actionMore:
        return CupertinoIcons.ellipsis;
      case AppIcon.actionBookmark:
        return CupertinoIcons.bookmark;
      case AppIcon.actionFavorite:
        return CupertinoIcons.heart;
      case AppIcon.actionDownload:
        return CupertinoIcons.arrow_down_to_line;
      case AppIcon.actionUpload:
        return CupertinoIcons.arrow_up_to_line;

      // States
      case AppIcon.stateExpanded:
        return CupertinoIcons.chevron_up;
      case AppIcon.stateCollapsed:
        return CupertinoIcons.chevron_down;
      case AppIcon.stateVisible:
        return CupertinoIcons.eye;
      case AppIcon.stateHidden:
        return CupertinoIcons.eye_slash;
      case AppIcon.stateLocked:
        return CupertinoIcons.lock;
      case AppIcon.stateUnlocked:
        return CupertinoIcons.lock_open;
      case AppIcon.stateOn:
        return CupertinoIcons.circle_fill;
      case AppIcon.stateOff:
        return CupertinoIcons.circle;
      case AppIcon.stateSelected:
        return CupertinoIcons.checkmark_square_fill;
      case AppIcon.stateDeselected:
        return CupertinoIcons.square;
      case AppIcon.statePlaying:
        return CupertinoIcons.play_fill;
      case AppIcon.statePaused:
        return CupertinoIcons.pause_fill;

      // Feedback
      case AppIcon.feedbackSuccess:
        return CupertinoIcons.checkmark_circle_fill;
      case AppIcon.feedbackWarning:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case AppIcon.feedbackError:
        return CupertinoIcons.xmark_circle_fill;
      case AppIcon.feedbackInfo:
        return CupertinoIcons.info_circle_fill;
      case AppIcon.feedbackHelp:
        return CupertinoIcons.question_circle;
      case AppIcon.feedbackLoading:
        return CupertinoIcons.hourglass;
      case AppIcon.feedbackEmpty:
        return CupertinoIcons.tray;
      case AppIcon.feedbackCelebration:
        return CupertinoIcons.star_circle_fill;
      case AppIcon.feedbackNotification:
        return CupertinoIcons.bell_fill;

      // System
      case AppIcon.systemCamera:
        return CupertinoIcons.camera;
      case AppIcon.systemPhotos:
        return CupertinoIcons.photo;
      case AppIcon.systemLocation:
        return CupertinoIcons.location;
      case AppIcon.systemCalendar:
        return CupertinoIcons.calendar;
      case AppIcon.systemTime:
        return CupertinoIcons.clock;
      case AppIcon.systemNotificationSettings:
        return CupertinoIcons.bell_circle;
      case AppIcon.systemPrivacy:
        return CupertinoIcons.hand_raised;
      case AppIcon.systemSecurity:
        return CupertinoIcons.shield;
      case AppIcon.systemLanguage:
        return CupertinoIcons.globe;
      case AppIcon.systemAccessibility:
        return CupertinoIcons.person_crop_circle;
    }
  }

  // ──────────────────────────────────────────────────────────
  // Android (Material Icons)
  // ──────────────────────────────────────────────────────────
  static IconData _android(AppIcon icon) {
    switch (icon) {
      case AppIcon.navBack:
        return Icons.arrow_back;
      case AppIcon.navForward:
        return Icons.arrow_forward;
      case AppIcon.navHome:
        return Icons.home;
      case AppIcon.navMenu:
        return Icons.menu;
      case AppIcon.navSettings:
        return Icons.settings;
      case AppIcon.navProfile:
        return Icons.person;
      case AppIcon.navSearch:
        return Icons.search;
      case AppIcon.navExternal:
        return Icons.open_in_new;

      case AppIcon.actionAdd:
        return Icons.add;
      case AppIcon.actionRemove:
        return Icons.remove;
      case AppIcon.actionDelete:
        return Icons.delete;
      case AppIcon.actionEdit:
        return Icons.edit;
      case AppIcon.actionSave:
        return Icons.save;
      case AppIcon.actionConfirm:
        return Icons.check;
      case AppIcon.actionCancel:
        return Icons.cancel;
      case AppIcon.actionClose:
        return Icons.close;
      case AppIcon.actionShare:
        return Icons.share;
      case AppIcon.actionSend:
        return Icons.send;
      case AppIcon.actionCopy:
        return Icons.content_copy;
      case AppIcon.actionDuplicate:
        return Icons.file_copy;
      case AppIcon.actionUndo:
        return Icons.undo;
      case AppIcon.actionRedo:
        return Icons.redo;
      case AppIcon.actionRefresh:
        return Icons.refresh;
      case AppIcon.actionSync:
        return Icons.sync;
      case AppIcon.actionFilter:
        return Icons.filter_list;
      case AppIcon.actionSort:
        return Icons.sort;
      case AppIcon.actionMore:
        return Icons.more_vert;
      case AppIcon.actionBookmark:
        return Icons.bookmark;
      case AppIcon.actionFavorite:
        return Icons.favorite;
      case AppIcon.actionDownload:
        return Icons.download;
      case AppIcon.actionUpload:
        return Icons.upload;

      case AppIcon.stateExpanded:
        return Icons.expand_less;
      case AppIcon.stateCollapsed:
        return Icons.expand_more;
      case AppIcon.stateVisible:
        return Icons.visibility;
      case AppIcon.stateHidden:
        return Icons.visibility_off;
      case AppIcon.stateLocked:
        return Icons.lock;
      case AppIcon.stateUnlocked:
        return Icons.lock_open;
      case AppIcon.stateOn:
        return Icons.toggle_on;
      case AppIcon.stateOff:
        return Icons.toggle_off;
      case AppIcon.stateSelected:
        return Icons.check_box;
      case AppIcon.stateDeselected:
        return Icons.check_box_outline_blank;
      case AppIcon.statePlaying:
        return Icons.play_arrow;
      case AppIcon.statePaused:
        return Icons.pause;

      case AppIcon.feedbackSuccess:
        return Icons.check_circle;
      case AppIcon.feedbackWarning:
        return Icons.warning;
      case AppIcon.feedbackError:
        return Icons.error;
      case AppIcon.feedbackInfo:
        return Icons.info;
      case AppIcon.feedbackHelp:
        return Icons.help;
      case AppIcon.feedbackLoading:
        return Icons.hourglass_empty;
      case AppIcon.feedbackEmpty:
        return Icons.inbox;
      case AppIcon.feedbackCelebration:
        return Icons.emoji_events;
      case AppIcon.feedbackNotification:
        return Icons.notifications;

      case AppIcon.systemCamera:
        return Icons.camera_alt;
      case AppIcon.systemPhotos:
        return Icons.photo;
      case AppIcon.systemLocation:
        return Icons.location_on;
      case AppIcon.systemCalendar:
        return Icons.calendar_today;
      case AppIcon.systemTime:
        return Icons.access_time;
      case AppIcon.systemNotificationSettings:
        return Icons.notifications_active;
      case AppIcon.systemPrivacy:
        return Icons.privacy_tip;
      case AppIcon.systemSecurity:
        return Icons.security;
      case AppIcon.systemLanguage:
        return Icons.language;
      case AppIcon.systemAccessibility:
        return Icons.accessibility;
    }
  }
}
