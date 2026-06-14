# 📱 custom_responsive

A lightweight Bootstrap-style 12-column responsive grid system for Flutter.

`custom_responsive` helps you build adaptive layouts using responsive column spans, offsets, nested grids, sliver support, and width-aware builders without manually handling screen sizes.

---

## 🚀 Features

- 12-column responsive grid system
- Breakpoint-based layout control (`S`, `M`, `XM`, `L`, `XL`)
- Column offsets for precise positioning
- Nested responsive grids
- Width-aware builders
- Sliver support
- Scrollable or shrink-wrapped layouts
- Custom padding, margin, and color styling
- Lazy or eager rendering options

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  custom_responsive: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 📏 Breakpoints

| Breakpoint | Width       |
| ---------- | ----------- |
| S          | < 600       |
| M          | 600 - 904   |
| XM         | 905 - 1239  |
| L          | 1240 - 1439 |
| XL         | ≥ 1440      |

Values automatically cascade to larger breakpoints when not provided.

Example:

```dart
CustomDiv(
  colS: 12,
  colM: 6,
)
```

is equivalent to:

```dart
CustomDiv(
  colS: 12,
  colM: 6,
  colXM: 6,
  colL: 6,
  colXL: 6,
)
```

---

## 🧱 Basic Usage

```dart
import 'package:custom_responsive/custom_responsive.dart';

CustomResponsive(
  children: [
    CustomDiv(
      colS: 12,
      colM: 6,
      colL: 4,
      child: Container(
        height: 100,
        color: Colors.red,
      ),
    ),
    CustomDiv(
      colS: 12,
      colM: 6,
      colL: 8,
      child: Container(
        height: 100,
        color: Colors.blue,
      ),
    ),
  ],
)
```

---

## ↔️ Column Offsets

Offsets allow you to shift items horizontally within the grid.

```dart
CustomResponsive(
  children: [
    CustomDiv(
      colS: 6,
      offsetS: 3,
      child: Container(
        height: 100,
        color: Colors.green,
      ),
    ),
  ],
)
```

---

## 🪆 Nested Grids

Create responsive layouts inside other responsive layouts.

```dart
CustomResponsive(
  children: [
    CustomDiv(
      colS: 12,
      children: [
        CustomDiv(
          colS: 12,
          colM: 6,
          child: Text("Left"),
        ),
        CustomDiv(
          colS: 12,
          colM: 6,
          child: Text("Right"),
        ),
      ],
    ),
  ],
)
```

---

## 📐 Width-Aware Builders

Use `childBuilder` when a widget needs to know its allocated width.

```dart
CustomDiv(
  colS: 12,
  colM: 6,
  childBuilder: (width) {
    return Text(
      "Available width: ${width.toStringAsFixed(0)}",
    );
  },
)
```

---

## 🧪 Responsive Spacer

Create responsive vertical spacing using `CustomDiv.space`.

```dart
CustomResponsive(
  children: [
    CustomDiv(
      colS: 12,
      child: Text("Section A"),
    ),

    CustomDiv.space(24),

    CustomDiv(
      colS: 12,
      child: Text("Section B"),
    ),
  ],
)
```

You can enable or disable the spacer for specific breakpoints:

```dart
CustomDiv.space(
  24,
  s: true,
  m: false,
  l: true,
)
```

---

## 📜 Scroll Behavior

### Shrink Wrapped (Default)

Uses a regular `Column` and sizes itself to its content.

```dart
CustomResponsive(
  children: [...],
)
```

### Eager Scrollable

Uses `SingleChildScrollView` and builds all rows immediately.

```dart
CustomResponsive(
  shrinkWrap: false,
  children: [...],
)
```

### Lazy Scrollable

Uses `ListView.builder` and lazily builds rows.

```dart
CustomResponsive(
  shrinkWrap: false,
  useBuilder: true,
  children: [...],
)
```

---

## 🪝 Sliver Support

Use `SliverCustomResponsive` inside a `CustomScrollView`.

```dart
CustomScrollView(
  slivers: [
    SliverCustomResponsive(
      children: [
        CustomDiv(
          colS: 12,
          colM: 6,
          child: Container(
            height: 100,
            color: Colors.orange,
          ),
        ),
        CustomDiv(
          colS: 12,
          colM: 6,
          child: Container(
            height: 100,
            color: Colors.purple,
          ),
        ),
      ],
    ),
  ],
)
```

---

## 🧠 Responsive Utilities

### getResponsiveValue

Returns a value based on the current breakpoint.

```dart
final columns = getResponsiveValue<int>(
  context: context,
  valueS: 12,
  valueM: 6,
  valueL: 4,
);
```

### getResponsiveColumnWidth

Returns the pixel width occupied by a responsive column span.

```dart
final width = getResponsiveColumnWidth(
  context: context,
  valueS: 12,
  valueM: 6,
  valueL: 4,
);
```

---

## 📌 Notes

- The grid uses a 12-column layout system.
- Column values are automatically clamped to the range `0-12`.
- Offsets are automatically clamped to valid values.
- Items automatically wrap to a new row when the current row exceeds 12 columns.
- Nested grids are fully supported.

---

## 📜 License

MIT License. See the LICENSE file for details.

---

## 💬 Feedback & Contributions

Issues, feature requests, and pull requests are welcome.

---

Made with ❤️ by Amaan
