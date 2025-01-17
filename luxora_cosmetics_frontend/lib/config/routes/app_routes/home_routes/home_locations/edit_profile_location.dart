import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/home/edit_profile/edit_profile.dart';

class EditProfileLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.editProfileScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.editProfileScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.editProfileScreen)}',
          child: const EditProfileScreen()),
    ];
    return pages;
  }
}
