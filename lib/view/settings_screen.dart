import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings/settings_bloc.dart';
import '../bloc/settings/settings_event.dart';
import '../bloc/settings/settings_state.dart';
import '../widget/loading_dialog.dart';
import '../widget/svg_icon.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const LoadingDialog();
        }
        if (state is SettingsLoaded) {
          return Scaffold(
            body:
            Padding(padding: const EdgeInsets.all(40),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:200,
                  child :TextFormField(
                    controller: context.read<SettingsBloc>().codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Code secret'),
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(ResetDatabaseEvent());
                  },
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(ReloadDatabaseEvent());
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(CleanFightEvent());
                  },
                  child: const SvgIcon(path: 'assets/icons/weapons.svg'),
                ),
              ]
            ),
            ),
          );
        }
        if (state is SettingsError) {
          return const Center(child: Text('Erreur de chargement des paramètres'));
        }
        return const LoadingDialog();
      },
    );
  }
}
