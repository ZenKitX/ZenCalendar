part of 'app_pages.dart';

/// 路由名称常量
abstract class Routes {
  Routes._();
  
  static const HOME = _Paths.HOME;
  static const CALENDAR = _Paths.CALENDAR;
  static const INTENTION = _Paths.INTENTION;
  static const EVENT_DETAIL = _Paths.EVENT_DETAIL;
  static const CREATE_EVENT = _Paths.CREATE_EVENT;
  static const EDIT_EVENT = _Paths.EDIT_EVENT;
  static const SETTINGS = _Paths.SETTINGS;
  static const SEARCH = _Paths.SEARCH;
}

/// 路由路径常量
abstract class _Paths {
  _Paths._();
  
  static const HOME = '/';
  static const CALENDAR = '/calendar';
  static const INTENTION = '/intention';
  static const EVENT_DETAIL = '/event/:id';
  static const CREATE_EVENT = '/create-event';
  static const EDIT_EVENT = '/edit-event/:id';
  static const SETTINGS = '/settings';
  static const SEARCH = '/search';
}
