import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';

/// Form field that picks a date with [showDatePicker] and shows validator errors.
class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    required String label,
    required DateTime firstDate,
    required DateTime lastDate,
    String? helperText,
    bool clearable = false,
    ValueChanged<DateTime?>? onChanged,
    super.onSaved,
    super.validator,
  }) : super(
         builder: (field) {
           void update(DateTime? value) {
             field.didChange(value);
             onChanged?.call(value);
           }

           Future<void> pick() async {
             final today = DateUtils.dateOnly(DateTime.now());
             final picked = await showDatePicker(
               context: field.context,
               initialDate:
                   field.value ?? (today.isAfter(lastDate) ? lastDate : today),
               firstDate: firstDate,
               lastDate: lastDate,
               helpText: label,
             );
             if (picked != null) update(picked);
           }

           final value = field.value;
           return InkWell(
             onTap: pick,
             borderRadius: BorderRadius.circular(8),
             child: InputDecorator(
               isEmpty: value == null,
               decoration: InputDecoration(
                 labelText: label,
                 helperText: helperText,
                 errorText: field.errorText,
                 prefixIcon: const Icon(Icons.calendar_today_outlined),
                 suffixIcon: clearable && value != null
                     ? IconButton(
                         tooltip: 'Clear $label',
                         icon: const Icon(Icons.close),
                         onPressed: () => update(null),
                       )
                     : null,
               ),
               child: Text(value == null ? '' : Education.formatDate(value)),
             ),
           );
         },
       );
}
