import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam_podcaster/gen/assets.gen.dart';

class BuildNetworkImage extends StatelessWidget {
  const BuildNetworkImage(
      {super.key,
      required this.image,
      required this.width,
      required this.height});
  final String? image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Image.network(
            image!,
            width: width,
            height: height,
            errorBuilder: ((context, error, stackTrace) {
              return Image.asset(Assets.images.notfound.path,
                  width: width, height: height);
            }),
          )
        : Image.asset(
            Assets.images.notfound.path,
            width: width,
            height: height,
          );
  }
}
