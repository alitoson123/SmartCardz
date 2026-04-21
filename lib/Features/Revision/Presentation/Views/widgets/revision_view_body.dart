import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/recision_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/custom_cached_image.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/row_of_difficulty_button.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/edit_card.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/generated/l10n.dart';

class RevisionViewBody extends StatefulWidget {
  const RevisionViewBody({
    super.key,
    required this.collection,
    required this.isWhiteboardEnabled,
    required this.clearWhiteboardNotifier,
    required this.changeColorNotifier,
    required this.deleteCardNotifier,
    required this.editCardNotifier,
  });

  final CollectionEntity collection;
  final bool isWhiteboardEnabled;
  final ValueNotifier<bool> deleteCardNotifier;
  final ValueNotifier<bool> clearWhiteboardNotifier;
  final ValueNotifier<bool> editCardNotifier;
  final ValueNotifier<Color?> changeColorNotifier;

  @override
  State<RevisionViewBody> createState() => _RevisionViewBodyState();
}

class _RevisionViewBodyState extends State<RevisionViewBody> {
  List<DrawingPoint?> drawingPoints = [];
  Color selectedColor = Colors.red;
  double strokeWidth = 3.0;
  final ScrollController _scrollController = ScrollController();
  Timer? _waitingTimer;
  bool isEditMode = false;
  bool isdeleted = false;

  @override
  void initState() {
    super.initState();

    // ✅ Query Firestore مرة واحدة
    context.read<RevisionCubit>().loadCards(widget.collection.collection_id);

    widget.clearWhiteboardNotifier.addListener(_clearWhiteboard);
    widget.changeColorNotifier.addListener(_changeColor);
    widget.deleteCardNotifier.addListener(_deleteCard);
    widget.editCardNotifier.addListener(_editCard);
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    widget.clearWhiteboardNotifier.removeListener(_clearWhiteboard);
    widget.changeColorNotifier.removeListener(_changeColor);
    widget.deleteCardNotifier.removeListener(_deleteCard);
    _scrollController.dispose();
    super.dispose();
  }

  void _clearWhiteboard() => setState(() => drawingPoints.clear());

  void _changeColor() {
    if (widget.changeColorNotifier.value != null) {
      setState(() => selectedColor = widget.changeColorNotifier.value!);
    }
  }

  void _editCard() {
    setState(() => isEditMode = true);
  }

