import 'package:flutter/material.dart';
import 'package:pemobgenap/models/bmi_model.dart';

class HistoryList extends StatelessWidget {
  final List<BmiRecord> history;
  final VoidCallback onClearHistory;

  const HistoryList({
    Key? key,
    required this.history,
    required this.onClearHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (history.isNotEmpty)
                  TextButton(
                    onPressed: onClearHistory,
                    child: Text('Clear History'),
                  ),
              ],
            ),
            SizedBox(height: 10),
            if (history.isEmpty)
              Center(
                child: Text(
                  'No history yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return HistoryListItem(record: history[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final BmiRecord record;
  final VoidCallback? onTap;
  final Color? circleAvatarColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? chipTextStyle;
  final double circleAvatarRadius;
  const HistoryListItem({
    Key? key,
    required this.record,
    this.onTap,
    this.circleAvatarColor,
    this.titleStyle,
    this.subtitleStyle,
    this.chipTextStyle,
    this.circleAvatarRadius = 20,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final categoryColor =
        circleAvatarColor ?? BmiCategory.getColor(record.category);
    return ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: categoryColor,
          radius: circleAvatarRadius,
          child: Text(
            record.bmi.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${record.weight}kg / ${record.height}cm',
          style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(record.formattedDate, style: subtitleStyle),
        trailing: Chip(
            label: Text(
              record.category,
              style: chipTextStyle ?? TextStyle(color: Colors.white, fontSize: 12),
            ),
          backgroundColor: categoryColor,
        ),
    );
  }
}
