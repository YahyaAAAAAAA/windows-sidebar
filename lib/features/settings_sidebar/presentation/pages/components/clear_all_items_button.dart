import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/widgets/global_loading.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_states.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_small_button.dart';

class DeleteAllItemsButton extends StatelessWidget {
  final void Function()? onPressed;

  const DeleteAllItemsButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            'Delete All Items',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        BlocConsumer<SideItemsCubit, SideItemsStates>(
          listener: (context, state) {
            if (state is SideItemsError) {
              context.showSnackBar(state.message);
            }
          },
          builder: (context, state) {
            return SideSmallButton(
              onPressed: state is SideItemsLoading ? null : onPressed,
              height: 40,
              width: 40,
              buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).scaffoldBackgroundColor.shade600),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).primaryColor.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
              child: state is SideItemsLoading
                  ? GlobalLoading()
                  : Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                    ),
            );
          },
        ),
      ],
    );
  }
}