  void _deleteCard() {
    final state = context.read<RevisionCubit>().state;
    if (state is RevisionReady) {
      context.read<RevisionCubit>().deleteCard(
        state.currentCard.id,
        widget.collection.collection_id,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).cardDeletedSuccessfully),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 500),
        ),
      );
      setState(() => drawingPoints.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<RevisionCubit, RevisionState>(
      listener: (context, state) {
        if (state is RevisionWaiting) {
          _startWaitingTimer(state);
        } else {
          _waitingTimer?.cancel();
        }
      },
      builder: (context, state) {
        if (state is RevisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RevisionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                SizedBox(height: 20.h),
                Text(
                  '${S.of(context).error}: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          );
        }

        if (state is RevisionFinished) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration, size: 80.sp, color: Colors.green),
                SizedBox(height: 20.h),
                Text(
                  '${S.of(context).congratulations}!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '${S.of(context).youReviewed} ${state.totalReviewed} ${S.of(context).cards}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 30.h),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.brightness == Brightness.light
                        ? Colors.white
                        : theme.colorScheme.surface,
                    foregroundColor: Colors.green,
                    side: BorderSide(color: Colors.green),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 12.h,
                    ),

                    child: Text(
                      S.of(context).back,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RevisionWaiting) {
          return _buildWaitingScreen(state);
        }

        if (state is RevisionReady) {
          return _buildCardScreen(state);
        }

        return Center(child: Text(S.of(context).unexpectedState));
      },
    );
  }

  // ══════════════════════════════════════════════════
  //   Waiting Screen
  // ══════════════════════════════════════════════════
  Widget _buildWaitingScreen(RevisionWaiting state) {
    final timeLeft = state.timeUntilNext;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 80.sp, color: Colors.orange),
          SizedBox(height: 20.h),
          Text(
            '${S.of(context).waitingForTheNextCard}...',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          Text(
            '${S.of(context).theNextCardIsAfter}: ${timeLeft.inSeconds}s',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 10.h),
          Text(
            '${state.remainingLearning} ${S.of(context).cardsInTheLearningList}',
            style: TextStyle(fontSize: 14.sp, color: Colors.orange.shade700),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: 200.w,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            child: AppButton(
              text: S.of(context).showTheNextCardNow,
              icon: Icons.arrow_forward,
              onPressed: () =>
                  context.read<RevisionCubit>().skipToNextAvailable(),
            ),
          ),
          /* ElevatedButton(
            onPressed: () => context.read<RevisionCubit>().skipToNextAvailable(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
                  EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            ),
            child: Text('${S.of(context).showTheNextCardNow}',
                style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          ),*/
          SizedBox(height: 10.h),
          Text(
            '${S.of(context).youReviewed} ${state.totalReviewed} ${S.of(context).cards}',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }


  void _startWaitingTimer(RevisionWaiting state) {
    _waitingTimer?.cancel();
    _waitingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (state.timeUntilNext.inSeconds <= 0) {
        context.read<RevisionCubit>().skipToNextAvailable();
      } else {
        setState(() {});
      }
    });
  }

  // ══════════════════════════════════════════════════
  //   Card Screen
  // ══════════════════════════════════════════════════
  Widget _buildCardScreen(RevisionReady state) {
    final card = state.currentCard;
    final isAICard = card is AICardEntity;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    // progress bar
                    _buildAnkiProgress(state),
                    SizedBox(height: 20.h),

                    buildSectionTitle(context, S.of(context).FrontSide),
                    SizedBox(height: 10.h),
                    _buildFrontSide(card, isAICard),

                    if (state.showAnswer) ...[
                      if (_hasBackContent(card, isAICard)) ...[
                        SizedBox(height: 30.h),
                        buildSectionTitle(context, S.of(context).BackSide),
                        SizedBox(height: 10.h),
                        _buildBackSide(card, isAICard),
                      ],
                    ],

                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ),
          if (isEditMode) 
            EditCardOverlay(
              card: card,
              onCancel: () {
                setState(() {
                  isEditMode = false;
                });
              },
              onSave: (updatedCard) {
                final state = context.read<RevisionCubit>().state;
                if (state is RevisionReady) {
                  context.read<RevisionCubit>().editCard(updatedCard);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).CardSavedSuccessfully),
                      backgroundColor: Colors.green,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                }
                setState(() {
                  isEditMode = false;
                });
              },
            ),

          if (widget.isWhiteboardEnabled)
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        selectedColor,
                        strokeWidth,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        selectedColor,
                        strokeWidth,
                      ),
                    );
                  });
                },
                onPanEnd: (_) => setState(() => drawingPoints.add(null)),
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isEditMode
          ? null
          : _buildBottomButtons(state, isAICard, card),
    );
  }

  // ══════════════════════════════════════════════════
  //   ✅ Anki-style Progress Counter
  // ══════════════════════════════════════════════════
  // بيعرض: 🔵 review | 🟡 learning | 🟢 new
  // زي Anki بالظبط
  Widget _buildAnkiProgress(RevisionReady state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _progressChip(
          count: state.reviewCount,
          color: Colors.blue,
          icon: Icons.check_circle,
          label: 'مراجعة',
        ),
        SizedBox(width: 12.w),
        _progressChip(
          count: state.learningCount,
          color: Colors.orange,
          icon: Icons.school,
          label: 'تعلم',
        ),
        SizedBox(width: 12.w),
        _progressChip(
          count: state.newCount,
          color: Colors.green,
          icon: Icons.fiber_new,
          label: 'جديد',
        ),
      ],
    );
  }

  Widget _progressChip({
    required int count,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //   Helpers
  // ══════════════════════════════════════════════════

  bool _hasBackContent(BaseCardEntity card, bool isAICard) {
    if (isAICard) return true;
    final normalCard = card as NormalCardEntity;
    return normalCard.backSide.isNotEmpty || normalCard.backImageUrl.isNotEmpty;
  }

  Widget _buildFrontSide(BaseCardEntity card, bool isAICard) {
    if (isAICard) return FrontSide(card: card as AICardEntity);
    final normalCard = card as NormalCardEntity;
    return CustomCard(
      child: Column(
        children: [
          if (normalCard.frontImageUrl.isNotEmpty)
            CachedImage(
              imageUrl: normalCard.frontImageUrl,
              height: 200.h,
              width: 200.w,
              fit: BoxFit.cover,
            ),
          if (normalCard.frontSide.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                normalCard.frontSide,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackSide(BaseCardEntity card, bool isAICard) {
    if (isAICard) return BackSide(card: card as AICardEntity);
    final normalCard = card as NormalCardEntity;
    return CustomCard(
      child: Column(
        children: [
          if (normalCard.backImageUrl.isNotEmpty)
            CachedImage(
              imageUrl: normalCard.backImageUrl,
              height: 200.h,
              width: 200.w,
              fit: BoxFit.cover,
            ),
          if (normalCard.backSide.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                normalCard.backSide,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    RevisionReady state,
    bool isAICard,
    BaseCardEntity card,
  ) {
    final hasBackContent = _hasBackContent(card, isAICard);

    if (!state.showAnswer && hasBackContent) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
        child: AppButton(
          text: S.of(context).showAnswer,
          icon: Icons.visibility,
          onPressed: () {
            context.read<RevisionCubit>().showAnswer();
            //   setState(() => drawingPoints.clear());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          },
        ),
      );
    }

    return RowOfDifficultyButton(
      onRating: (quality) {
        context.read<RevisionCubit>().rate(quality);
        setState(() {
          drawingPoints.clear();
          if (_scrollController.hasClients) _scrollController.jumpTo(0);
        });
      },
    );
  }
}

// ══════════════════════════════════════════════════
//   Drawing Classes
// ══════════════════════════════════════════════════

class DrawingPoint {
  Offset offset;
  Color color;
  double strokeWidth;
  DrawingPoint(this.offset, this.color, this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          Paint()
            ..color = drawingPoints[i]!.color
            ..strokeWidth = drawingPoints[i]!.strokeWidth
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
