import 'package:flutter/material.dart';

import '../../../../../../../core/util/app_events_util.dart';

class UserDropdown extends StatefulWidget {
  const UserDropdown({super.key});

  @override
  State<UserDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
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
