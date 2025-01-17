import 'package:flutter/material.dart';

import '../../../../../core/util/app_events_util.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
