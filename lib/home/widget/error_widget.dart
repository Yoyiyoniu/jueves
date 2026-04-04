import 'package:flutter/material.dart';
import 'package:jueves/home/home_controller.dart';
import 'package:jueves/theme/nothing_theme.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key, required HomeController controller})
    : _controller = controller;

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NothingTheme.spaceMd),
      decoration: BoxDecoration(
        border: Border.all(color: NothingTheme.accent, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '[!]',
            style: NothingTheme.spaceMonoLabel(
              fontSize: NothingTheme.body,
              color: NothingTheme.accent,
            ),
          ),
          const SizedBox(width: NothingTheme.spaceSm),
          Flexible(
            child: Text(
              _controller.errorMessage!,
              style: NothingTheme.spaceGroteskBody(
                fontSize: NothingTheme.caption,
                color: NothingTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
