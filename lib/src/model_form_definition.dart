import 'package:flutter/material.dart';

class ModelFormDefinition<T> {
  final String label;
  final TextInputType type;
  final T initialValue;
  final List<FormFieldValidator<String>> validators;
  final bool readOnly;
  final bool hidden;
  final bool isUUID;
  final T Function(String? valuee)? fromString;

  ModelFormDefinition({
    required this.label,
    required this.type,
    required this.validators,
    required this.initialValue,
    this.readOnly = false,
    this.hidden = false,
    this.isUUID = false,
    this.fromString,
  });
}
