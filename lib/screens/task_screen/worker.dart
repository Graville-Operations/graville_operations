class WorkerFilterParams {
  final String? skill;
  final String sortBy;
  final String order;
  final int limit;
  final int offset;

  const WorkerFilterParams({
    this.skill,
    this.sortBy = 'id',
    this.order = 'asc',
    this.limit = 20,
    this.offset = 0,
  });

  WorkerFilterParams copyWith({
    String? skill,
    String? sortBy,
    String? order,
    int? limit,
    int? offset,
    bool clearSkill = false,
  }) {
    return WorkerFilterParams(
      skill: clearSkill ? null : (skill ?? this.skill),
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}