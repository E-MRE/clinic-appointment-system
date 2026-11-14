part of 'admin_home_page.dart';

/// Places the overview header and live dashboard data in the page column.
final class _AdminHomeView extends StatelessWidget {
  const _AdminHomeView({required this.clock});

  final Clock clock;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AdminLayoutConstants.overviewContentMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s24,
            children: [
              _AdminHomeHeader(clock: clock),
              _AdminHomeDataState(clock: clock),
            ],
          ),
        ),
      ),
    );
  }
}
