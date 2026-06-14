import "package:custom_responsive/custom_responsive.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("getResponsiveValue", () {
    test("returns S value", () {
      expect(
        getResponsiveValue<int>(width: 500, valueS: 12, valueM: 6, valueL: 4),
        12,
      );
    });

    test("returns M value", () {
      expect(
        getResponsiveValue<int>(width: 700, valueS: 12, valueM: 6, valueL: 4),
        6,
      );
    });

    test("returns L value", () {
      expect(
        getResponsiveValue<int>(width: 1300, valueS: 12, valueM: 6, valueL: 4),
        4,
      );
    });

    test("falls back to previous breakpoint", () {
      expect(getResponsiveValue<int>(width: 1300, valueS: 12, valueM: 6), 6);
    });
  });

  group("getResponsiveColumnWidth", () {
    test("returns full width for 12 columns", () {
      expect(getResponsiveColumnWidth(width: 1200, valueS: 12), 1200);
    });

    test("returns half width for 6 columns", () {
      expect(getResponsiveColumnWidth(width: 1200, valueS: 6), 600);
    });

    test("uses responsive values", () {
      expect(
        getResponsiveColumnWidth(width: 1300, valueS: 12, valueM: 6, valueL: 3),
        moreOrLessEquals(325),
      );
    });
  });
}
