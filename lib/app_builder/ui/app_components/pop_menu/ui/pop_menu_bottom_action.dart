import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';

class PopMenuBottomAction extends StatelessWidget {
  const PopMenuBottomAction({
    super.key,
    required this.viewModel,
  });

  final AppBuilderViewModel viewModel;

  @override
  Widget build(context) {
    return Expanded(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<UserApiDto?>(
                  stream: viewModel.userDto,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) viewModel.getUser();
                    return Text(
                      snapshot.data?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    );
                  }),
              StreamBuilder<DomainApiDto?>(
                  stream: viewModel.domainDto,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) viewModel.getDomain();
                    return Text(
                      snapshot.data?.name ?? snapshot.data?.displayName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    );
                  }),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
