import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/responsive_utils.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final bool useCard;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.useCard = true,
    this.maxWidth,
    this.padding,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = ResponsiveUtils.isWideScreen(constraints);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  maxWidth ?? ResponsiveUtils.getMaxContentWidth(constraints),
            ),
            child: Padding(
              padding:
                  padding ?? ResponsiveUtils.getContentPadding(isWideScreen),
              child: Container(
                padding:
                    contentPadding ??
                    ResponsiveUtils.getInnerPadding(isWideScreen),
                decoration:
                    useCard
                        ? ResponsiveUtils.getContainerDecoration(
                          isWideScreen,
                          context,
                        )
                        : null,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
