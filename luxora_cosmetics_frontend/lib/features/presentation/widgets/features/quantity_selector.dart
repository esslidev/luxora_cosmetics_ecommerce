import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/util/custom_timer.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../common/custom_button.dart';
import '../common/custom_field.dart';
import '../common/custom_text_field.dart';

class QuantitySelector extends StatefulWidget {
  final BaseTheme theme;
  final bool isRtl;
  final int initialQuantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;
  final bool enabled;
  final Duration? delayResponse;

  const QuantitySelector({
    super.key,
    required this.theme,
    required this.isRtl,
    this.initialQuantity = 1,
    this.minQuantity = 1,
    this.maxQuantity = 100,
    this.enabled = true,
    this.delayResponse,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late ResponsiveSizeAdapter r;
  late TextEditingController quantityTextFieldController;
  CustomTimer? _responseDelayTimer;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    quantityTextFieldController =
        TextEditingController(text: '${widget.initialQuantity}');
  }

  void updateQuantity(int newQuantity) {
    if (newQuantity >= 0 &&
        newQuantity >= widget.minQuantity &&
        newQuantity <= widget.maxQuantity) {
      setState(() {
        quantityTextFieldController.text = '$newQuantity';
      });
      onQuantityChanged(
          quantity: newQuantity, delay: widget.delayResponse ?? 0.ms);
    } else if (newQuantity > widget.maxQuantity) {
      setState(() {
        quantityTextFieldController.text = '${widget.maxQuantity}';
      });
      onQuantityChanged(
          quantity: widget.maxQuantity, delay: widget.delayResponse ?? 0.ms);
    } else if (newQuantity < widget.minQuantity) {
      onQuantityChanged(
          quantity: widget.minQuantity, delay: widget.delayResponse ?? 0.ms);
    }
  }

  void onQuantityChanged({required int quantity, required Duration delay}) {
    _responseDelayTimer?.stop();
    _responseDelayTimer = CustomTimer(
      onTick: (_) {},
      onTimerStop: () {
        widget.onQuantityChanged(quantity);
      },
    );
    _responseDelayTimer!.start(duration: delay);
  }

  @override
  void dispose() {
    quantityTextFieldController.dispose();
    _responseDelayTimer?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomField(
      isRtl: widget.isRtl,
      gap: r.size(2),
      arrangement: FieldArrangement.row,
      children: [
        CustomButton(
          width: r.size(16),
          height: r.size(16),
          svgIconPath: AppPaths.vectors.minusIcon,
          iconWidth: r.size(8),
          iconColor: widget.theme.accent,
          backgroundColor: widget.theme.secondaryBackgroundColor,
          enabled: widget.enabled,
          onDisabledStyle: CustomButtonStyle(
            iconColor: widget.theme.accent.withOpacity(0.4),
          ),
          border: Border.all(
              color: widget.theme.accent.withOpacity(0.4), width: r.size(0.6)),
          borderRadius: BorderRadius.circular(r.size(1)),
          animationDuration: 300.ms,
          onHoverStyle: CustomButtonStyle(
            border: Border.all(color: widget.theme.secondary, width: r.size(1)),
          ),
          onPressed: (position, size) {
            int parsedValue =
                int.tryParse(quantityTextFieldController.text) ?? 0;
            updateQuantity(parsedValue - 1);
          },
        ),
        CustomTextField(
          controller: quantityTextFieldController,
          width: r.size(30),
          height: r.size(16),
          hintText: '${widget.minQuantity}',
          borderRadius: BorderRadius.circular(r.size(1)),
          border: Border.all(
              color: widget.theme.accent.withOpacity(0.4), width: r.size(0.6)),
          backgroundColor: widget.theme.secondaryBackgroundColor,
          fontSize: r.size(8),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          enabled: widget.enabled,
          onChanged: (value, position, size) {
            int parsedValue = int.tryParse(value) ?? widget.minQuantity;
            updateQuantity(parsedValue);
          },
        ),
        CustomButton(
          width: r.size(16),
          height: r.size(16),
          svgIconPath: AppPaths.vectors.plusIcon,
          iconWidth: r.size(8),
          enabled: widget.enabled,
          onDisabledStyle: CustomButtonStyle(
            iconColor: widget.theme.accent.withOpacity(0.4),
          ),
          iconColor: widget.theme.accent,
          backgroundColor: widget.theme.secondaryBackgroundColor,
          border: Border.all(
              color: widget.theme.accent.withOpacity(0.4), width: r.size(0.6)),
          borderRadius: BorderRadius.circular(r.size(1)),
          animationDuration: 300.ms,
          onHoverStyle: CustomButtonStyle(
            border: Border.all(color: widget.theme.secondary, width: r.size(1)),
          ),
          onPressed: (position, size) {
            int parsedValue =
                int.tryParse(quantityTextFieldController.text) ?? 0;
            updateQuantity(parsedValue + 1);
          },
        ),
      ],
    );
  }
}
