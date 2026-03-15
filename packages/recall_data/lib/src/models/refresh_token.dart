import 'package:jao/jao.dart';
import 'package:recall_data/src/models/user.dart';

part 'refresh_token.g.dart';

@Model(tableName: 'refresh_tokens')
class RefreshTokenEntry {
  @UuidPrimaryKey()
  late String id;

  @ForeignKey(AppUser, onDelete: OnDelete.cascade)
  late String userId;

  @CharField(maxLength: 255)
  late String tokenHash;

  @DateTimeField()
  late DateTime expiresAt;

  @DateTimeField(nullable: true)
  late DateTime? revokedAt;

  @DateTimeField(autoNowAdd: true)
  late DateTime createdAt;
}
