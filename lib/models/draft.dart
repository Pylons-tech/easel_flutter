import 'package:floor/floor.dart';

@Entity(tableName: 'draft')
class Draft {
  @primaryKey
  final int? id;

   String imageString;
  Draft(this.id, this.imageString);
}
