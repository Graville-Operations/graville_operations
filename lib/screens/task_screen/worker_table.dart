import 'package:flutter/material.dart';
import 'package:graville_operations/screens/task_screen/task_widget.dart';
import 'package:graville_operations/screens/task_screen/worker.dart';


class WorkersTable extends StatelessWidget {
  final List<Map<String, dynamic>> filteredWorkers;
  final List<int> selectedWorkerIds;
  final WorkerFilterParams filterParams;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasMore;
  final String searchQuery;
  final String searchText;
  final void Function(Map<String, dynamic>) onAdd;
  final void Function(String field, String order) onSort;
  final VoidCallback onLoadMore;

  const WorkersTable({
    super.key,
    required this.filteredWorkers,
    required this.selectedWorkerIds,
    required this.filterParams,
    required this.isLoading,
    required this.isFetchingMore,
    required this.hasMore,
    required this.searchQuery,
    required this.searchText,
    required this.onAdd,
    required this.onSort,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Icon(Icons.table_chart, size: 20, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'Workers',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (!isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    '${filteredWorkers.length} shown',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Body
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (filteredWorkers.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    searchQuery.isEmpty
                        ? 'No workers found'
                        : 'No workers match "$searchText"',
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            _buildTable(context),

          // Load more
          if (!isLoading && hasMore && filteredWorkers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: isFetchingMore
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton.icon(
                        onPressed: onLoadMore,
                        icon: const Icon(Icons.expand_more, size: 18),
                        label: const Text('Load more'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final containerWidth = constraints.maxWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: screenWidth < 600 ? screenWidth * 1.2 : containerWidth,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingRowColor:
                      MaterialStateProperty.all(Colors.grey[200]),
                ),
              ),
              child: DataTable(
                columnSpacing: screenWidth < 600 ? 12 : 20,
                horizontalMargin: screenWidth < 600 ? 8 : 12,
                headingRowHeight: screenWidth < 600 ? 44 : 48,
                dataRowHeight: screenWidth < 600 ? 52 : 56,
                columns: [
                  DataColumn(
                    label: SortableColumnLabel(
                      text: 'National ID',
                      field: 'national_id',
                      currentSortBy: filterParams.sortBy,
                      currentOrder: filterParams.order,
                      onSort: onSort,
                    ),
                  ),
                  DataColumn(
                    label: SortableColumnLabel(
                      text: 'Name',
                      field: 'first_name',
                      currentSortBy: filterParams.sortBy,
                      currentOrder: filterParams.order,
                      onSort: onSort,
                    ),
                  ),
                  DataColumn(
                    label: SortableColumnLabel(
                      text: 'Skill',
                      field: 'skill_type',
                      currentSortBy: filterParams.sortBy,
                      currentOrder: filterParams.order,
                      onSort: onSort,
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: filteredWorkers.map((worker) {
                  final isSelected = selectedWorkerIds.contains(worker['id']);
                  return DataRow(
                    color: isSelected
                        ? MaterialStateProperty.all(Colors.blue[50])
                        : null,
                    cells: [
                      DataCell(Text(worker['national_id'].toString())),
                      DataCell(Text(
                        worker['name'],
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(_buildSkillCell(worker)),
                      DataCell(
                        ElevatedButton(
                          onPressed: isSelected ? null : () => onAdd(worker),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.grey[300] : Colors.blue,
                            foregroundColor:
                                isSelected ? Colors.grey[600] : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8,
                            ),
                          ),
                          child: Text(
                            isSelected ? '✓ Added' : '+ Add',
                            style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillCell(Map<String, dynamic> worker) {
    final skill = worker['skill_type'] as String? ?? '';
    if (skill.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Text(
          skill,
          style: TextStyle(
            fontSize: 11,
            color: Colors.orange[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return Text('—', style: TextStyle(color: Colors.grey[400]));
  }
}