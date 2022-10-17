import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wger/helpers/i18n.dart';
import 'package:wger/models/exercises/base.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/providers/add_exercise_provider.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/screens/add_exercise_screen.dart';
import 'package:wger/widgets/exercises/exercises.dart';
import 'package:wger/widgets/exercises/forms.dart';

import '../../test_data/exercises.dart';
import '../other/base_provider_test.mocks.dart';
import '../utils.dart';
import 'add_exercise_screen_test.mocks.dart';

@GenerateMocks([AddExerciseProvider])
@GenerateMocks([ExercisesProvider])
void main() {
  late AddExerciseProvider mockAddExerciseProvider;
  late ExercisesProvider mockExercisesProvider;
  Type typesOf<T>(AddExerciseProvider mockAddExerciseProvider) => T;
  Type typeOf<T>() => T;
  final client = MockClient();

  setUp(() {
    mockAddExerciseProvider = MockAddExerciseProvider();
    mockExercisesProvider = MockExercisesProvider();

    // when(mockExercisesProvider.categories).thenReturn(<ExerciseCategory>['Abs']);

    when(mockAddExerciseProvider.addExercise()).thenAnswer((_) async {
      return Future.value(10);
    });

    when(mockExercisesProvider.fetchAndSetExerciseBase(10))
        .thenAnswer((_) => Future.value(ExerciseBase(
              id: 4,
              uuid: '361f024c-fdf8-4146-b7d7-0c1b67c58141',
              creationDate: DateTime(2021, 08, 01),
              updateDate: DateTime(2021, 08, 01),
              category: tCategory3,
              equipment: const [tEquipment2],
              muscles: const [tMuscle1],
              musclesSecondary: const [tMuscle2],
            )));
    
  });

  Widget createHomeScreen({locale = 'en'}) {
    return ChangeNotifierProvider<AddExerciseProvider>(
      create: (context) =>
          AddExerciseProvider(WgerBaseProvider(testAuthProvider, client)),
      child: ChangeNotifierProvider<ExercisesProvider>(
        create: (context) =>
            ExercisesProvider(WgerBaseProvider(testAuthProvider, client)),
        child: MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AddExerciseScreen(),
        ),
      ),
    );
  }

  testWidgets('Add excercise screen test for text fields at step number 1',
      (WidgetTester tester) async {
        mockAddExerciseProvider = MockAddExerciseProvider();
        mockExercisesProvider = MockExercisesProvider();
        when(mockAddExerciseProvider.addExercise()).thenAnswer((_) async {
          return Future.value(10);
        });
        when(mockExercisesProvider.categories).thenAnswer((_) => [
          const ExerciseCategory(id: 0, name: 'Abs'),
          const ExerciseCategory(id: 1, name: 'Arma'),
          const ExerciseCategory(id: 2, name: 'Back'),
          const ExerciseCategory(id: 3, name: 'Calves'),
          const ExerciseCategory(id: 4, name: 'Chest'),
          const ExerciseCategory(id: 5, name: 'Legs'),
          const ExerciseCategory(id: 6, name: 'Shoulders'),
        ]);


    when(mockExercisesProvider.fetchAndSetExerciseBase(10))
        .thenAnswer((_) => Future.value(ExerciseBase(
              id: 4,
              uuid: '361f024c-fdf8-4146-b7d7-0c1b67c58141',
              creationDate: DateTime(2021, 08, 01),
              updateDate: DateTime(2021, 08, 01),
              category: tCategory3,
              equipment: const [tEquipment2],
              muscles: const [tMuscle1],
              musclesSecondary: const [tMuscle2],
            )));

    await tester.pumpWidget(createHomeScreen());
    await tester.pumpAndSettle();

    expect(find.text('Contribute an exercise'), findsOneWidget);
    expect(find.text('Basics in English'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Name*'), findsOneWidget);
    expect(
        find.text('All exercises need a base name in English'), findsOneWidget);
    expect(find.text('Alternative names'), findsOneWidget);
    expect(find.text('One name per line'), findsOneWidget);
    expect(find.text('Category*'), findsOneWidget);
    expect(find.byType(typeOf<ExerciseCategoryInputWidget<ExerciseCategory>>()),
        findsOneWidget);
    expect(find.text('Equipment'), findsOneWidget);
    expect(find.text('Muscles'), findsNWidgets(2));
    expect(find.text('Secondary muscles'), findsNWidgets(2));
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    expect(find.byType(MuscleColorHelper), findsNWidgets(2));

    await tester.tap(
        find.byType(typeOf<ExerciseCategoryInputWidget<ExerciseCategory>>()));
    await tester.pumpAndSettle();
    // expect(find.byType(typeOf<DropdownMenuItem<ExerciseCategory>>()),findsOneWidget);
    // await tester.tap(find.byType(mockExercisesProvider.categories.runtimeType));
    // await tester.tap(find.text(getTranslation(context));
    // expect(
    //     find.byWidget(
    //         const DropdownMenuItem<ExerciseCategory>(child: Text('Abs'))),
    //     findsOneWidget);
        var form = GlobalKey<FormState>().currentState;
        expect(find.byKey(ValueKey(mockExercisesProvider.categories.first.id.toString())), findsOneWidget);
        // expect((form.validate()), 1);
      });

}
