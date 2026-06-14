import "package:flutter/material.dart";

/// Returns a responsive value based on the current breakpoint.
///
/// The breakpoint is determined using either the provided [width] or the
/// screen width from [context].
///
/// Breakpoints:
/// - S: `< 600`
/// - M: `600 - 904`
/// - XM: `905 - 1239`
/// - L: `1240 - 1439`
/// - XL: `>= 1440`
///
/// If a value for the current breakpoint is not provided, the value from the
/// previous breakpoint is used.
///
/// Example:
/// ```dart
/// final columns = getResponsiveValue<int>(
///   context: context,
///   valueS: 12,
///   valueM: 6,
///   valueL: 4,
/// );
/// ```
///
/// Either [width] or [context] must be provided.
T getResponsiveValue<T>({
  T? valueM,
  T? valueXM,
  T? valueL,
  T? valueXL,
  double? width,
  required T valueS,
  BuildContext? context,
}) {
  assert(
    width != null || context != null,
    "Either width or context must be provided.",
  );

  final double maxWidth =
      width ?? ((context == null) ? 0 : MediaQuery.sizeOf(context).width);

  T value = valueS;
  if (maxWidth < 600) return value;

  value = valueM ?? value;
  if (maxWidth < 905) return value;

  value = valueXM ?? value;
  if (maxWidth < 1240) return value;

  value = valueL ?? value;
  if (maxWidth < 1440) return value;

  return valueXL ?? value;
}

/// Returns the pixel width occupied by a responsive column span in the
/// package's 12-column grid system.
///
/// The column span is resolved using the same breakpoint rules as
/// [getResponsiveValue].
///
/// Breakpoints:
/// - S: `< 600`
/// - M: `600 - 904`
/// - XM: `905 - 1239`
/// - L: `1240 - 1439`
/// - XL: `>= 1440`
///
/// If a value for the current breakpoint is not provided, the value from the
/// previous breakpoint is used.
///
/// Example:
/// ```dart
/// final width = getResponsiveColumnWidth(
///   context: context,
///   valueS: 12,
///   valueM: 6,
///   valueL: 4,
/// );
/// ```
///
/// Either [width] or [context] must be provided.
double getResponsiveColumnWidth({
  int? valueM,
  int? valueXM,
  int? valueL,
  int? valueXL,
  double? width,
  required int valueS,
  BuildContext? context,
}) {
  assert(
    width != null || context != null,
    "Either width or context must be provided.",
  );

  final double maxWidth =
      width ?? ((context == null) ? 0 : MediaQuery.sizeOf(context).width);

  int value = valueS;
  if (maxWidth < 600) return value * (maxWidth / 12);

  value = valueM ?? value;
  if (maxWidth < 905) return value * (maxWidth / 12);

  value = valueXM ?? value;
  if (maxWidth < 1240) return value * (maxWidth / 12);

  value = valueL ?? value;
  if (maxWidth < 1440) return value * (maxWidth / 12);

  value = valueXL ?? value;
  return value * (maxWidth / 12);
}
