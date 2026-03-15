import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('Recall landing page smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ProviderScope(child: RecallApp()));

    expect(find.text('Recall'), findsWidgets);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Sign in with GitHub'), findsOneWidget);
    expect(find.text('Recall, built by Developer Jamiu.'), findsOneWidget);
  });
}
