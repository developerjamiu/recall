import 'package:jao/jao.dart';
import 'package:recall_data/src/models/user.dart';

part 'note.g.dart';

@Model(tableName: 'notes')
class AppNote {
  @UuidPrimaryKey()
  late String id;

  @ForeignKey(AppUser, onDelete: OnDelete.cascade)
  late String userId;

  @CharField(maxLength: 64)
  late String title;

  @TextField()
  late String content;

  @DateTimeField(autoNowAdd: true)
  late DateTime createdAt;

  @DateTimeField(autoNow: true)
  late DateTime updatedAt;
}
