class Rating {
  final int id;
  final int contractId;
  final int reviewerId;
  final int revieweeId;
  final int score;
  final String? comment;

  Rating({required this.id, required this.contractId, required this.reviewerId, required this.revieweeId, required this.score, this.comment});

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json['id'] ?? 0,
        contractId: json['contract_id'] ?? 0,
        reviewerId: json['reviewer_id'] ?? 0,
        revieweeId: json['reviewee_id'] ?? 0,
        score: json['score'] ?? 0,
        comment: json['comment'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'contract_id': contractId, 'reviewer_id': reviewerId, 'reviewee_id': revieweeId, 'score': score, 'comment': comment};
}
