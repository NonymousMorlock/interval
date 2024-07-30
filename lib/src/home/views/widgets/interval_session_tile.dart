import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/utils/core_utils.dart';
import 'package:interval/l10n/l10n.dart';
import 'package:interval/src/home/view_models/home_view_model_cubit.dart';
import 'package:interval/src/manage_interval/views/pages/create_or_update_interval_session.dart';

class IntervalSessionTile extends StatelessWidget {
  const IntervalSessionTile(this.interval, {super.key});

  final IntervalSession interval;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          interval.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: interval.description == null
            ? null
            : Text(
                interval.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final cubit = context.read<HomeViewModelCubit>();
                final result = await context.push<bool>(
                  CreateOrUpdateIntervalSessionPage.path,
                  extra: interval,
                );

                if (result ?? false) {
                  unawaited(cubit.getIntervalSessions(ascending: false));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                final cubit = context.read<HomeViewModelCubit>();
                final result = await CoreUtils.showConfirmationDialog(
                  context,
                  confirmColor: Colors.red,
                  title: context.l10n.deleteIntervalConfirmationTitle,
                  message: context.l10n.deleteIntervalConfirmationMessage,
                  confirmText: context.l10n.deleteIntervalConfirmationDelete,
                  cancelText: context.l10n.deleteIntervalConfirmationCancel,
                );

                if (result) {
                  unawaited(cubit.deleteIntervalSession(interval.id));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
