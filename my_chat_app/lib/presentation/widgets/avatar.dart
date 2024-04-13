import 'package:flutter/material.dart';


class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey.shade400,
      ),
    );
  }
}
