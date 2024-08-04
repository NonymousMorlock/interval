import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:interval/core/common/app/app_state.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/common/widgets/input_field.dart';
import 'package:interval/core/enums/overlap.dart';
import 'package:interval/core/extensions/context_extensions.dart';
import 'package:interval/core/extensions/duration_extensions.dart';
import 'package:interval/core/singletons/current_platform.dart';
import 'package:interval/core/utils/core_utils.dart';
import 'package:interval/l10n/l10n.dart';
import 'package:interval/src/manage_interval/view_models/manage_interval_cubit.dart';
import 'package:interval/src/manage_interval/views/utils/manage_interval_utils.dart';
import 'package:interval/src/manage_interval/views/widgets/duration_picker.dart';
import 'package:interval/src/manage_interval/views/widgets/overlap_message.dart';
import 'package:interval/src/session/views/pages/countdown_page.dart';

class CreateOrUpdateIntervalSessionPage extends StatefulWidget {
  const CreateOrUpdateIntervalSessionPage({super.key, this.session});

  static const path = '/create-interval-session';
  final IntervalSession? session;

  @override
  State<CreateOrUpdateIntervalSessionPage> createState() =>
      _CreateOrUpdateIntervalSessionPageState();
}

class _CreateOrUpdateIntervalSessionPageState
    extends State<CreateOrUpdateIntervalSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Duration _mainTime;
  late Duration _workTime;
  late Duration _restTime;
  late bool _prioritizeOverlap;
  Overlap overlap = Overlap.NONE;
  Duration overlapDuration = Duration.zero;

  bool get isEditMode => widget.session != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.session!.title;
      _descriptionController.text = widget.session!.description ?? '';
      _mainTime = Duration(microseconds: widget.session!.mainTime);
      _workTime = Duration(microseconds: widget.session!.workTime);
      _restTime = Duration(microseconds: widget.session!.restTime);
      _prioritizeOverlap = widget.session!.prioritizeOverlap;
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkForOverlap());
    } else {
      _mainTime = Duration.zero;
      _workTime = Duration.zero;
      _restTime = Duration.zero;
      _prioritizeOverlap = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _checkForOverlap() {
    AppState.instance.startLoading();
    final data = jsonEncode({
      'mainTime': _mainTime.inMicroseconds,
      'workTime': _workTime.inMicroseconds,
      'restTime': _restTime.inMicroseconds,
    });
    compute(checkOverlap, data).then((overlap) {
      setState(() {
        this.overlap = overlap.overlap;
        overlapDuration = overlap.overlapDuration;
      });
      AppState.instance.stopLoading();
    });
  }

  void _finalSaveAction({
    required IntervalSession newSession,
    bool save = true,
  }) {
    final cubit = context.read<ManageIntervalCubit>();
    if (isEditMode) {
      cubit.updateIntervalSession(newSession);
      CoreUtils.showSnackBar(context, message: 'Interval updated');
    } else if (save) {
      cubit.saveIntervalSession(newSession);
    } else {
      context.pushReplacement(CountdownPage.path, extra: newSession);
    }
  }

  Future<void> _saveIntervalSession({bool save = true}) async {
    final description = _descriptionController.text.trim();
    final newSession = IntervalSession(
      id: isEditMode ? widget.session!.id : -1,
      title: _titleController.text.trim(),
      description: description.isEmpty ? null : description,
      mainTime: _mainTime.inMicroseconds,
      workTime: _workTime.inMicroseconds,
      restTime: _restTime.inMicroseconds,
      prioritizeOverlap: _prioritizeOverlap,
      createdAt: isEditMode ? widget.session!.createdAt : DateTime.now(),
      lastUpdatedAt: widget.session?.lastUpdatedAt,
    );

    if (isEditMode && widget.session == newSession) return;
    if (!save || _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO(Internationalization): Add translations for the messages
      if (_mainTime == Duration.zero || _workTime == Duration.zero) {
        CoreUtils.showSnackBar(
          context,
          message: 'Main and Work durations are required',
        );
        return;
      } else if (_workTime > _mainTime || _restTime > _mainTime) {
        var message = 'Your work duration exceeds your main duration. If this '
            'is intentional, please click [Continue] to proceed.';
        if (_restTime > _mainTime) {
          message = 'Your rest duration exceeds your main duration. If this '
              'is intentional, please click [Continue] to proceed.';
        }
        CoreUtils.showSnackBar(
          context,
          duration: const Duration(seconds: 30),
          message: message,
          showCloseIcon: true,
          action: SnackBarAction(
            label: context.l10n.continue$,
            onPressed: () => _finalSaveAction(
              newSession: newSession,
              save: save,
            ),
          ),
        );
      } else if (_restTime == Duration.zero && _mainTime > _workTime) {
        CoreUtils.showSnackBar(
          context,
          duration: const Duration(seconds: 30),
          message: 'Your main duration exceeds your work duration and you '
              'have no interval[rest]. If this is intentional, please '
              'click [Continue] to proceed.',
          showCloseIcon: true,
          action: SnackBarAction(
            label: context.l10n.continue$,
            onPressed: () => _finalSaveAction(
              newSession: newSession,
              save: save,
            ),
          ),
        );
      } else {
        _finalSaveAction(newSession: newSession, save: save);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ManageIntervalCubit, ManageIntervalState>(
      listener: (context, state) {
        AppState.instance.stopLoading();
        if (state case ManageIntervalError(:final message)) {
          if (CurrentPlatform.instance.isDesktop) {
            CoreUtils.showErrorAlert(message: message);
          } else {
            CoreUtils.showSnackBar(context, message: message);
          }
        } else if (state is IntervalSessionSaved ||
            state is IntervalSessionUpdated) {
          context.pop(true);
        } else if (state is ManageIntervalLoading) {
          AppState.instance.startLoading();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? l10n.updateIntervalSession : l10n.addIntervalSession,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                InputField(
                  controller: _titleController,
                  labelText: l10n.title,
                ),
                const Gap(20),
                InputField(
                  defaultValidation: false,
                  controller: _descriptionController,
                  labelText: l10n.description,
                ),
                // button to 'Select Main Time'
                const Gap(20),
                DurationPicker(
                  title: l10n.selectMainDuration,
                  initialDuration: _mainTime,
                  onPicked: (value) {
                    setState(() {
                      _mainTime = value;
                    });
                    _checkForOverlap();
                  },
                ),

                if (_mainTime != Duration.zero) ...[
                  const Gap(20),
                  Text(
                    '${l10n.mainDuration}: ${_mainTime.timeInWords}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],

                const Gap(20),

                DurationPicker(
                  title: l10n.selectWorkDuration,
                  initialDuration: _workTime,
                  onPicked: (value) {
                    setState(() {
                      _workTime = value;
                      _checkForOverlap();
                    });
                  },
                ),

                if (_workTime != Duration.zero) ...[
                  const Gap(20),
                  Text(
                    '${l10n.workDuration}: ${_workTime.timeInWords}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                const Gap(20),
                DurationPicker(
                  title: l10n.selectRestDuration,
                  initialDuration: _restTime,
                  onPicked: (value) {
                    setState(() {
                      _restTime = value;
                      _checkForOverlap();
                    });
                  },
                ),

                if (_restTime != Duration.zero) ...[
                  const Gap(20),
                  Text(
                    '${l10n.restDuration}: ${_restTime.timeInWords}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],

                if (overlap != Overlap.NONE) ...[
                  const Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.overlapDetected,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Gap(5),
                          Tooltip(
                            richMessage: OverlapMessage(
                              overlap: overlap,
                              overlapDuration: overlapDuration,
                            ),
                            showDuration: const Duration(seconds: 30),
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(
                              Icons.info_outline,
                              color: context.theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile(
                        title: Text(l10n.prioritizeOverlap),
                        value: _prioritizeOverlap,
                        onChanged: (value) {
                          setState(() {
                            _prioritizeOverlap = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
                const Gap(20),
                ElevatedButton(
                  onPressed: _saveIntervalSession,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      isEditMode
                          ? l10n.updateIntervalSession
                          : l10n.saveIntervalSession,
                    ),
                  ),
                ),
                if (!isEditMode) ...[
                  const Gap(20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await CoreUtils.showConfirmationDialog(
                        context,
                        title: l10n.continueWithoutSaving,
                        message: l10n.continueWithoutSavingConfirmationMessage,
                        confirmText: l10n.continue$,
                        cancelText: l10n.cancel,
                      );

                      if (result) unawaited(_saveIntervalSession(save: false));
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(l10n.continueWithoutSaving),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
