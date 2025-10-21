import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/counter_cubit.dart';
import 'package:open_project/core/styles/text_styles.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, int>(
      builder: (context, state) {
        return Text(
          '$state',
          style: AppTextStyles.extraLarge.copyWith(
            fontSize: 64,
          ),
        );
      },
    );
  }
}
