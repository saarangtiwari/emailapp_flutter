import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  @required
  final Stream<T> stream;
  final Function onError;
  @required
  final Function onSuccess;
  final Function onWaiting;
  const Observer(
      {Key key, this.onError, this.onSuccess, this.stream, this.onWaiting})
      : super(key: key);

  Function get _defaultOnWaiting =>
      (context) => Center(child: CircularProgressIndicator());

  Function get _defaultOnError => (context, error) => Text(error);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return (onError != null)
              ? onError(context, snapshot.error)
              : _defaultOnError(context, snapshot.error);
        }
        if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        } else {
          return (onWaiting != null)
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
