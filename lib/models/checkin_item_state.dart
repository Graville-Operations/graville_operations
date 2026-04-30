import 'package:graville_operations/models/store_checkin_model.dart';

enum CheckInStatus { pending, checkedIn, hasIssue }

class CheckInItemState {
  final StoreItem item;
  CheckInStatus status;
  String? issueComment;

  CheckInItemState({
    required this.item,
    this.status = CheckInStatus.pending,
    this.issueComment,
  });

  Map<String, dynamic> toJson() => item.toCheckInJson(
        isCheckedIn: status == CheckInStatus.checkedIn,
        issueComment: issueComment,
      );
}
