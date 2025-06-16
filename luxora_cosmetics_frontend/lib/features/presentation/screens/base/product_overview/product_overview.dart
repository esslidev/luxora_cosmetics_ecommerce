import 'package:flutter/material.dart';

import '../../../../../core/util/responsive_size_adapter.dart';

class ProductOverviewScreen extends StatefulWidget {
  final String? productId;

  const ProductOverviewScreen({super.key, this.productId});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
