import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/screens/base/contact/contact.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';

class ContactLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.contactScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
        key: ValueKey(AppPaths.routes.contactScreen),
        title:
            '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.contactScreen)}',
        child: const ContactScreen(),
      ),
    ];
    return pages;
  }
}
