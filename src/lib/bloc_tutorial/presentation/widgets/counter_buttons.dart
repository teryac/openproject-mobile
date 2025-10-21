import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/counter_cubit.dart';

class CounterButtons extends StatelessWidget {
  const CounterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            context.read<CounterCubit>().increment();
          },
          icon: const Icon(
            Icons.add,
            size: 64,
          ),
        ),
        const SizedBox(width: 22),
        IconButton(
          onPressed: () {
            context.read<CounterCubit>().decrement();
          },
          icon: const Icon(
            Icons.remove,
            size: 64,
          ),
        ),
      ],
    );
  }
}
