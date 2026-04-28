import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/custom_cached_image.dart';

class EditCardOverlay extends StatefulWidget {
  final BaseCardEntity card;
  final VoidCallback onCancel;
  final Function(BaseCardEntity) onSave;

  const EditCardOverlay({
    super.key,
    required this.card,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<EditCardOverlay> createState() => _EditCardOverlayState();
}

class _EditCardOverlayState extends State<EditCardOverlay> {
  // AI Card controllers
  late TextEditingController _defController;
  late TextEditingController _wordController;
  late TextEditingController _typeController;
  late TextEditingController _exampleController;

  // Normal Card controllers
  late TextEditingController _frontController;
  late TextEditingController _backController;

  bool _isDeletedFront = false;
  bool _isDeletedBack = false;

  late bool isAiCard;

  @override
  void initState() {
    super.initState();
    isAiCard = widget.card is AICardEntity;

    if (isAiCard) {
      final aiCard = widget.card as AICardEntity;
      _defController = TextEditingController(text: aiCard.definition);
      _wordController = TextEditingController(text: aiCard.word);
      _typeController = TextEditingController(text: aiCard.type);
      _exampleController = TextEditingController(
        text: aiCard.example.join(", "),
      );
    } else {
      final normalCard = widget.card as NormalCardEntity;
      _frontController = TextEditingController(text: normalCard.frontSide);
      _backController = TextEditingController(text: normalCard.backSide);
    }
  }

  @override
  void dispose() {
    if (isAiCard) {
      _defController.dispose();
      _wordController.dispose();
      _typeController.dispose();
      _exampleController.dispose();
    } else {
      _frontController.dispose();
      _backController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine responsive theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Positioned.fill(
      child: Stack(
        children: [
          // Blur background
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onCancel,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),

          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).editCard,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onCancel,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24.r),
                        child: isAiCard
                            ? _buildAiForm(isDark)
                            : _buildNormalForm(isDark),
                      ),
                    ),

                    // Footer Actions
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.r,
                        right: 24.r,
                        bottom: 24.r,
                        top: 10.r,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onCancel,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Text(
                                S.of(context).cancel,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onSave,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                S.of(context).save,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiForm(bool isDark) {
    final aiCard = widget.card as AICardEntity;
    final showImage = !(_isDeletedFront || aiCard.image_url.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showImage) ...[
          Text(
            S.of(context).image,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedImage(
                  imageUrl: aiCard.image_url,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => setState(() => _isDeletedFront = true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],

        _buildTextField(S.of(context).definition, _defController, isDark),
        SizedBox(height: 20.h),
        _buildTextField(S.of(context).word, _wordController, isDark),
        SizedBox(height: 20.h),
        _buildTextField(S.of(context).type, _typeController, isDark),
        SizedBox(height: 20.h),
        _buildTextField(
          S.of(context).example,
          _exampleController,
          isDark,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildNormalForm(bool isDark) {
    final normalCard = widget.card as NormalCardEntity;
    final showFrontImage =
        !(_isDeletedFront || normalCard.frontImageUrl.isEmpty);
    final showBackImage = !(_isDeletedBack || normalCard.backImageUrl.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showFrontImage) ...[
          Text(
            "Front Image",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedImage(
                  imageUrl: normalCard.frontImageUrl,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => setState(() => _isDeletedFront = true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
        _buildTextField(
          S.of(context).FrontSide,
          _frontController,
          isDark,
          maxLines: 3,
        ),

        SizedBox(height: 28.h),

        if (showBackImage) ...[
          Text(
            "Back Image",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedImage(
                  imageUrl: normalCard.backImageUrl,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => setState(() => _isDeletedBack = true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
        _buildTextField(
          S.of(context).BackSide,
          _backController,
          isDark,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isDark, {
    int maxLines = 1,
  }) {
    // Provide a subtle filler color
    final fillColor = isDark
        ? Colors.grey.withOpacity(0.1)
        : Colors.grey.withOpacity(0.05);
    final borderColor = isDark ? Colors.white12 : Colors.black12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: 1,
          style: TextStyle(fontSize: 16.sp),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  void _onSave() {
    if (isAiCard) {
      final aiCard = widget.card as AICardEntity;
      final updatedCard = aiCard.copyWith(
        image_url: _isDeletedFront ? "" : aiCard.image_url,
        definition: _defController.text,
        word: _wordController.text,
        type: _typeController.text,
        example: _exampleController.text.split(RegExp(r',\s*')),
      );
      widget.onSave(updatedCard);
    } else {
      final normalCard = widget.card as NormalCardEntity;
      final updatedCard = normalCard.copyWith(
        frontImageUrl: _isDeletedFront ? "" : normalCard.frontImageUrl,
        backImageUrl: _isDeletedBack ? "" : normalCard.backImageUrl,
        frontSide: _frontController.text,
        backSide: _backController.text,
      );
      widget.onSave(updatedCard);
    }
  }
}
