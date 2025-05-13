import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipRRect(
        child: MaterialButton(
          onPressed: onPressed,
          color:
              isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          padding: EdgeInsets.all(25),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
