import 'package:flutter/material.dart';

import '../../../../../../../core/util/app_events_util.dart';

class WishlistDropdown extends StatefulWidget {
  const WishlistDropdown({super.key});

  @override
  State<WishlistDropdown> createState() => _WishlistDropdownState();
}

class _WishlistDropdownState extends State<WishlistDropdown> {
  @override
  void initState() {
    super.initState();
    AppEventsUtil.breadCrumbs.clearBreadCrumbs(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
