import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/services/notifications_service/local_notification_service.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'components/reminder_header.dart';
import 'components/reminder_preview_card.dart';
import 'components/reminder_text_field.dart';
import 'components/reminder_time_picker.dart';
import 'components/reminder_repeat_switch.dart';
import 'components/reminder_drag_handle.dart';
import 'components/active_reminder_banner.dart';
import 'components/reminder_save_button.dart';

class ReminderBottomSheet extends StatefulWidget {
  const ReminderBottomSheet({super.key});

  @override
  State<ReminderBottomSheet> createState() => _ReminderBottomSheetState();
}

class _ReminderBottomSheetState extends State<ReminderBottomSheet> {
  bool _repeatDaily = true;

  int _hour = 9;
  String _period = 'AM';
  bool _isReminderActive = false;

  late TextEditingController _titleController;
  late TextEditingController _messageController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();

    // مهم
    // Rebuild preview live as the user types.
    _titleController.addListener(() => setState(() {}));
    _messageController.addListener(() => setState(() {}));

    _loadSavedReminderData();
  }

  Future<void> _loadSavedReminderData() async {
    final prefs = SharedPreferencesService.instance;
    setState(() {
      _hour = prefs.getInt('reminder_hour') ?? 5;
      _period = prefs.getString('reminder_period') ?? 'PM';
      _repeatDaily = prefs.getBool('reminder_repeat_daily') ?? true;
      _isReminderActive = prefs.getBool('is_reminder_active') ?? true;

      final savedTitle = prefs.getString('reminder_title');
      final savedMessage = prefs.getString('reminder_message');

      if (savedTitle != null && savedTitle.isNotEmpty) {
        _titleController.text = savedTitle;
      }
      if (savedMessage != null && savedMessage.isNotEmpty) {
        _messageController.text = savedMessage;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (_titleController.text.isEmpty) {
        _titleController.text = S.of(context).timeToStudy;
      }
      if (_messageController.text.isEmpty) {
        _messageController.text = S
            .of(context)
            .yourCardsAreWaitingKeepYourStreakAlive;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  Color get _bgColor => Theme.of(context).scaffoldBackgroundColor;
  Color get _textColor => Theme.of(context).textTheme.bodyLarge!.color!;

  void _saveReminder() async {
    final int hour24 = _period == 'PM' ? (_hour % 12) + 12 : _hour % 12;

    final title = _titleController.text.trim().isEmpty
        ? S.of(context).timeToStudy
        : _titleController.text.trim();
    final body = _messageController.text.trim().isEmpty
        ? S.of(context).yourCardsAreWaitingKeepYourStreakAlive
        : _messageController.text.trim();

    localnotificationService.showSchduledNotification(
      id: 4,
      title: title,
      body: body,
      hour: hour24,
      minute: 0,
      isrepeat: _repeatDaily,
    );

    final prefs = SharedPreferencesService.instance;
    await prefs.setInt('reminder_hour', _hour);
    await prefs.setString('reminder_period', _period);
    await prefs.setBool('reminder_repeat_daily', _repeatDaily);
    await prefs.setBool('is_reminder_active', true);
    await prefs.setString('reminder_title', title);
    await prefs.setString('reminder_message', body);

    if (mounted) {
      final successMessage = S.of(context).reminderSetSuccessfully;
      Navigator.pop(context);
      // show successfully message
      Message().MessageSuccessMethod(context, message: successMessage);
    }
  }

  void _cancelReminder() async {
    localnotificationService.cancelNotification(4);
    final prefs = SharedPreferencesService.instance;
    await prefs.setBool('is_reminder_active', false);

    setState(() {
      _isReminderActive = false;
    });

    if (mounted) {
      final successMessage = S.of(context).reminderCancelledSuccessfully;
      Message().MessageSuccessMethod(context, message: successMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ReminderDragHandle(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReminderHeader(),
                  SizedBox(height: 16.h),

                  if (_isReminderActive)
                    ActiveReminderBanner(
                      hour: _hour,
                      period: _period,
                      onCancel: _cancelReminder,
                    ),

                  ReminderPreviewCard(
                    title: _titleController.text,
                    message: _messageController.text,
                  ),
                  SizedBox(height: 20.h),

                  ReminderTextField(
                    label: S.of(context).notificationTitle,
                    controller: _titleController,
                    hint: S.of(context).enterNotificationTitle,
                    maxLines: 1,
                  ),
                  SizedBox(height: 14.h),

                  ReminderTextField(
                    label: S.of(context).notificationMessage,
                    controller: _messageController,
                    hint: S.of(context).enterNotificationMessage,
                    maxLines: 3,
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    S.of(context).remindMeAt,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _textColor.withAlpha(120),
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ReminderTimePicker(
                    hour: _hour,
                    period: _period,
                    onHourChanged: (h) => setState(() => _hour = h!),
                    onPeriodChanged: (p) => setState(() => _period = p!),
                  ),
                  SizedBox(height: 16.h),

                  Text(
                    S.of(context).schedule,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _textColor.withAlpha(120),
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ReminderRepeatSwitch(
                    repeatDaily: _repeatDaily,
                    onChanged: (v) => setState(() => _repeatDaily = v),
                  ),
                  SizedBox(height: 24.h),

                  ReminderSaveButton(onPressed: _saveReminder),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
