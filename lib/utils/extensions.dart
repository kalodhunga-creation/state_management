import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/models/obeservable_model.dart';

extension ProviderExtensions on BuildContext {
  T fetch<T>({bool listen = true}) => Provider.of<T>(this, listen: listen);
}

extension ObjectExtension<T> on T {
  Observable<T> observable([String? alias]) =>
      Observable<T>.initialized(this, alias);
}
