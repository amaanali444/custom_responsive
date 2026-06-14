import "package:custom_responsive/custom_responsive.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("renders child widgets", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomResponsive(
            children: [
              CustomDiv(child: Text("A")),
              CustomDiv(child: Text("B")),
            ],
          ),
        ),
      ),
    );

    expect(find.text("A"), findsOneWidget);
    expect(find.text("B"), findsOneWidget);
  });

  testWidgets("renders nested grids", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomResponsive(
            children: [
              CustomDiv(children: [CustomDiv(child: Text("Nested"))]),
            ],
          ),
        ),
      ),
    );

    expect(find.text("Nested"), findsOneWidget);
  });

  testWidgets("passes allocated width to childBuilder", (tester) async {
    double? receivedWidth;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 1200,
            child: CustomResponsive(
              children: [
                CustomDiv(
                  colS: 6,
                  childBuilder: (width) {
                    receivedWidth = width;
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(receivedWidth, isNotNull);
    expect(receivedWidth! > 0, isTrue);
  });

  testWidgets("CustomDiv.space creates spacer", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CustomResponsive(children: [CustomDiv.space(24)])),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).last);

    expect(sizedBox.height, 24);
  });

  testWidgets("SliverCustomResponsive renders", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomScrollView(
          slivers: [
            SliverCustomResponsive(
              children: [CustomDiv(child: Text("Sliver Item"))],
            ),
          ],
        ),
      ),
    );

    expect(find.text("Sliver Item"), findsOneWidget);
  });
}
