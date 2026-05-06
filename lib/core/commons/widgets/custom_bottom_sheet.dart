import 'package:flutter/material.dart';

abstract class BottomSheetItem {
  String get displayTitle;
  String? get displaySubtitle => null;
  Widget? get leadingWidget => null;
}

enum BottomSheetDisplayMode { list, card }

class CustomBottomSheet<T extends BottomSheetItem> extends StatefulWidget {
  final String title;
  final List<T> items;
  final BottomSheetDisplayMode mode;
  final Color accentColor;
  final String searchHint;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.mode = BottomSheetDisplayMode.list,
    this.accentColor = Colors.blue,
    this.searchHint = 'Search…',
  });

  static Future<T?> show<T extends BottomSheetItem>({
    required BuildContext context,
    required String title,
    required List<T> items,
    BottomSheetDisplayMode mode = BottomSheetDisplayMode.list,
    Color accentColor = Colors.blue,
    String searchHint = 'Search…',
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => CustomBottomSheet<T>(
          title: title,
          items: items,
          mode: mode,
          accentColor: accentColor,
          searchHint: searchHint,
        ),
      );

  @override
  State<CustomBottomSheet<T>> createState() => _CustomBottomSheetState<T>();
}

class _CustomBottomSheetState<T extends BottomSheetItem>
    extends State<CustomBottomSheet<T>> {
  final _search = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _search.addListener(() {
      final q = _search.text.toLowerCase();
      setState(() {
        _filtered = q.isEmpty
            ? widget.items
            : widget.items
                .where((i) =>
                    i.displayTitle.toLowerCase().contains(q) ||
                    (i.displaySubtitle?.toLowerCase().contains(q) ?? false))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Widget _avatar(String title) => CircleAvatar(
        radius: 18,
        backgroundColor: widget.accentColor.withOpacity(0.1),
        child: Text(
          title.isNotEmpty ? title[0].toUpperCase() : '?',
          style: TextStyle(
              color: widget.accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 13),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // Title + search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(widget.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _search,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,
                              size: 18, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Body
            if (_filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off,
                          size: 40, color: Colors.grey.shade300),
                      const SizedBox(height: 10),
                      Text('No results found',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14)),
                    ],
                  ),
                ),
              )
            else if (widget.mode == BottomSheetDisplayMode.list)
              Expanded(
                child: ListView.separated(
                  controller: scroll,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) {
                    final item = _filtered[i];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: item.leadingWidget ?? _avatar(item.displayTitle),
                      title: Text(item.displayTitle,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: item.displaySubtitle != null
                          ? Text(item.displaySubtitle!,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500))
                          : null,
                      trailing: Icon(Icons.chevron_right,
                          color: Colors.grey.shade300),
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.all(14),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final item = _filtered[i];
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item.leadingWidget ??
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: widget.accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.displayTitle.isNotEmpty
                                          ? item.displayTitle[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                          color: widget.accentColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                            Text(item.displayTitle,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            if (item.displaySubtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(item.displaySubtitle!,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}