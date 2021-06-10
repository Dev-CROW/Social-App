import 'package:flutter/material.dart';
import 'package:flutter_apprev/shared/cubit/states.dart';
import 'package:flutter_apprev/shared/network/local/cache/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  void changeAppMode({bool fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
      {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}