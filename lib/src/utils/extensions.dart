import "package:custom_responsive/src/ui/custom_div.dart";
import "package:custom_responsive/src/utils/utils.dart";
import "package:flutter/material.dart";

/// Internal helpers used by the grid layout engine to resolve responsive
/// column spans and offsets for a [CustomDiv].
extension CustomDivExtensions on CustomDiv {
  /// Returns the width of a single grid column.
  double colSize(double width) => width / 12;

  /// Resolves the active column span for the current breakpoint.
  int columns(BuildContext context) => getResponsiveValue(
    context: context,
    valueS: colS,
    valueM: colM,
    valueXM: colXM,
    valueL: colL,
    valueXL: colXL,
  );

  /// Resolves the active column offset for the current breakpoint.
  int offset(BuildContext context) => getResponsiveValue(
    context: context,
    valueS: offsetS,
    valueM: offsetM,
    valueXM: offsetXM,
    valueL: offsetL,
    valueXL: offsetXL,
  );

  /// Resolves the total occupied grid width (columns + offset) for the
  /// current breakpoint.
  int totalWidth(BuildContext context) => getResponsiveValue(
    context: context,
    valueS: contextS,
    valueM: contextM,
    valueXM: contextXM,
    valueL: contextL,
    valueXL: contextXL,
  );

  /// Total occupied width for the S breakpoint.
  int get contextS => (columnS + offsetS).clamp(0, 12);

  /// Total occupied width for the M breakpoint.
  int get contextM => (columnM + offsetM).clamp(0, 12);

  /// Total occupied width for the XM breakpoint.
  int get contextXM => (columnXM + offsetXM).clamp(0, 12);

  /// Total occupied width for the L breakpoint.
  int get contextL => (columnL + offsetL).clamp(0, 12);

  /// Total occupied width for the XL breakpoint.
  int get contextXL => (columnXL + offsetXL).clamp(0, 12);

  /// Clamped column span for the S breakpoint.
  int get columnS => colS.clamp(0, 12);

  /// Clamped column span for the M breakpoint.
  int get columnM => (colM ?? colS).clamp(0, 12);

  /// Clamped column span for the XM breakpoint.
  int get columnXM => (colXM ?? colM ?? colS).clamp(0, 12);

  /// Clamped column span for the L breakpoint.
  int get columnL => (colL ?? colXM ?? colM ?? colS).clamp(0, 12);

  /// Clamped column span for the XL breakpoint.
  int get columnXL => (colXL ?? colL ?? colXM ?? colM ?? colS).clamp(0, 12);
}
