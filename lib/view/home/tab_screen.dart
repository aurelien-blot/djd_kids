import 'package:djd_kids/bloc/fight/fight_bloc.dart';
import 'package:djd_kids/bloc/weapon/weapons_bloc.dart';
import 'package:djd_kids/service/ability_service.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/widget/loading_dialog.dart';
import 'package:djd_kids/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/character/characters_bloc.dart';
import '../../bloc/creature/creatures_bloc.dart';
import '../../bloc/home/tab_bloc.dart';
import '../../bloc/home/tab_event.dart';
import '../../bloc/home/tab_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../service/database_service.dart';
import '../characters_screen.dart';
import '../creatures_screen.dart';
import '../fight_screen.dart';
import '../settings_screen.dart';
import '../weapons_screen.dart';

class TabScreen extends StatelessWidget {
  TabScreen({super.key});

  static const String _titleLabel='D&D Utility';
  final DatabaseService databaseService = DatabaseService.instance;
  final AbilityService abilityService = AbilityService();
  final CharacterService characterService = CharacterService();

  @override
  Widget build(BuildContext context) {
    // Le DefaultTabController englobe le Scaffold
    return DefaultTabController(
      length: 5, // Le nombre total d'onglets
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
              Tab(icon: SvgIcon(path: 'assets/icons/wizard.svg')),
              Tab(icon: SvgIcon(path: 'assets/icons/cyclop.svg')),
              Tab(icon: SvgIcon(path: 'assets/icons/weapons.svg')),
              Tab(icon: Icon(Icons.settings)),
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
                    create: (context) => FightBloc(databaseService, abilityService, characterService),
                    child: FightScreen(databaseService: databaseService, characterService: characterService),
                  );
                case 1:
                  return BlocProvider (
                    create: (context) => CharactersBloc(databaseService),
                    child: const CharactersScreen(),
                  );
                case 2:
                  return BlocProvider (
                    create: (context) => CreaturesBloc(databaseService),
                    child: const CreaturesScreen(),
                  );
                case 3:
                  return BlocProvider (
                    create: (context) => WeaponsBloc(databaseService),
                    child: const WeaponsScreen(),
                  );
                case 4:
                  return BlocProvider (
                    create: (context) => SettingsBloc(databaseService),
                    child: const SettingsScreen(),
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
