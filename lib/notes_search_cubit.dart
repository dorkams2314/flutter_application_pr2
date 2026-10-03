import 'package:flutter_bloc/flutter_bloc.dart';

class NotesSearchCubit extends Cubit<String> {
  NotesSearchCubit() : super('');

  void search(String query) => emit(query.trim().toLowerCase());
}
