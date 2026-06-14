import "package:custom_responsive/src/ui/custom_div.dart";
import "package:custom_responsive/src/utils/extensions.dart";
import "package:flutter/material.dart";

/// A responsive 12-column grid layout widget.
///
/// Each [CustomDiv] occupies a configurable number of columns at different
/// breakpoints and is automatically arranged into rows.
///
/// Column spans and offsets are resolved using the values defined on each
/// [CustomDiv]. When the total occupied width of a row exceeds 12 columns,
/// remaining items are moved to the next row.
///
/// Example:
/// ```dart
/// CustomResponsive(
///   children: [
///     CustomDiv(
///       colS: 12,
///       colM: 6,
///       child: Text("Left"),
///     ),
///     CustomDiv(
///       colS: 12,
///       colM: 6,
///       child: Text("Right"),
///     ),
///   ],
/// )
/// ```
///
/// By default, the widget sizes itself to its content. For scrollable layouts,
/// set [shrinkWrap] to `false`.
class CustomResponsive extends StatelessWidget {
  /// Whether the grid should size itself to its content.
  ///
  /// When `true`, a non-scrollable [Column] is used and the widget occupies
  /// only the space required by its children.
  ///
  /// When `false`, the grid becomes scrollable.
  final bool shrinkWrap;

  /// Controls how rows are built when [shrinkWrap] is `false`.
  ///
  /// - `true` uses a lazy [ListView.builder].
  /// - `false` uses a [SingleChildScrollView] with a [Column].
  ///
  /// This property has no effect when [shrinkWrap] is `true`.
  final bool useBuilder;

  /// Whether scrollbars should be shown for scrollable layouts.
  final bool showScrollbar;

  /// Padding applied around the entire grid.
  final EdgeInsets? padding;

  /// Grid items to display.
  final List<CustomDiv> children;

  /// Scroll controller used when the grid is scrollable.
  final ScrollController? controller;

  /// How children should be placed along the main axis within each row.
  final MainAxisAlignment mainAxisAlignment;

  /// How children should be placed along the cross axis within each row.
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a responsive 12-column grid.
  const CustomResponsive({
    super.key,
    this.padding,
    this.controller,
    required this.children,
    this.shrinkWrap = true,
    this.useBuilder = false,
    this.showScrollbar = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      var width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.sizeOf(context).width;
      if (padding != null) width -= padding!.horizontal;

      final rows = _buildRowsData(context);

      final scrollBehavior = ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: showScrollbar);

      return ScrollConfiguration(
        behavior: scrollBehavior,
        child: shrinkWrap
            ? _buildColumn(rows, width)
            : useBuilder
            ? _buildLazyList(rows, width)
            : _buildEagerList(rows, width),
      );
    },
  );

  Widget _buildColumn(List<List<_ResolvedSpan>> rows, double width) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((r) => _buildRow(r, width)).toList(),
    ),
  );

  Widget _buildLazyList(List<List<_ResolvedSpan>> rows, double width) =>
      ListView.builder(
        padding: padding,
        controller: controller,
        itemCount: rows.length,
        itemBuilder: (_, i) => _buildRow(rows[i], width),
      );

  Widget _buildEagerList(List<List<_ResolvedSpan>> rows, double width) =>
      SingleChildScrollView(
        padding: padding,
        controller: controller,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: rows.map((r) => _buildRow(r, width)).toList(),
        ),
      );

  List<_ResolvedSpan> _resolveAll(BuildContext context) {
    final out = <_ResolvedSpan>[];
    for (final d in children) {
      final cols = d.columns(context);
      if (cols == 0) continue;
      final off = d.offset(context).clamp(0, 12 - cols);
      out.add(_ResolvedSpan(d, cols, off, (cols + off).clamp(0, 12)));
    }
    return out;
  }

  List<List<_ResolvedSpan>> _buildRowsData(BuildContext context) {
    final resolved = _resolveAll(context);
    final rows = <List<_ResolvedSpan>>[];
    var curr = <_ResolvedSpan>[];
    var span = 0;
    for (final r in resolved) {
      if (span + r.total <= 12) {
        curr.add(r);
        span += r.total;
      } else {
        if (curr.isNotEmpty) rows.add(curr);
        curr = <_ResolvedSpan>[r];
        span = r.total;
      }
    }
    if (curr.isNotEmpty) rows.add(curr);
    return rows;
  }

  Widget _buildRow(List<_ResolvedSpan> row, double width) {
    final colW = width / 12;
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: row.map((r) => _buildRowItem(r, colW)).toList(),
      ),
    );
  }

  Widget _buildRowItem(_ResolvedSpan r, double colW) {
    final totalW = r.total * colW;
    final childW = r.cols * colW;
    return SizedBox(
      width: totalW,
      child: Padding(
        padding: EdgeInsets.only(left: r.offset * colW),
        child: SizedBox(width: childW, child: r.div),
      ),
    );
  }
}

class _ResolvedSpan {
  final CustomDiv div;
  final int cols;
  final int offset;
  final int total;

  const _ResolvedSpan(this.div, this.cols, this.offset, this.total);
}
