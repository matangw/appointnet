class LinkDetails {
  String creatorID;
  String groupId;
  late String url;
  late String code;

  LinkDetails({required this.groupId, required this.creatorID}) {
    code = groupId + creatorID;
  }

  Map<String, dynamic> toJson() {
    return {'groupId': groupId, 'creatorId': creatorID};
  }

  factory LinkDetails.fromJson(Map<String, dynamic> json) {
    return LinkDetails(groupId: json['groupId'], creatorID: json['creatorId']);
  }

  @override
  String toString() {
    return 'LinkDetails(groupId: $groupId, creatorId: $creatorID)';
  }
}
