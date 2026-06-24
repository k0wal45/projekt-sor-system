import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EsorLogo extends StatelessWidget {
  const EsorLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/esor-logo.svg', width: 20.0),
        const SizedBox(width: 6.0),
        Text(
          'E-SOR',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 24.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
