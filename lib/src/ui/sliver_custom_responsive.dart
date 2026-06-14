import "package:custom_responsive/src/ui/custom_div.dart";
import "package:custom_responsive/src/ui/custom_responsive.dart";
import "package:custom_responsive/src/utils/extensions.dart";
import "package:flutter/material.dart";

/// A sliver-based version of [CustomResponsive].
///
/// This widget provides the same responsive 12-column grid behavior as
/// [CustomResponsive], but is designed for use inside a
/// [CustomScrollView].
///
/// Each [CustomDiv] occupies a configurable number of columns at different
/// breakpoints and is automatically arranged into rows.
///
/// When the total occupied width of a row exceeds 12 columns, remaining
/// items are moved to the next row.
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverCustomResponsive(
///       children: [
///         CustomDiv(
///           colS: 12,
///           colM: 6,
///           child: Text("Left"),
///         ),
///         CustomDiv(
///           colS: 12,
///           colM: 6,
///           child: Text("Right"),
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class SliverCustomResponsive extends StatelessWidget {
  /// Padding applied around the entire grid.
  final EdgeInsets? padding;

  /// Grid items to display.
  final List<CustomDiv> children;

  /// How children should be placed along the main axis within each row.
  final MainAxisAlignment mainAxisAlignment;

  /// How children should be placed along the cross axis within each row.
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a sliver-based responsive 12-column grid.
  const SliverCustomResponsive({
    super.key,
    this.padding,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding ?? EdgeInsets.zero,
    sliver: SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final rows = _buildRowsData(context);

        final sliver = SliverList.builder(
          itemCount: rows.length,
          itemBuilder: (_, i) => _buildRow(rows[i], width),
        );

        return sliver;
      },
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
