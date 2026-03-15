import 'package:jao/jao.dart';

part 'user.g.dart';

@Model(tableName: 'users')
class AppUser {
  @UuidPrimaryKey()
  late String id;

  @EmailField(unique: true)
  late String email;

  @CharField(maxLength: 100)
  late String firstName;

  @CharField(maxLength: 100)
  late String lastName;

  @CharField(maxLength: 20)
  late String provider;

  @CharField(maxLength: 255)
  late String providerId;

  @CharField(maxLength: 500, nullable: true)
  late String? avatarUrl;

  @DateTimeField(autoNowAdd: true)
  late DateTime createdAt;

  @DateTimeField(autoNow: true)
  late DateTime updatedAt;
}
