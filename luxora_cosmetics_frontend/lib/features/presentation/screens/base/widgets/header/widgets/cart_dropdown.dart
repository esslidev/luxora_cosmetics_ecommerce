import 'package:flutter/material.dart';

import '../../../../../../../core/util/app_events_util.dart';

class CartDropdown extends StatefulWidget {
  const CartDropdown({super.key});

  @override
  State<CartDropdown> createState() => _CartDropdownState();
}

class _CartDropdownState extends State<CartDropdown> {
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
