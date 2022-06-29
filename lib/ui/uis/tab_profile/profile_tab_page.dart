import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_bloc/blocs/app_cubit.dart';
import 'package:flutter_base_bloc/commons/export_commons.dart';
import 'package:flutter_base_bloc/models/enums/load_status.dart';
import 'package:flutter_base_bloc/repositories/export_repositories.dart';
import 'package:flutter_base_bloc/router/application.dart';
import 'package:flutter_base_bloc/router/routers.dart';
import 'package:flutter_base_bloc/ui/uis/tab_profile/widgets/menu_item_widget.dart';
import 'package:flutter_base_bloc/ui/widgets/buttons/app_tint_button.dart';
import 'package:flutter_base_bloc/ui/widgets/images/app_cache_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_tab_cubit.dart';
import 'widgets/menu_header_widget.dart';

class ProfileTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileTabPageState();
  }
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  ProfileTabCubit? _cubit;

  @override
  void initState() {
    final repository = RepositoryProvider.of<AuthRepository>(context);
    _cubit = ProfileTabCubit(repository: repository);
    super.initState();
    _cubit?.stream.listen((state) {
      if (state.signOutStatus == LoadStatus.SUCCESS) {
        _onSignOutSuccess();
      }
    });
  }

  @override
  void dispose() {
    _cubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        children: [
          buildProfileWidget(),
          buildMenusWidget(),
          SizedBox(height: 10),
          buildSignOutButton(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildProfileWidget() {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (prev, current) {
        return prev.user != current.user;
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(20),
          height: 60,
          child: Row(
            children: [
              AppCircleAvatar(url: state.user?.avatarUrl ?? "", size: 60),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${state.user?.username ?? ""}",
                      style: AppTextStyle.whiteS18W800,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "View profile",
                      style: AppTextStyle.greyS14,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildMenusWidget() {
    return Column(
      children: [
        MenuHeaderWidget(title: "Lists"),
        MenuItemWidget(title: "Watchlist"),
        MenuItemWidget(title: "History"),
        MenuItemWidget(title: "Collection"),
        MenuItemWidget(title: "Personal Lists"),
        MenuItemWidget(title: "Reminders"),
        MenuItemWidget(title: "Hidden Items"),
        MenuHeaderWidget(title: "Settings"),
        MenuItemWidget(title: "Go Premium"),
        MenuItemWidget(title: "Settings"),
        MenuItemWidget(title: "Help & feedback"),
        MenuItemWidget(title: "About"),
      ],
    );
  }

  Widget buildSignOutButton() {
    return BlocBuilder<ProfileTabCubit, ProfileTabState>(
      bloc: _cubit,
      buildWhen: (prev, current) {
        return prev.signOutStatus != current.signOutStatus;
      },
      builder: (context, state) {
        final isLoading = state.signOutStatus == LoadStatus.LOADING;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: AppTintButton(
            title: 'Logout',
            isLoading: isLoading,
            onPressed: isLoading ? doNothing : _handleSignOut,
          ),
        );
      },
    );
  }

  void doNothing() {}

  void _handleSignOut() {
    _cubit?.signOut();
  }

  void _onSignOutSuccess() {
    Application.router?.navigateTo(context, Routes.root, clearStack: true);
  }
}
