# Notes

A basic Flutter notes app with an English interface.

- Enter text and tap **Save** to add a note to the list below.
- Tap a note's **Edit note** icon, change the text, and tap **Save changes**.
- Tap **Cancel** to discard an edit.
- Tap a note's **Delete note** icon to remove it.
- Use **Search notes** to filter notes by text (case-insensitive).
- Empty or whitespace-only notes are rejected.

Search is managed by `NotesSearchCubit`. `BlocProvider` owns the Cubit, and
`BlocBuilder` rebuilds the note list whenever the search query changes.

Notes are kept in memory for the current app session and are cleared when the app restarts.

Run the app with `flutter run`.
