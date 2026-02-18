// revision_view_body.dart
/*import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_states.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/custom_cached_image.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/row_of_difficulty_button.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/generated/l10n.dart';

class RevisionViewBody extends StatefulWidget {
  const RevisionViewBody({
    super.key,
    required this.collection,
    required this.isWhiteboardEnabled,
    required this.clearWhiteboardNotifier,
    required this.changeColorNotifier,
    required this.deleteCardNotifier,
  });

  final CollectionEntity collection;
  final bool isWhiteboardEnabled;
  final ValueNotifier<bool> deleteCardNotifier;
  final ValueNotifier<bool> clearWhiteboardNotifier;
  final ValueNotifier<Color?> changeColorNotifier;

  @override
  State<RevisionViewBody> createState() => _RevisionViewBodyState();
}

class _RevisionViewBodyState extends State<RevisionViewBody> {
  bool showAnswer = false;
  int currentIndex = 0;
  int limit = 100;

  // متغيرات السبورة
  List<DrawingPoint?> drawingPoints = [];
  Color selectedColor = Colors.red;
  double strokeWidth = 3.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FetchAndRatingCubit>().fetchDueCards(
      collectionId: widget.collection.collection_id,
      limit: limit,
    );

    // الاستماع لإشارة المسح
    widget.clearWhiteboardNotifier.addListener(_clearWhiteboard);

    // الاستماع لتغيير اللون
    widget.changeColorNotifier.addListener(_changeColor);

    // الاستماع لحذف الكارت
    widget.deleteCardNotifier.addListener(_deleteCard);
  }

  @override
  void dispose() {
    widget.clearWhiteboardNotifier.removeListener(_clearWhiteboard);
    widget.changeColorNotifier.removeListener(_changeColor);
    widget.deleteCardNotifier.removeListener(_deleteCard);
    _scrollController.dispose();
    super.dispose();
  }

  void _clearWhiteboard() {
    setState(() {
      drawingPoints.clear();
    });
  }

  void _changeColor() {
    if (widget.changeColorNotifier.value != null) {
      setState(() {
        selectedColor = widget.changeColorNotifier.value!;
      });
    }
  }

  void _deleteCard() {
    final state = context.read<FetchAndRatingCubit>().state;
    if (state is FetchDueCardsSuccess) {
      final cards = state.cards;
      if (currentIndex < cards.length) {
        final card = cards[currentIndex];

        context.read<DeleteCardCubit>().deleteCard(
          cardId: card.id,
          collectionId: widget.collection.collection_id,
        );
        log(card.id);
      }
    }
  }

  void _resetIndex() {
    setState(() {
      currentIndex = 0;
      showAnswer = false;
      drawingPoints.clear();
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteCardCubit, DeleteCardStates>(
      listener: (context, state) {
        if (state is DeleteCardSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).cardDeletedSuccessfully),
              backgroundColor: Colors.green,
              duration: const Duration(milliseconds: 500),
            ),
          );

          final fetchState = context.read<FetchAndRatingCubit>().state;
          if (fetchState is FetchDueCardsSuccess) {
            final cards = fetchState.cards;

            setState(() {
              showAnswer = false;
              drawingPoints.clear();
              if (cards.length > 1) {
                if (currentIndex >= cards.length - 1) {
                  currentIndex = 0;
                }
              } else {
                currentIndex = 0;
              }
            });

            Future.delayed(const Duration(milliseconds: 50), () {
              if (mounted) {
                context.read<FetchAndRatingCubit>().fetchDueCards(
                  collectionId: widget.collection.collection_id,
                  limit: limit,
                );
              }
            });
          }
        } else if (state is DeleteCardFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 1000),
            ),
          );
        }
      },
      child: BlocBuilder<FetchAndRatingCubit, FetchAndRatingStates>(
        builder: (context, state) {
          if (state is FetchAndRatingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchDueCardsSuccess) {
            final cards = state.cards;

            if (cards.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).noCardsDue,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            if (currentIndex >= cards.length) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _resetIndex(),
              );
              return const Center(child: CircularProgressIndicator());
            }

            final card = cards[currentIndex];
            final isAICard = card.isAICard;

            return Scaffold(
              body: Stack(
                children: [
                  // المحتوى الأساسي
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            buildSectionTitle(context, S.of(context).FrontSide),
                            SizedBox(height: 10.h),

                            // Front Side
                            isAICard
                                ? FrontSide(card: card as CardWithAIEntity)
                                : CustomCard(
                                    child: Column(
                                      children: [
                                        if (card.frontImageUrl.isNotEmpty)
                                          CachedImage(
                                            imageUrl: card.frontImageUrl,
                                            height: 200.h,
                                            width: 200.w,
                                            fit: BoxFit.cover,
                                          ),
                                        Text(
                                          card.frontSide.isEmpty
                                              ? '' // S.of(context).NoFrontSideData
                                              : card.frontSide,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                            if (showAnswer && isAICard) ...[
                              SizedBox(height: 30.h),
                              buildSectionTitle(
                                context,
                                S.of(context).BackSide,
                              ),
                              SizedBox(height: 10.h),
                              BackSide(card: card as CardWithAIEntity),
                            ],

                            if (showAnswer &&
                                !isAICard &&
                                (card.backSide.isNotEmpty ||
                                    card.backImageUrl.isNotEmpty)) ...[
                              SizedBox(height: 30.h),
                              buildSectionTitle(
                                context,
                                S.of(context).BackSide,
                              ),
                              SizedBox(height: 10.h),
                              CustomCard(
                                child: Column(
                                  children: [
                                    if (card.backImageUrl.isNotEmpty)
                                      CachedImage(
                                        imageUrl: card.backImageUrl,
                                        height: 200.h,
                                        width: 200.w,
                                        fit: BoxFit.cover,
                                      ),
                                    Text(
                                      card.backSide,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 120.h),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // طبقة السبورة - تغطي الشاشة كلها
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
                        onPanEnd: (details) {
                          setState(() {
                            drawingPoints.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(drawingPoints),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ),
                ],
              ),

              // الأزرار السفلية
              bottomNavigationBar: Container(
                child: isAICard
                    ? !showAnswer
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.h,
                                right: 20.w,
                                left: 20.w,
                              ),
                              child: AppButton(
                                text: S.of(context).showAnswer,
                                icon: Icons.visibility,
                                onPressed: () {
                                  setState(() => showAnswer = true);
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (_scrollController.hasClients) {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position
                                            .maxScrollExtent,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
                                },
                              ),
                            )
                          : RowOfDifficultyButton(
                              card: card,
                              showAnswer: showAnswer,
                              currentIndex: currentIndex,
                              collectionId: widget.collection.collection_id,
                              onNextCard: () {
                                setState(() {
                                  showAnswer = false;
                                  drawingPoints.clear();
                                  if (currentIndex >= cards.length - 1) {
                                    currentIndex = 0;
                                  }
                                  if (_scrollController.hasClients) {
                                    _scrollController.jumpTo(0);
                                  }
                                });
                              },
                            )
                    : !showAnswer &&
                          (card.backSide.isNotEmpty ||
                              card.backImageUrl.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.only(
                          bottom: 20.h,
                          right: 20.w,
                          left: 20.w,
                        ),
                        child: AppButton(
                          text: S.of(context).showAnswer,
                          icon: Icons.visibility,
                          onPressed: () {
                            setState(() => showAnswer = true);
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
                      )
                    : RowOfDifficultyButton(
                        card: card,
                        showAnswer: showAnswer,
                        currentIndex: currentIndex,
                        collectionId: widget.collection.collection_id,
                        onNextCard: () {
                          setState(() {
                            showAnswer = false;
                            drawingPoints.clear();
                            if (currentIndex >= cards.length - 1) {
                              currentIndex = 0;
                            }
                            if (_scrollController.hasClients) {
                              _scrollController.jumpTo(0);
                            }
                          });
                        },
                      ),
              ),
            );
          } else if (state is FetchAndRatingFailure) {
            return Center(
              child: Text('${S.of(context).error}: ${state.errorMessage}'),
            );
          } else {
            return Center(child: Text(S.of(context).unexpectedState));
          }
        },
      ),
    );
  }
}

// نقطة الرسم
class DrawingPoint {
  Offset offset;
  Color color;
  double strokeWidth;

  DrawingPoint(this.offset, this.color, this.strokeWidth);
}

// رسام السبورة
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        Paint paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/

// 📁 Presentation/Views/revision_view_body.dart

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
  });

  final CollectionEntity collection;
  final bool isWhiteboardEnabled;
  final ValueNotifier<bool> deleteCardNotifier;
  final ValueNotifier<bool> clearWhiteboardNotifier;
  final ValueNotifier<Color?> changeColorNotifier;

  @override
  State<RevisionViewBody> createState() => _RevisionViewBodyState();
}

class _RevisionViewBodyState extends State<RevisionViewBody> {
  // متغيرات السبورة
  List<DrawingPoint?> drawingPoints = [];
  Color selectedColor = Colors.red;
  double strokeWidth = 3.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // ✅ تحميل الكروت بالـ SM-2
    context.read<RevisionCubit>().loadCards(
          widget.collection.collection_id,
          limit: 100,
        );

    widget.clearWhiteboardNotifier.addListener(_clearWhiteboard);
    widget.changeColorNotifier.addListener(_changeColor);
    widget.deleteCardNotifier.addListener(_deleteCard);
  }

  @override
  void dispose() {
    widget.clearWhiteboardNotifier.removeListener(_clearWhiteboard);
    widget.changeColorNotifier.removeListener(_changeColor);
    widget.deleteCardNotifier.removeListener(_deleteCard);
    _scrollController.dispose();
    super.dispose();
  }

  void _clearWhiteboard() {
    setState(() => drawingPoints.clear());
  }

  void _changeColor() {
    if (widget.changeColorNotifier.value != null) {
      setState(() => selectedColor = widget.changeColorNotifier.value!);
    }
  }

  void _deleteCard() {
    final state = context.read<RevisionCubit>().state;
    if (state is RevisionReady) {
      final card = state.currentCard;
  //    ****************************************************************
      // حذف الكارت
   //   context.read<RevisionCubit>().deleteCard(card.id);
      
      // إظهار رسالة
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
    return BlocBuilder<RevisionCubit, RevisionState>(
      builder: (context, state) {
        // ──────────────────────────
        //   Loading
        // ──────────────────────────
        if (state is RevisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ──────────────────────────
        //   Error
        // ──────────────────────────
        if (state is RevisionError) {
          return Center(
            child: Text('${S.of(context).error}: ${state.message}'),
          );
        }

        // ──────────────────────────
        //   Finished
        // ──────────────────────────
        if (state is RevisionFinished) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration, size: 80.sp, color: Colors.green),
                SizedBox(height: 20.h),
                Text(
                  '{S.of(context).congratulations}!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'راجعت ${state.totalReviewed} كارت النهارده 🎉',
                  style: TextStyle(fontSize: 18.sp),
                ),
              ],
            ),
          );
        }

        // ──────────────────────────
        //   Ready - عرض الكروت
        // ──────────────────────────
        if (state is RevisionReady) {
          final card = state.currentCard;
          
          // ✅ تحديد نوع الكارت (AI أو Normal)
          final isAICard = card is AICardEntity;

          return Scaffold(
            body: Stack(
              children: [
                // ── المحتوى الأساسي ──
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),

                          // ── Progress Indicator ──
                          _buildProgress(state),

                          SizedBox(height: 20.h),

                          // ── Front Side ──
                          buildSectionTitle(context, S.of(context).FrontSide),
                          SizedBox(height: 10.h),
                          _buildFrontSide(card, isAICard),

                          // ── Back Side (لو الإجابة ظاهرة) ──
                          if (state.showAnswer) ...[
                            // ✅ فحص لو عنده محتوى للـ Back
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

                // ── طبقة السبورة ──
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
                      onPanEnd: (details) {
                        setState(() => drawingPoints.add(null));
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(drawingPoints),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
              ],
            ),

            // ── الأزرار السفلية ──
            bottomNavigationBar: _buildBottomButtons(state, isAICard, card),
          );
        }

        return Center(child: Text(S.of(context).unexpectedState));
      },
    );
  }

  // ══════════════════════════════════════════════════
  //   Progress Bar
  // ══════════════════════════════════════════════════
  Widget _buildProgress(RevisionReady state) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: 1 - (state.remaining / state.queue.length),
          backgroundColor: Colors.grey.shade200,
          color: Colors.blue,
        ),
        SizedBox(height: 8.h),
        Text(
          'متبقي: ${state.remaining} / ${state.queue.length}',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════
  //   فحص لو عنده Back Content
  // ══════════════════════════════════════════════════
  bool _hasBackContent(BaseCardEntity card, bool isAICard) {
    if (isAICard) {
      // AI Cards دايماً عندها back content
      return true;
    } else {
      final normalCard = card as NormalCardEntity;
      return normalCard.backSide.isNotEmpty || 
             normalCard.backImageUrl.isNotEmpty;
    }
  }

  // ══════════════════════════════════════════════════
  //   Front Side
  // ══════════════════════════════════════════════════
  Widget _buildFrontSide(BaseCardEntity card, bool isAICard) {
    if (isAICard) {
      return FrontSide(card: card as AICardEntity);
    }

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

  // ══════════════════════════════════════════════════
  //   Back Side
  // ══════════════════════════════════════════════════
  Widget _buildBackSide(BaseCardEntity card, bool isAICard) {
    if (isAICard) {
      return BackSide(card: card as AICardEntity);
    }

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

  // ══════════════════════════════════════════════════
  //   Bottom Buttons
  // ══════════════════════════════════════════════════
  Widget _buildBottomButtons(
    RevisionReady state,
    bool isAICard,
    BaseCardEntity card,
  ) {
    // ✅ فحص لو عنده back content
    final hasBackContent = _hasBackContent(card, isAICard);

    // ── لو الإجابة مش ظاهرة ──
    if (!state.showAnswer && hasBackContent) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
        child: AppButton(
          text: S.of(context).showAnswer,
          icon: Icons.visibility,
          onPressed: () {
            context.read<RevisionCubit>().showAnswer();
            setState(() => drawingPoints.clear());

            // Scroll للإجابة
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

    // ── أزرار التقييم ──
    return RowOfDifficultyButton(
      onRating: (quality) {
        context.read<RevisionCubit>().rate(quality);
        setState(() {
          drawingPoints.clear();
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
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
        Paint paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}