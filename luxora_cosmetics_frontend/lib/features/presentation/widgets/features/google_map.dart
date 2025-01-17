import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../common/custom_text.dart';

class GoogleMap extends StatelessWidget {
  final String mapUrl;
  final double? width;
  final double? height;

  const GoogleMap({
    super.key,
    required this.mapUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveSizeAdapter(context);

    if (kIsWeb) {
      return SizedBox(
        height: height ?? r.size(100),
        width: width ?? double.infinity,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(mapUrl),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        height: r.size(100),
        width: double.infinity,
        child: const CustomText(
          text: 'Google maps only available for web',
          color: Colors.white,
        ),
      );
    }
  }
}
