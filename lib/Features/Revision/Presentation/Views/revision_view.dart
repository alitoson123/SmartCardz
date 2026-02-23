// 📁 presentation/views/revision_screen.dart
/*
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/recision_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/custom_cached_image.dart';

class RevisionScreen extends StatelessWidget {
  final CollectionEntity collection;
  const RevisionScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RevisionCubit(RevisionRepo())..loadCards(collection.collection_id),
      child: Scaffold(
        body: BlocBuilder<RevisionCubit, RevisionState>(
          builder: (context, state) {
            if (state is RevisionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RevisionError) {
              return Center(child: Text(state.message));
            }
            if (state is RevisionFinished) {
              return _buildFinished(state);
            }
            if (state is RevisionReady) {
              return _buildReady(context, state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildReady(BuildContext context, RevisionReady state) {
    log(state.currentCard.frontSide);
    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: 1 - (state.remaining / state.queue.length),
        ),
        Text('متبقي: ${state.remaining} كارت'),

        // الكارت
        CustomCard(
          child: Column(
            children: [
              if (state.currentCard.frontImageUrl.isNotEmpty)
                CachedImage(
                  imageUrl: state.currentCard.frontImageUrl,
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              Text(
                state.currentCard.frontSide.isEmpty
                    ? '' // S.of(context).NoFrontSideData
                    : state.currentCard.frontSide,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ],
          ),
        ),
        // الأزرار
        if (!state.showAnswer)
          // زر إظهار الإجابة
          ElevatedButton(
            onPressed: () => context.read<RevisionCubit>().showAnswer(),
            child: const Text('إظهار الإجابة'),
          )
        else
          // أزرار التقييم
          RatingButtons(),
      ],
    );
  }

  Widget _buildFinished(RevisionFinished state) {
    return Center(
      child: Text('أحسنت! راجعت ${state.totalReviewed} كارت النهارده 🎉'),
    );
  }
}

// ══════════════════════════════════════════════════
//   Rating Buttons
// ══════════════════════════════════════════════════
class RatingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _RatingBtn(label: 'تاني', quality: 0, color: Colors.red),
        _RatingBtn(label: 'صعب', quality: 1, color: Colors.orange),
        _RatingBtn(label: 'كويس', quality: 3, color: Colors.blue),
        _RatingBtn(label: 'سهل', quality: 4, color: Colors.green),
      ],
    );
  }
}

class _RatingBtn extends StatelessWidget {
  final String label;
  final int quality;
  final Color color;

  const _RatingBtn({
    required this.label,
    required this.quality,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () => context.read<RevisionCubit>().rate(quality),
      child: Text(label),
    );
  }
}
// 📁 presentation/views/widgets/card_widget.dart

class CardWidget extends StatelessWidget {
  final NormalCardEntity card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    log(card.frontSide);
    log(card.backSide);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Badge الحالة ──
              _StateBadge(state: card.state),

              const SizedBox(height: 32),

              // ── السؤال ──
              Text(
                card.frontSide,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),

              Text(
                card.backSide,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  //  color: Color(0xFF1A1A2E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // ── خط فاصل ──
              Container(height: 1, color: Colors.grey.shade200),

              const SizedBox(height: 24),

              // ── Stats Row ──
              _StatsRow(card: card),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//   Badge بيوضح حالة الكارت
// ══════════════════════════════════════════
class _StateBadge extends StatelessWidget {
  final CardState state;
  const _StateBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    final info = _stateInfo(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: info['color'].withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info['icon'], size: 14, color: info['color']),
          const SizedBox(width: 6),
          Text(
            info['label'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: info['color'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _stateInfo(CardState state) {
    switch (state) {
      case CardState.newCard:
        return {
          'label': 'جديد',
          'color': Colors.blue,
          'icon': Icons.fiber_new_rounded,
        };
      case CardState.learning:
        return {
          'label': 'بتتعلم',
          'color': Colors.orange,
          'icon': Icons.school_rounded,
        };
      case CardState.review:
        return {
          'label': 'مراجعة',
          'color': Colors.green,
          'icon': Icons.refresh_rounded,
        };
      case CardState.relearning:
        return {
          'label': 'إعادة تعلم',
          'color': Colors.red,
          'icon': Icons.replay_rounded,
        };
    }
  }
}

// ══════════════════════════════════════════
//   Stats Row - Ease / Interval / Lapses
// ══════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final NormalCardEntity card;
  const _StatsRow({required this.card});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          label: 'سهولة',
          value: card.ease.toStringAsFixed(1),
          icon: Icons.trending_up_rounded,
          color: Colors.green,
        ),
        _StatItem(
          label: 'الفترة',
          value: card.interval == 0 ? 'دقايق' : '${card.interval}d',
          icon: Icons.calendar_today_rounded,
          color: Colors.blue,
        ),
        _StatItem(
          label: 'نسيان',
          value: '${card.lapses}',
          icon: Icons.warning_amber_rounded,
          color: card.lapses > 3 ? Colors.red : Colors.grey,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
*/
// 📁 Presentation/Views/revision_view_body.dart
// revision_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/revision_view_body.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RevisionView extends StatefulWidget {
  const RevisionView({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  State<RevisionView> createState() => _RevisionViewState();
}

class _RevisionViewState extends State<RevisionView> {
  bool isWhiteboardEnabled = false;
  final ValueNotifier<bool> deleteCardNotifier = ValueNotifier(false);
  final ValueNotifier<bool> clearWhiteboardNotifier = ValueNotifier(false);
  final ValueNotifier<Color?> changeColorNotifier = ValueNotifier(null);

  @override
  void dispose() {
    deleteCardNotifier.dispose();
    clearWhiteboardNotifier.dispose();
    changeColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteCardCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).revisionTitle),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                // Enable/Disable Whiteboard
                PopupMenuItem<String>(
                  value: 'toggle_whiteboard',
                  child: Row(
                    children: [
                      Icon(
                        isWhiteboardEnabled
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isWhiteboardEnabled ? Colors.blue : Colors.grey,
                      ),
                      SizedBox(width: 8.w),
                      Text(S.of(context).enableDisableWhiteboard),
                    ],
                  ),
                ),

                // خيارات السبورة (تظهر فقط لما السبورة مفعلة)
                if (isWhiteboardEnabled) ...[
                  PopupMenuItem<String>(
                    value: 'clear_whiteboard',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8.w),
                        Text(S.of(context).clearWhiteboard),
                      ],
                    ),
                  ),

                  /* PopupMenuItem<String>(
                    value: 'disable_whiteboard',
                    child: Row(
                      children:  [
                        Icon(Icons.close, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(S.of(context).disableWhiteboard),
                      ],
                    ),
                  ),*/
                  PopupMenuItem<String>(
                    enabled: false,
                    value: 'color_header',
                    child: Text(
                      S.of(context).whiteboardColor,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  // قائمة الألوان
                  ...WhiteboardColors.colors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final color = entry.value;
                    return PopupMenuItem<String>(
                      value: 'color_$index',
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(WhiteboardColors.getColorName(context, color)),
                        ],
                      ),
                    );
                  }),
                ],

                const PopupMenuDivider(),

                // حذف الكارت
                PopupMenuItem<String>(
                  value: 'delete_card',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8.w),
                      Text(S.of(context).deleteCardMenu),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'toggle_whiteboard') {
                  setState(() {
                    isWhiteboardEnabled = !isWhiteboardEnabled;
                  });
                } else if (value == 'clear_whiteboard') {
                  clearWhiteboardNotifier.value =
                      !clearWhiteboardNotifier.value;
                } /*else if (value == 'disable_whiteboard') {
                  setState(() {
                    isWhiteboardEnabled = false;
                  });
                }*/ else if (value.startsWith('color_')) {
                  final index = int.parse(value.split('_')[1]);
                  changeColorNotifier.value = WhiteboardColors.colors[index];
                } else if (value == 'delete_card') {
                  // نأكد من المستخدم قبل الحذف
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(S.of(context).deleteCard),
                      content: Text(S.of(context).deleteCardConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(S.of(context).cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            deleteCardNotifier.value =
                                !deleteCardNotifier.value;
                          },
                          child: Text(
                            S.of(context).delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: RevisionViewBody(
          collection: widget.collection,
          isWhiteboardEnabled: isWhiteboardEnabled,
          clearWhiteboardNotifier: clearWhiteboardNotifier,
          changeColorNotifier: changeColorNotifier,
          deleteCardNotifier: deleteCardNotifier,
        ),
      ),
    );
  }
}

class WhiteboardColors {
  static const List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.white,
  ];

  static String getColorName(BuildContext context, Color color) {
    if (color == Colors.red) return S.of(context).red;
    if (color == Colors.blue) return S.of(context).blue;
    if (color == Colors.green) return S.of(context).green;
    if (color == Colors.yellow) return S.of(context).yellow;
    if (color == Colors.orange) return S.of(context).orange;
    if (color == Colors.purple) return S.of(context).purple;
    if (color == Colors.pink) return S.of(context).pink;
    if (color == Colors.black) return S.of(context).black;
    if (color == Colors.white) return S.of(context).white;
    return S.of(context).color;
  }
}
