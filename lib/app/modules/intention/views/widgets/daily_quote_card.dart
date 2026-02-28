import 'package:flutter/material.dart';
import '../../../../data/models/zen_quote_model.dart';

/// 每日禅语卡片
class DailyQuoteCard extends StatelessWidget {
  final ZenQuoteModel? quote;
  final VoidCallback onRefresh;

  const DailyQuoteCard({
    super.key,
    required this.quote,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (quote == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.tertiaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '每日禅语',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: onRefresh,
                tooltip: '换一句',
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 禅语内容
          Text(
            quote!.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}
