import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/recurrence_rule.dart';

/// 重复规则选择器
class RecurrenceRulePicker extends StatefulWidget {
  final RecurrenceRule? initialRule;
  final Function(RecurrenceRule?) onRuleChanged;

  const RecurrenceRulePicker({
    super.key,
    this.initialRule,
    required this.onRuleChanged,
  });

  @override
  State<RecurrenceRulePicker> createState() => _RecurrenceRulePickerState();
}

class _RecurrenceRulePickerState extends State<RecurrenceRulePicker> {
  late RecurrenceRule _currentRule;
  
  @override
  void initState() {
    super.initState();
    _currentRule = widget.initialRule ?? RecurrenceRule.none();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 重复类型选择
        _buildRecurrenceTypeSection(),
        
        if (_currentRule.type != RecurrenceType.none) ...[
          const SizedBox(height: 16),
          
          // 间隔设置
          _buildIntervalSection(),
          
          // 星期几选择（仅周重复）
          if (_currentRule.type == RecurrenceType.weekly) ...[
            const SizedBox(height: 16),
            _buildWeekdaysSection(),
          ],
          
          const SizedBox(height: 16),
          
          // 结束条件
          _buildEndConditionSection(),
        ],
        
        const SizedBox(height: 16),
        
        // 预览
        _buildPreviewSection(),
      ],
    );
  }

  /// 构建重复类型选择区域
  Widget _buildRecurrenceTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '重复频率',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          children: RecurrenceType.values.map((type) {
            final isSelected = _currentRule.type == type;
            
            return FilterChip(
              label: Text(type.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _updateRule(_currentRule.copyWith(type: type));
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建间隔设置区域
  Widget _buildIntervalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '重复间隔',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            const Text('每'),
            const SizedBox(width: 8),
            
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _currentRule.interval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final interval = int.tryParse(value) ?? 1;
                  if (interval > 0) {
                    _updateRule(_currentRule.copyWith(interval: interval));
                  }
                },
              ),
            ),
            
            const SizedBox(width: 8),
            Text(_getIntervalUnit()),
          ],
        ),
      ],
    );
  }

  /// 构建星期几选择区域
  Widget _buildWeekdaysSection() {
    final weekdayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '重复日期',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final weekday = index + 1;
            final isSelected = _currentRule.weekdays.contains(weekday);
            
            return FilterChip(
              label: Text(weekdayNames[index]),
              selected: isSelected,
              onSelected: (selected) {
                final weekdays = List<int>.from(_currentRule.weekdays);
                
                if (selected) {
                  weekdays.add(weekday);
                } else {
                  weekdays.remove(weekday);
                }
                
                weekdays.sort();
                _updateRule(_currentRule.copyWith(weekdays: weekdays));
              },
            );
          }),
        ),
        
        if (_currentRule.weekdays.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '未选择时将使用事件原始日期的星期',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
      ],
    );
  }

  /// 构建结束条件区域
  Widget _buildEndConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '结束条件',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 永不结束
        RadioListTile<RecurrenceEndType>(
          title: const Text('永不结束'),
          value: RecurrenceEndType.never,
          groupValue: _currentRule.endType,
          onChanged: (value) {
            if (value != null) {
              _updateRule(_currentRule.copyWith(
                endType: value,
                endDate: null,
                count: null,
              ));
            }
          },
        ),
        
        // 指定日期结束
        RadioListTile<RecurrenceEndType>(
          title: const Text('结束日期'),
          value: RecurrenceEndType.date,
          groupValue: _currentRule.endType,
          onChanged: (value) {
            if (value != null) {
              _updateRule(_currentRule.copyWith(
                endType: value,
                endDate: DateTime.now().add(const Duration(days: 30)),
                count: null,
              ));
            }
          },
        ),
        
        if (_currentRule.endType == RecurrenceEndType.date)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '结束日期',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _currentRule.endDate != null
                          ? '${_currentRule.endDate!.year}-${_currentRule.endDate!.month.toString().padLeft(2, '0')}-${_currentRule.endDate!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _currentRule.endDate ?? DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                      );
                      
                      if (date != null) {
                        _updateRule(_currentRule.copyWith(endDate: date));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        
        // 指定次数结束
        RadioListTile<RecurrenceEndType>(
          title: const Text('重复次数'),
          value: RecurrenceEndType.count,
          groupValue: _currentRule.endType,
          onChanged: (value) {
            if (value != null) {
              _updateRule(_currentRule.copyWith(
                endType: value,
                endDate: null,
                count: 10,
              ));
            }
          },
        ),
        
        if (_currentRule.endType == RecurrenceEndType.count)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: _currentRule.count?.toString() ?? '10',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '次数',
                    ),
                    onChanged: (value) {
                      final count = int.tryParse(value);
                      if (count != null && count > 0) {
                        _updateRule(_currentRule.copyWith(count: count));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('次'),
              ],
            ),
          ),
      ],
    );
  }

  /// 构建预览区域
  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '重复规则预览',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _currentRule.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 获取间隔单位
  String _getIntervalUnit() {
    switch (_currentRule.type) {
      case RecurrenceType.daily:
        return '天';
      case RecurrenceType.weekly:
        return '周';
      case RecurrenceType.monthly:
        return '个月';
      case RecurrenceType.yearly:
        return '年';
      case RecurrenceType.none:
        return '';
    }
  }

  /// 更新规则
  void _updateRule(RecurrenceRule newRule) {
    setState(() {
      _currentRule = newRule;
    });
    
    widget.onRuleChanged(newRule.type == RecurrenceType.none ? null : newRule);
  }
}

/// 显示重复规则选择对话框
Future<RecurrenceRule?> showRecurrenceRulePicker(
  BuildContext context, {
  RecurrenceRule? initialRule,
}) async {
  RecurrenceRule? selectedRule = initialRule;

  final result = await showDialog<RecurrenceRule?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('设置重复规则'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: RecurrenceRulePicker(
            initialRule: initialRule,
            onRuleChanged: (rule) {
              selectedRule = rule;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(selectedRule),
          child: const Text('确定'),
        ),
      ],
    ),
  );

  return result;
}