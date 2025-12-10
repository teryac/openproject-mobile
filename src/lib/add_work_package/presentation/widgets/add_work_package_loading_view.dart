import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/shimmer.dart';

class AddWorkPackageLoadingView extends StatelessWidget {
  const AddWorkPackageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 100, height: 65),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 65),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 65,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemCount: 7,
              itemBuilder: (_, __) => ShimmerBox(width: 150, height: 65),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ShimmerBox(width: double.infinity, height: 100),
                const SizedBox(height: 36),
                ShimmerBox(width: double.infinity, height: 65),
                const SizedBox(height: 12),
                ShimmerBox(width: double.infinity, height: 65),
              ],
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemCount: 4,
              itemBuilder: (_, __) => ShimmerBox(width: 135, height: 100),
            ),
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 175),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 175),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 24),
                ShimmerBox(width: double.infinity, height: 65),
                const SizedBox(height: 36),
                ShimmerBox(width: double.infinity, height: 65),
                const SizedBox(height: 12),
                ShimmerBox(width: double.infinity, height: 65),
                const SizedBox(height: 24),
                ShimmerBox(
                  width: double.infinity,
                  height: 35,
                ),
                const SizedBox(height: 24),
                ShimmerBox(width: double.infinity, height: 75),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
