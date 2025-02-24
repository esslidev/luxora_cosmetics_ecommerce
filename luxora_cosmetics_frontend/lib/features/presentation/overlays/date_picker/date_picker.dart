import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/util/translation_service.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_field.dart';

class DatePickerOverlay {
  final BuildContext context;
  ResponsiveSizeAdapter r;

  DatePickerOverlay({
    required this.context,
    required this.r,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  Future<void> show(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      DateTime? initialDate,
      Function()? onDateCleared,
      Function(DateTime newDate)? onDateChanged}) async {
    if (isShown()) {
      toggle = false;
      await Future.delayed(300.ms);
      return; // Prevents adding multiple overlays.
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: true,
            color: Colors.black.withValues(alpha: 0.6),
            onDismiss: dismiss,
          ).animate(target: toggle ? 1 : 0).fade(
                duration: 300.ms,
                curve: Curves.decelerate,
              ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: _buildOverlay(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                initialDate: initialDate,
                onDateCleared: onDateCleared,
                onDateChanged: onDateChanged,
              ).animate(target: toggle ? 1 : 0).fade(
                    duration: 250.ms,
                  ),
            ),
          ),
        ],
      ),
    );
    toggle = true;
    Overlay.of(context).insert(_overlayEntry!);
  }

  void dismiss() {
    if (isShown()) {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      // Delay the removal to allow the animation to play
      Future.delayed(300.ms, () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  bool isShown() {
    return _overlayEntry != null;
  }

  //---------------------------------------//

  Widget _buildOverlay({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    DateTime? initialDate,
    Function()? onDateCleared,
    Function(DateTime newDate)? onDateChanged,
  }) {
    DateTime selectedDate = initialDate ?? DateTime.now();
    return CustomField(
      width: r.size(240),
      padding: r.all(8),
      margin: r.symmetric(horizontal: 6, vertical: 10),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      borderColor: theme.accent.withValues(alpha: 0.3),
      borderRadius: r.size(3),
      clipBehavior: Clip.hardEdge,
      gap: r.size(4),
      backgroundColor: theme.secondaryBackgroundColor,
      mainAxisSize: MainAxisSize.min,
      children: [
        SfDateRangePicker(
          view: DateRangePickerView.month,
          showNavigationArrow: true,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          initialSelectedDate: initialDate,
          minDate: DateTime.now(),
          backgroundColor: Colors.transparent,
          selectionColor: theme.primary,
          todayHighlightColor: theme.primary,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.transparent,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: r.size(14),
            ),
          ),
          headerHeight: r.size(30),
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(
                  fontSize: r.size(8),
                  fontWeight: FontWeight.bold,
                  color: theme.accent.withValues(alpha: .5)),
            ),
            firstDayOfWeek: isRtl ? 7 : 1, // Customizing for RTL if needed
            weekendDays: const [DateTime.saturday, DateTime.sunday],
            dayFormat: 'EEE', // Use three-letter abbreviation for days
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: TextStyle(
              fontSize: r.size(9),
            ),
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            selectedDate = args.value;
          },
        ),
        CustomField(
            gap: r.size(8),
            mainAxisAlignment: MainAxisAlignment.end,
            arrangement: FieldArrangement.row,
            children: [
              CustomButton(
                text: ts.translate('Annuler'),
                fontSize: r.size(8),
                fontWeight: FontWeight.bold,
                textColor: theme.primary,
                border: Border.all(color: theme.primary, width: r.size(1)),
                borderRadius: BorderRadius.circular(r.size(1)),
                padding: r.symmetric(vertical: 2, horizontal: 8),
                onPressed: (position, size) {
                  dismiss();
                },
              ),
              CustomButton(
                text: ts.translate('Effacer'),
                fontSize: r.size(8),
                fontWeight: FontWeight.bold,
                textColor: theme.primary,
                border: Border.all(color: theme.primary, width: r.size(1)),
                borderRadius: BorderRadius.circular(r.size(1)),
                padding: r.symmetric(vertical: 2, horizontal: 8),
                onPressed: (position, size) {
                  if (onDateCleared != null) {
                    onDateCleared();
                    dismiss();
                  }
                  dismiss();
                },
              ),
              CustomButton(
                text: ts.translate('Confirmer'),
                fontSize: r.size(8),
                fontWeight: FontWeight.bold,
                backgroundColor: theme.primary,
                textColor: Colors.white,
                border: Border.all(color: theme.primary, width: r.size(1)),
                borderRadius: BorderRadius.circular(r.size(1)),
                padding: r.symmetric(vertical: 2, horizontal: 8),
                onPressed: (position, size) {
                  if (onDateChanged != null) {
                    onDateChanged(selectedDate);
                    dismiss();
                  }
                },
              ),
            ])
      ],
    );
  }
}
