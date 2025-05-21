import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with HydratedMixin {
  ThemeBloc() : super(ThemeLight()) {
    hydrate();
    on<ThemeEvent>((event, emit) {
      if (state is ThemeLight) {
        emit(ThemeDark());
        return;
      }
      emit(ThemeLight());
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    if (json['theme'] == null) return null;
    return json['theme'] == 'dark' ? ThemeDark() : ThemeLight();
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'theme': state is ThemeDark ? 'dark' : 'light'};
  }
}
