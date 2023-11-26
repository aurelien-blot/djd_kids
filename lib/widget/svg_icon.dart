import 'package:djd_kids/bloc/fight/fight_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/fight/fight_event.dart';
import '../model/character.dart';

class SvgIcon extends StatelessWidget {
  final String path;


  const SvgIcon({Key? key,required this.path}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(0,8,0,0),
      child : SvgPicture.asset(path),
    );
  }
}
