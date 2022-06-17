import 'package:easel_flutter/models/draft.dart';
import 'package:floor/floor.dart';

@dao
abstract class DraftDao {
  @Query('SELECT * FROM draft')
  Future<List<Draft>> findAllDrafts();

  @Query('SELECT * FROM drafts WHERE id = :id')
  Stream<Draft?> findDraftById(int id);

  @insert
  Future<void> insertDraft(Draft drafts);

  @Query('DELETE FROM drafts WHERE id = :id')
  Future<void> delete(int id);
}
