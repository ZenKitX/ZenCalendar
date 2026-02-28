import 'package:equatable/equatable.dart';

/// 禅语数据模型
class ZenQuoteModel extends Equatable {
  final String text;
  final String? author;
  final String category;

  const ZenQuoteModel({
    required this.text,
    this.author,
    required this.category,
  });

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'category': category,
    };
  }

  /// 从 JSON 创建
  factory ZenQuoteModel.fromJson(Map<String, dynamic> json) {
    return ZenQuoteModel(
      text: json['text'] as String,
      author: json['author'] as String?,
      category: json['category'] as String,
    );
  }

  @override
  List<Object?> get props => [text, author, category];

  @override
  String toString() {
    return 'ZenQuoteModel(text: $text, author: $author, category: $category)';
  }
}

/// 禅语分类
class ZenQuoteCategory {
  static const String general = 'general'; // 通用
  static const String clear = 'clear'; // 清除时
  static const String calculate = 'calculate'; // 计算时
  static const String error = 'error'; // 错误时
  static const String special = 'special'; // 特殊数字
  static const String morning = 'morning'; // 早晨
  static const String evening = 'evening'; // 晚上
  static const String intention = 'intention'; // 意图相关
}
