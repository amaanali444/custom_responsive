import "package:custom_responsive/src/ui/custom_responsive.dart";
import "package:flutter/material.dart";

/// A responsive grid item used inside [CustomResponsive] and
/// [SliverCustomResponsive].
///
/// A [CustomDiv] occupies a configurable number of columns in a 12-column
/// grid and can optionally define offsets for each breakpoint.
///
/// Column values cascade from smaller breakpoints when not specified:
///
/// ```dart
/// CustomDiv(
///   colS: 12,
///   colM: 6,
/// )
/// ```
///
/// In this example:
/// - S uses `12` columns
/// - M uses `6` columns
/// - XM, L and XL also use `6` columns
///
/// A [CustomDiv] can display:
/// - A single [child]
/// - A width-aware [childBuilder]
/// - Nested responsive [children]
class CustomDiv extends StatelessWidget {
  /// Number of columns occupied at the S breakpoint.
  ///
  /// Valid values are between `0` and `12`.
  final int colS;

  /// Number of columns occupied at the M breakpoint.
  ///
  /// Falls back to [colS] when not provided.
  final int? colM;

  /// Number of columns occupied at the XM breakpoint.
  ///
  /// Falls back to [colM] or [colS] when not provided.
  final int? colXM;

  /// Number of columns occupied at the L breakpoint.
  ///
  /// Falls back to smaller breakpoints when not provided.
  final int? colL;

  /// Number of columns occupied at the XL breakpoint.
  ///
  /// Falls back to smaller breakpoints when not provided.
  final int? colXL;

  /// Column offset applied at the S breakpoint.
  final int offsetS;

  /// Column offset applied at the M breakpoint.
  final int offsetM;

  /// Column offset applied at the XM breakpoint.
  final int offsetXM;

  /// Column offset applied at the L breakpoint.
  final int offsetL;

  /// Column offset applied at the XL breakpoint.
  final int offsetXL;

  /// Background color applied to the content.
  final Color? color;

  /// Child widget displayed inside this grid item.
  final Widget? child;

  /// Margin applied outside the content.
  final EdgeInsets? margin;

  /// Padding applied inside the content.
  final EdgeInsets? padding;

  /// Builds content using the resolved width allocated to this grid item.
  ///
  /// Useful for widgets that need access to their available width.
  final Widget Function(double width)? childBuilder;

  /// Nested responsive grid items.
  ///
  /// When provided, a nested [CustomResponsive] is created automatically.
  final List<CustomDiv>? children;

  /// How nested children should be aligned along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How nested children should be aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a responsive grid item.
  const CustomDiv({
    super.key,
    this.colL,
    this.colXL,
    this.colXM,
    this.colM,
    this.color,
    this.child,
    this.margin,
    this.padding,
    this.colS = 12,
    this.offsetS = 0,
    this.offsetM = 0,
    this.offsetXM = 0,
    this.offsetL = 0,
    this.offsetXL = 0,
    this.childBuilder,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Creates a full-width vertical spacer.
  ///
  /// The spacer occupies all 12 columns for the enabled breakpoints and
  /// renders a [SizedBox] with the specified [spacing] height.
  ///
  /// Example:
  /// ```dart
  /// CustomDiv.space(24)
  /// ```
  ///
  /// To disable the spacer at specific breakpoints:
  ///
  /// ```dart
  /// CustomDiv.space(
  ///   24,
  ///   s: true,
  ///   m: false,
  /// )
  /// ```
  factory CustomDiv.space(
    double spacing, {
    bool s = true,
    bool? m,
    bool? xm,
    bool? l,
    bool? xl,
  }) => CustomDiv(
    colS: s ? 12 : 0,
    colM: (m ?? s) ? 12 : 0,
    colXM: (xm ?? m ?? s) ? 12 : 0,
    colL: (l ?? xm ?? m ?? s) ? 12 : 0,
    colXL: (xl ?? l ?? xm ?? m ?? s) ? 12 : 0,
    child: SizedBox(height: spacing),
  );

  @override
  Widget build(BuildContext context) {
    final hasChild =
        child != null ||
        childBuilder != null ||
        (children?.isNotEmpty ?? false);
    if (!hasChild) return const SizedBox.shrink();

    Widget content;
    if (childBuilder != null) {
      content = LayoutBuilder(
        builder: (_, constraints) => childBuilder!(constraints.maxWidth),
      );
    } else if ((children ?? []).isNotEmpty) {
      content = CustomResponsive(
        useBuilder: false,
        showScrollbar: false,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children ?? const [],
      );
    } else {
      content = child!;
    }

    if (padding != null) content = Padding(padding: padding!, child: content);
    if (color != null) content = ColoredBox(color: color!, child: content);
    if (margin != null) content = Padding(padding: margin!, child: content);
    return content;
  }
}
