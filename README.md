# FitTrack Light (Flutter)

State management: **Provider**
Local storage: **SharedPreferences** (JSON-encoded) — fully offline, no cloud, no AI.

## Run it
```bash
flutter pub get
flutter run
```

## Structure
- `lib/models` — plain Dart data models (Water/Food/Workout/Weight entries, Goals, Profile)
- `lib/services/storage_service.dart` — the only file that touches SharedPreferences
- `lib/providers/app_provider.dart` — single ChangeNotifier holding all app state + business logic (daily totals, streaks, weekly charts)
- `lib/screens` — all 10 screens matching the reference design
- `lib/widgets/shared_widgets.dart` — reusable ring, cards, chips, bottom nav

## Notes
- All entries store a real `DateTime`, so daily resets, weekly charts and the day-streak counter are computed live — nothing is hardcoded.
- Editing goals, profile, or deleting any entry updates every screen instantly via `notifyListeners()`.
- "Clear All Data" wipes every SharedPreferences key the app owns and returns to onboarding.



<!-- claude 2 code with provider  and  shared preferences-->
