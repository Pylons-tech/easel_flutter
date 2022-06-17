import 'package:floor/floor.dart';

@Entity(tableName: 'draft')
class Draft {
  @primaryKey
  final int? id;

  final String imageString;
  Draft(this.id, this.imageString);
}
