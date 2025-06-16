import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_constants.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({super.key});

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildLogo() {
    return CustomDisplay(assetPath: AppPaths.images.logo, height: r.size(60));
  }

  Widget _buildTitle(String title) {
    return CustomText(
      text: title,
      fontFamily: 'recoleta',
      fontSize: r.size(16),
      color: AppColors.light.accent,
    );
  }

  Widget _buildParagraph(String text) {
    return CustomText(
      text: text,
      fontSize: r.size(9),
      color: AppColors.light.accent.withValues(alpha: .8),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: r.size(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\u2022 ",
                        style: TextStyle(
                          fontSize: r.size(7.5),
                          color: AppColors.light.accent.withValues(alpha: .7),
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          text: item,
                          fontSize: r.size(7.5),
                          color: AppColors.light.accent.withValues(alpha: .7),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSection({
    required String title,
    required String paragraph,
    List<String>? bulletList,
  }) {
    return CustomField(
      gap: r.size(9),
      children: [
        _buildTitle(title),
        _buildParagraph(paragraph),
        if (bulletList != null && bulletList.isNotEmpty)
          _buildBulletList(bulletList),
      ],
    );
  }

  Widget _buildPolicies(BuildContext context, {bool? isCompact}) {
    return CustomField(
      gap: r.size(30),
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: r.only(
        left: isCompact == true ? 20 : 120,
        right: isCompact == true ? 20 : 120,
        top: 30,
        bottom: 80,
      ),
      children: [
        _buildLogo(),
        _buildSection(
          title: 'Politique de Confidentialité',
          paragraph:
              "Nous nous engageons à protéger vos données personnelles conformément à la Loi 09-08 relative à la protection des données à caractère personnel au Maroc.",
          bulletList: [
            "Les données collectées incluent : nom, prénom, adresse, numéro de téléphone, adresse e-mail.",
            "Ces données sont utilisées exclusivement pour le traitement de vos commandes et la communication avec vous.",
            "Nous ne partageons pas vos informations avec des tiers sans votre consentement explicite.",
            "Vous avez le droit d'accéder, de modifier ou de supprimer vos données personnelles à tout moment.",
            "Pour exercer vos droits, contactez-nous à : ${addressEmail}.",
          ],
        ),

        _buildSection(
          title: 'Conditions Générales de Vente',
          paragraph:
              "En accédant à notre site ou en passant commande, vous acceptez les présentes conditions générales.",
          bulletList: [
            "Tous les prix sont affichés en dirhams marocains (MAD) et incluent la TVA.",
            "Les produits disponibles peuvent être modifiés ou retirés sans préavis.",
            "Le paiement peut se faire par carte bancaire ou en espèces à la livraison (selon la zone de livraison).",
            "Une commande est considérée comme confirmée après réception du paiement ou de la confirmation de l’option de paiement à la livraison.",
            "En cas de litige, seuls les tribunaux marocains seront compétents.",
          ],
        ),

        _buildSection(
          title: 'Politique de Livraison et Retours',
          paragraph:
              "Nous faisons de notre mieux pour assurer une livraison rapide et fiable partout au Maroc.",
          bulletList: [
            "Les délais de livraison sont estimés entre 2 à 5 jours ouvrables.",
            "Les frais de livraison varient selon la ville et sont affichés lors de la commande.",
            "Vous pouvez retourner un produit dans un délai de 7 jours après réception, s’il est défectueux ou non conforme.",
            "Les produits ouverts, utilisés ou endommagés ne seront ni repris ni remboursés.",
            "Les frais de retour sont à la charge du client sauf si l’erreur est de notre part.",
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildPolicies(context),
      screenDesktop: _buildPolicies(context, isCompact: true),
      screenTablet: _buildPolicies(context, isCompact: true),
      screenMobile: _buildPolicies(context, isCompact: true),
    );
  }
}
