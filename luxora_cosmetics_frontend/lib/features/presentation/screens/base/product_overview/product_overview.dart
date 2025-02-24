import 'package:flutter/material.dart';

import '../../../../../core/util/app_events_util.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
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
