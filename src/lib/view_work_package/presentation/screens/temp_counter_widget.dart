import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/view_work_package/presentation/cubits/temp_cubit.dart';

class TempCounterWidget extends StatelessWidget {
  const TempCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<CounterCubit, int>(
        builder: (context, state) {
          return Text(
            state.toString(),
            style: const TextStyle(fontSize: 56),
          );
        },
      ),
    );
  }
}
