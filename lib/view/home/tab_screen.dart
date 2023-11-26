import 'package:djd_kids/bloc/fight/fight_bloc.dart';
import 'package:djd_kids/bloc/weapon/weapons_bloc.dart';
import 'package:djd_kids/service/ability_service.dart';
import 'package:djd_kids/widget/loading_dialog.dart';
import 'package:djd_kids/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/creature/creatures_bloc.dart';
import '../../bloc/home/tab_bloc.dart';
import '../../bloc/home/tab_event.dart';
import '../../bloc/home/tab_state.dart';
import '../../service/database_service.dart';
import '../creatures_screen.dart';
import '../fight_screen.dart';
import '../weapons_screen.dart';

class TabScreen extends StatelessWidget {
  TabScreen({super.key});

  static const String _titleLabel='D&D Utility';
  final DatabaseService databaseService = DatabaseService.instance;
  final AbilityService abilityService = AbilityService();

  @override
  Widget build(BuildContext context) {
    // Le DefaultTabController englobe le Scaffold
    return DefaultTabController(
      length: 3, // Le nombre total d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_titleLabel),
          bottom: TabBar(
            // Pas besoin de spécifier un TabController ici
            onTap: (index) {
              context.read<TabBloc>().add(TabChanged(index));
            },
            tabs: const [
              Tab(icon: SvgIcon(path: 'assets/icons/fight.svg')),
              Tab(icon: SvgIcon(path: 'assets/icons/cyclop.svg')),
              Tab(icon: SvgIcon(path: 'assets/icons/weapons.svg')),
            ],
          ),
        ),
        body: BlocBuilder<TabBloc, TabState>(
          builder: (context, state) {
            if (state is TabLoading) {
              return const LoadingDialog();
            } else if (state is TabLoaded) {
              switch (state.index) {
                case 0:
                  return BlocProvider (
                    create: (context) => FightBloc(databaseService, abilityService),
                    child: FightScreen(databaseService: databaseService),
                  );
                case 1:
                  return BlocProvider (
                    create: (context) => CreaturesBloc(databaseService),
                    child: const CreaturesScreen(),
                  );
                case 2:
                  return BlocProvider (
                    create: (context) => WeaponsBloc(databaseService),
                    child: const WeaponsScreen(),
                  );
                default:
                  return const Center(child: Text('Unknown Tab'));
              }
            }
            return const Center(child: Text('Please select a tab'));
          },
        ),
      ),
    );
  }
}
