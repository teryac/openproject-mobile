import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class DurationTextFormField extends StatefulWidget {
  const DurationTextFormField({
    super.key,
    // The "controlled" value from the parent state (e.g., Cubit)
    required this.value,
    // Callback to update the parent state (e.g., Cubit)
    required this.onChanged,
    // Functions for parsing/formatting (from Application Controller)
    required this.durationParser,
    required this.durationFormatter,
    required this.hint,
  });

  /// The current duration from your state management (e.g., Cubit).
  final Duration? value;

  /// Called when the parsed duration changes.
  final ValueChanged<Duration?> onChanged;

  /// A function that parses a String into a Duration.
  /// Example: (value) => getDurationFromDecimalHoursString(value)
  final Duration? Function(String) durationParser;

  /// A function that formats a Duration into a String.
  /// Example: (duration) => formatDurationToDecimalHours(duration)
  final String Function(Duration?) durationFormatter;

  // Standard styling
  final String hint;

  @override
  // ignore: library_private_types_in_public_api
  _DurationTextFormFieldState createState() => _DurationTextFormFieldState();
}

class _DurationTextFormFieldState extends State<DurationTextFormField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 1. Set the initial text value from the duration
    _controller.text = widget.durationFormatter(widget.value);

    // 2. Add listener to re-format the text when the user taps away
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DurationTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 3. This is the "controlled" component logic.
    // If the parent (Cubit) sends a new `Duration` value...
    if (widget.value != oldWidget.value) {
      // ...and the user is NOT currently typing in the field...
      if (!_focusNode.hasFocus) {
        // ...update the controller's text to match the new formatted value.
        final newText = widget.durationFormatter(widget.value);
        if (_controller.text != newText) {
          _controller.text = newText;
        }
      }
      // If the user *is* focused, we intentionally do nothing.
      // The user's input wins, preventing the cursor-jump issue.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// When the field loses focus, clean and format its content.
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // 1. Get the current text
      String text = _controller.text;

      // 2. Clean up trailing decimal points (e.g., "2." -> "2")
      if (text.endsWith('.')) {
        text = text.substring(0, text.length - 1);
      }

      // 3. Parse the *cleaned* text
      final currentDuration = widget.durationParser(text);

      // 4. Update the parent (Cubit) if this cleaned duration is
      //    different from what the parent currently has.
      //    (e.g., parent has `null` from "2.", we now want `Duration` from "2")
      if (currentDuration != widget.value) {
        widget.onChanged(currentDuration);
      }

      // 5. Format and set the controller text.
      //    This gives the user instant feedback.
      _controller.text = widget.durationFormatter(currentDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      hint: widget.hint,
      controller: _controller,
      focusNode: _focusNode,
      validator: (value) {
        // This validation logic is still part of the "UI" layer
        if (value == null || value.isEmpty) {
          return null; // Valid
        }
        if (value == ".") return 'Please enter a valid number.';

        final hours = double.tryParse(value);
        if (hours == null) {
          return 'Please enter a valid number (e.g., 1.5)';
        }
        if (hours < 0) {
          return 'Hours cannot be negative.';
        }
        return null; // All good
      },
      // Use the standard decimal number pad
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        // 5. On every keystroke, parse the current text...
        final newDuration = widget.durationParser(value);

        // ...and immediately call the onChanged callback.
        // This updates the Cubit in real-time.
        widget.onChanged(newDuration);
      },
    );
  }
}
