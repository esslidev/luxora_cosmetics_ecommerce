import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/features/google_map.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/common/custom_text_field.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late ResponsiveSizeAdapter r;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildHeader() {
    return CustomField(
      gap: r.size(6),
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'recoleta',
              fontSize: r.size(26),
              color: Colors.black, // Default color for the text
            ),
            children: [
              const TextSpan(text: "Contactez "),
              TextSpan(
                text: "notre équipe.",
                style: TextStyle(
                  color: AppColors.light.primary, // Custom color for "Luxora"
                ),
              ),
            ],
          ),
        ),
        CustomText(
          text:
              "Vous avez une question, une suggestion ou besoin d’aide ? Notre équipe est là pour vous accompagner. N’hésitez pas à nous contacter via le formulaire ci-dessous ou par e-mail. Nous vous répondrons dans les plus brefs délais.",
          fontSize: r.size(8),
          color: AppColors.light.accent.withValues(alpha: .6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required String hint,

    required TextEditingController controller,
    TextInputType? keyboardType,
    double? height,
    int? minLines,
    int? maxLines = 1,
    Color? Function(String)? borderColorCallback,
    void Function(String value, Offset position, Size size)? onChanged,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        return CustomTextField(
          controller: controller,
          height: height,
          minLines: minLines,
          maxLines: maxLines,
          fontSize: r.size(9),

          fontWeight: FontWeight.normal,
          borderWidth: r.size(0.6),
          backgroundColor: AppColors.light.backgroundPrimary,
          hintText: hint,
          padding: r.symmetric(horizontal: 8, vertical: 4),
          keyboardType: keyboardType,
          borderColor:
              borderColorCallback != null
                  ? borderColorCallback(value.text)
                  : AppColors.light.primary.withValues(alpha: .8),
          onChanged: onChanged,
        );
      },
    );
  }

  Widget _buildSubmitButton({
    bool isEnabled = true,
    required Function() onPressed,
  }) {
    return CustomButton(
      text: 'Envoyer',
      fontWeight: FontWeight.bold,
      fontSize: r.size(9),
      backgroundColor: AppColors.light.primary,
      textColor: AppColors.colors.white,
      padding: r.symmetric(vertical: 6, horizontal: 30),
      enabled: isEnabled,
      border: Border.all(color: Colors.transparent, width: r.size(1)),
      animationDuration: 200.ms,
      onHoverStyle: CustomButtonStyle(
        border: Border.all(
          color: AppColors.light.accent.withValues(alpha: .2),
          width: r.size(1),
        ),
      ),
      onDisabledStyle: CustomButtonStyle(
        backgroundColor: AppColors.light.backgroundSecondary,
        textColor: AppColors.light.accent.withValues(alpha: 0.3),
      ),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  bool _areInputsValid() {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        AppUtil.isEmailValid(_emailController.text) &&
        _phoneController.text.trim().isNotEmpty &&
        AppUtil.isPhoneNumberValid(_phoneController.text);
  }

  Widget _buildForm() {
    return CustomField(
      gap: r.size(9),
      children: [
        _buildTextInput(
          hint: 'Votre nom',
          controller: _nameController,
          keyboardType: TextInputType.name,
          borderColorCallback: (value) {
            return value.trim().isNotEmpty
                ? AppColors.light.success
                : AppColors.light.primary.withValues(alpha: .8);
          },
        ),
        _buildTextInput(
          hint: 'Votre e-mail',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          borderColorCallback: (value) {
            return value != ''
                ? !AppUtil.isEmailValid(value)
                    ? AppColors.light.error
                    : AppColors.light.success
                : AppColors.light.primary.withValues(alpha: .8);
          },
        ),
        _buildTextInput(
          hint: 'Votre téléphone',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          borderColorCallback: (value) {
            return value != ''
                ? !AppUtil.isPhoneNumberValid(value)
                    ? AppColors.light.error
                    : AppColors.light.success
                : AppColors.light.primary.withValues(alpha: .8);
          },
        ),
        _buildTextInput(
          hint: 'Écrivez votre message',
          height: r.size(100),
          minLines: 1,
          maxLines: null,
          controller: _messageController,
          keyboardType: TextInputType.multiline,
          borderColorCallback: (value) {
            return value.trim().isNotEmpty
                ? AppColors.light.success
                : AppColors.light.primary.withValues(alpha: .8);
          },
        ),
        _buildSubmitButton(isEnabled: true, onPressed: () {}),
      ],
    );
  }

  Widget _buildContactCard({
    required String svgIconPath,
    required String title,
    required String value,
  }) {
    return CustomField(
      gap: r.size(12),
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        CustomDisplay(
          assetPath: svgIconPath,
          isSvg: true,
          svgColor: AppColors.colors.white,
          backgroundColor: AppColors.colors.lostInSadness,
          width: r.size(16),
          height: r.size(16),
          padding: r.all(10),
        ),
        CustomField(
          gap: r.size(2),
          children: [
            CustomText(
              text: title,
              fontSize: r.size(10),
              fontWeight: FontWeight.bold,
            ),
            CustomText(text: value, fontSize: r.size(9)),
          ],
        ),
      ],
    );
  }

  Widget _buildContact(
    BuildContext context, {
    bool? isDesktopScreen,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return CustomField(
      gap: r.size(40),
      padding: r.only(
        left: isDesktopScreen == true ? 20 : 120,
        right: isDesktopScreen == true ? 20 : 120,
        top: 30,
        bottom: 80,
      ),
      arrangement: FieldArrangement.row,
      children: [
        Expanded(
          flex: 3,
          child: CustomField(
            mainAxisAlignment: MainAxisAlignment.center,

            gap: r.size(20),
            children: [
              _buildHeader(),
              _buildForm(),
              CustomField(
                arrangement: FieldArrangement.row,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildContactCard(
                      svgIconPath: AppPaths.vectors.phoneIcon,
                      title: 'Numéro de téléphone',
                      value: phoneNumber,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildContactCard(
                      svgIconPath: AppPaths.vectors.emailIcon,
                      title: 'Adresse e-mail',
                      value: addressEmail,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: GoogleMap(mapUrl: mapLocationUrl, height: r.size(340)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildContact(context),
      screenDesktop: _buildContact(context, isDesktopScreen: true),
      screenTablet: _buildContact(context, isTabletScreen: true),
      screenMobile: _buildContact(context, isMobileScreen: true),
    );
  }
}
