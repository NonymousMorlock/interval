import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/common/widgets/app_state_reactor.dart';
import 'package:interval/core/services/injection_container.dart';
import 'package:interval/src/home/view_models/home_view_model_cubit.dart';
import 'package:interval/src/home/views/pages/home_page.dart';
import 'package:interval/src/manage_interval/view_models/manage_interval_cubit.dart';
import 'package:interval/src/manage_interval/views/pages/create_or_update_interval_session.dart';
import 'package:interval/src/session/views/app/provider/timer_animation_controller.dart';
import 'package:interval/src/session/views/pages/countdown_page.dart';
import 'package:provider/provider.dart';

part 'router.main.dart';
