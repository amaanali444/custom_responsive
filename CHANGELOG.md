# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

## [1.0.0] - 2026-06-13

### Added

- Initial public release.
- `CustomResponsive` responsive 12-column grid widget.
- `SliverCustomResponsive` support for use inside `CustomScrollView`.
- `CustomDiv` responsive grid item widget.
- Responsive column spans (`colS`, `colM`, `colXM`, `colL`, `colXL`).
- Responsive column offsets (`offsetS`, `offsetM`, `offsetXM`, `offsetL`, `offsetXL`).
- Nested responsive grid support via `children`.
- Width-aware layouts via `childBuilder`.
- `CustomDiv.space()` responsive vertical spacer.
- Optional padding, margin, and background color support.
- Shrink-wrapped layouts using `Column`.
- Eager scrollable layouts using `SingleChildScrollView`.
- Lazy scrollable layouts using `ListView.builder`.
- `getResponsiveValue()` utility for resolving values across breakpoints.
- `getResponsiveColumnWidth()` utility for calculating responsive grid widths.
- Automatic breakpoint value inheritance.
- Automatic column and offset clamping.
- Public API documentation and examples.
- MIT license.
