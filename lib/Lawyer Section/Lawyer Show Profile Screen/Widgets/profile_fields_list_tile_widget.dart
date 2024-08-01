import 'package:flutter/material.dart';

class ProfileFieldsListTileWidget extends StatelessWidget {
  const ProfileFieldsListTileWidget({
    super.key,
    required this.titleValue,
    required this.trillValue,
    this.subtitleValue,
  });

  final String? titleValue;
  final String? trillValue;
  final String? subtitleValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            titleValue ?? '',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          subtitle: subtitleValue != null
              ? Text(
                  subtitleValue!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Text(
            trillValue ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        const Divider(
          height: 0,
          indent: 15,
          endIndent: 20,
          thickness: 2,
        ),
      ],
    );
  }
}
