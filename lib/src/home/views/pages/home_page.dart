import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/singletons/current_platform.dart';
import 'package:interval/core/utils/core_utils.dart';
import 'package:interval/src/home/view_models/home_view_model_cubit.dart';
import 'package:interval/src/home/views/pages/responsive/mobile.dart';
import 'package:interval/src/home/views/widgets/theme_toggle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const path = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IntervalSession> intervals = [];
  @override
  void initState() {
    super.initState();
    context.read<HomeViewModelCubit>().getIntervalSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeToggle(), Gap(20)],
      ),
      body: BlocConsumer<HomeViewModelCubit, HomeViewModelState>(
        listener: (context, state) {
          if (state case HomeViewModelError(:final message)) {
            if (CurrentPlatform.instance.isDesktop) {
              CoreUtils.showErrorAlert(message: message);
            } else {
              CoreUtils.showSnackBar(context, message: message);
            }
          } else if (state case IntervalsFetched(:final intervals)) {
            this.intervals = intervals;
          }
        },
        builder: (_, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: state is HomeViewModelLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : HomeMobileView(intervals: intervals),
          );
        },
      ),
      floatingActionButton: CurrentPlatform.instance.isDesktop
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Create Interval Session'),
              icon: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
    );
  }
}