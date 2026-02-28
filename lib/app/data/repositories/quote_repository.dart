import 'dart:math';
import '../models/zen_quote_model.dart';

/// 禅语仓库
/// 
/// 提供禅语数据（暂时使用硬编码数据，后续可扩展为从服务器获取）
class QuoteRepository {
  final Random _random = Random();

  /// 所有禅语
  static final List<ZenQuoteModel> _quotes = [
    // 通用禅语
    const ZenQuoteModel(
      text: '一即一切，一切即一',
      category: ZenQuoteCategory.general,
    ),
    const ZenQuoteModel(
      text: '活在当下，专注此刻',
      category: ZenQuoteCategory.general,
    ),
    const ZenQuoteModel(
      text: '心静自然凉',
      category: ZenQuoteCategory.general,
    ),
    const ZenQuoteModel(
      text: '万物皆空，因果不空',
      category: ZenQuoteCategory.general,
    ),
    const ZenQuoteModel(
      text: '放下执念，心自清明',
      category: ZenQuoteCategory.clear,
    ),
    const ZenQuoteModel(
      text: '归零，是新的开始',
      category: ZenQuoteCategory.clear,
    ),
    const ZenQuoteModel(
      text: '清空杂念，回归本心',
      category: ZenQuoteCategory.clear,
    ),
    const ZenQuoteModel(
      text: '错误亦是修行',
      category: ZenQuoteCategory.error,
    ),
    const ZenQuoteModel(
      text: '失败是成功之母',
      category: ZenQuoteCategory.error,
    ),
    const ZenQuoteModel(
      text: '九九归一，圆满如初',
      category: ZenQuoteCategory.special,
    ),
    const ZenQuoteModel(
      text: '三生万物，道法自然',
      category: ZenQuoteCategory.special,
    ),
    
    // 早晨禅语
    const ZenQuoteModel(
      text: '晨起一念，决定一天',
      category: ZenQuoteCategory.morning,
    ),
    const ZenQuoteModel(
      text: '新的一天，新的开始',
      category: ZenQuoteCategory.morning,
    ),
    const ZenQuoteModel(
      text: '清晨的阳光，照亮内心',
      category: ZenQuoteCategory.morning,
    ),
    
    // 晚上禅语
    const ZenQuoteModel(
      text: '日落西山，心归平静',
      category: ZenQuoteCategory.evening,
    ),
    const ZenQuoteModel(
      text: '夜深人静，反思今日',
      category: ZenQuoteCategory.evening,
    ),
    const ZenQuoteModel(
      text: '放下今日，迎接明天',
      category: ZenQuoteCategory.evening,
    ),
    
    // 意图相关
    const ZenQuoteModel(
      text: '意念所至，金石为开',
      category: ZenQuoteCategory.intention,
    ),
    const ZenQuoteModel(
      text: '专注当下，成就未来',
      category: ZenQuoteCategory.intention,
    ),
    const ZenQuoteModel(
      text: '心之所向，素履以往',
      category: ZenQuoteCategory.intention,
    ),
    const ZenQuoteModel(
      text: '一念执着，万般皆苦',
      category: ZenQuoteCategory.intention,
    ),
  ];

  /// 获取所有禅语
  List<ZenQuoteModel> getAll() {
    return List.unmodifiable(_quotes);
  }

  /// 根据分类获取禅语
  List<ZenQuoteModel> getByCategory(String category) {
    return _quotes.where((quote) => quote.category == category).toList();
  }

  /// 获取随机禅语
  ZenQuoteModel getRandom() {
    return _quotes[_random.nextInt(_quotes.length)];
  }

  /// 根据分类获取随机禅语
  ZenQuoteModel getRandomByCategory(String category) {
    final categoryQuotes = getByCategory(category);
    if (categoryQuotes.isEmpty) {
      return getRandom();
    }
    return categoryQuotes[_random.nextInt(categoryQuotes.length)];
  }

  /// 获取通用禅语
  ZenQuoteModel getGeneral() {
    return getRandomByCategory(ZenQuoteCategory.general);
  }

  /// 获取清除时的禅语
  ZenQuoteModel getClear() {
    return getRandomByCategory(ZenQuoteCategory.clear);
  }

  /// 获取错误时的禅语
  ZenQuoteModel getError() {
    return getRandomByCategory(ZenQuoteCategory.error);
  }

  /// 获取特殊数字的禅语
  ZenQuoteModel getSpecial() {
    return getRandomByCategory(ZenQuoteCategory.special);
  }

  /// 获取早晨禅语
  ZenQuoteModel getMorning() {
    return getRandomByCategory(ZenQuoteCategory.morning);
  }

  /// 获取晚上禅语
  ZenQuoteModel getEvening() {
    return getRandomByCategory(ZenQuoteCategory.evening);
  }

  /// 获取意图相关禅语
  ZenQuoteModel getIntention() {
    return getRandomByCategory(ZenQuoteCategory.intention);
  }

  /// 根据时间获取合适的禅语
  ZenQuoteModel getByTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return getMorning();
    } else if (hour >= 18 && hour < 23) {
      return getEvening();
    } else {
      return getGeneral();
    }
  }

  /// 获取每日禅语（基于日期的随机）
  ZenQuoteModel getDailyQuote() {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);
    return _quotes[random.nextInt(_quotes.length)];
  }
}
