import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_bloc/commons/export_commons.dart';

class TvShowTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TvShowTabPageState();
  }
}

class _TvShowTabPageState extends State<TvShowTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
    );
  }
}
