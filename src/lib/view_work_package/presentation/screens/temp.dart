import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/view_work_package/presentation/cubits/temp_cubit.dart';
import 'package:open_project/view_work_package/presentation/screens/temp_counter_widget.dart';

class TempScreen extends StatelessWidget {
  const TempScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: const CustomAppBar(text: 'Counter'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<CounterCubit>().increment();
              },
              child: const Icon(Icons.add),
            ),
            body: const TempCounterWidget(),
          );
        },
      ),
    );
  }
}
