import 'package:easel_flutter/models/draft.dart';
import 'package:floor/floor.dart';

@dao
abstract class DraftDao {
  @Query('SELECT * FROM Draft')
  Future<List<Draft>> findAllDrafts();

  @Query('SELECT * FROM Draft WHERE id = :id')
  Stream<Draft?> findDraftById(int id);

  @insert
  Future<void> insertDraft(Draft draft);

  @Query('DELETE FROM Draft WHERE id = :id')
  Future<void> delete(int id);
}
