import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/home/reset_password/reset_password.dart';

class ResetPasswordLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.resetPasswordScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final uri = Uri.parse(state.uri.toString());
    final String? token = uri.queryParameters['token'];
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.resetPasswordScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.resetPasswordScreen)}',
          child: ResetPasswordScreen(
            token: token,
          )),
    ];
    return pages;
  }
}
