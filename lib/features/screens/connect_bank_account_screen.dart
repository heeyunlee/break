import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class ConnectBankAcocuntScreen extends StatelessWidget {
  const ConnectBankAcocuntScreen({Key? key}) : super(key: key);

  static show(BuildContext context) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => const ConnectBankAcocuntScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarCloseButton(),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: size.width - 64,
                    child: Column(
                      children: const [
                        Text(
                          'Connect your bank account with Plaid',
                          style: TextStyles.headline6,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'We will automatically log your daily consumption using your credit card transactions',
                          style: TextStyles.body1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text(
            'Connect acocunt',
            style: TextStyles.button1,
          ),
        ),
      ),
    );
  }
}
