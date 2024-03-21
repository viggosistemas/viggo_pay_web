import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/extrato/ui/extrato_pdv_viewer.dart';
import 'package:viggo_pay_admin/extrato/ui/extrato_timeline/extrato_timeline.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class TimelineExtratoPage extends StatefulWidget {
  const TimelineExtratoPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  State<TimelineExtratoPage> createState() => _TimelineExtratoPageState();
}

class _TimelineExtratoPageState extends State<TimelineExtratoPage> {
  TimelineExtratoViewModel viewModel = locator.get<TimelineExtratoViewModel>();

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  );

  Map<String, String> initialParams = {
    'start': DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1)),
    'ending': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  };

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

    viewModel.errorMessage.listen((value) {
      if (value.isNotEmpty && context.mounted) {
        viewModel.clearError();
        showInfoMessage(
          context,
          2,
          Colors.red,
          value,
          'X',
          () {},
          Colors.white,
        );
      }
    });

    Future pickDateRange() async {
      DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: dateRange.start,
        lastDate: dateRange.end,
        initialEntryMode: DatePickerEntryMode.input,
        confirmText: 'Confirmar',
      );

      if (newDateRange == null) return;

      setState(() {
        viewModel.loadExtrato(viewModel.materaId, {
          'start': DateFormat('yyyy-MM-dd').format(newDateRange.start),
          'ending': DateFormat('yyyy-MM-dd').format(newDateRange.end),
        });
        dateRange = newDateRange;
      });
    }

    return AppBuilder(
      changeTheme: widget.changeTheme,
      child: StreamBuilder<DomainAccountApiDto?>(
          stream: viewModel.matriz,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              viewModel.catchEntity();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Faixa de datas',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: pickDateRange,
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                            ),
                            label: Text(DateFormat('dd/MM/yyyy').format(start)),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: pickDateRange,
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                            ),
                            label: Text(DateFormat('dd/MM/yyyy').format(end)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) => Dialog.fullscreen(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: ExtratoPdfViewer(
                              domainAccountId: snapshot.data!.id,
                              params: {
                                'start': DateFormat('yyyy-MM-dd')
                                    .format(dateRange.start),
                                'ending': DateFormat('yyyy-MM-dd')
                                    .format(dateRange.end),
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    label: const Text('Gerar extrato em PDF'),
                    icon: const Icon(
                      Icons.picture_as_pdf_outlined,
                    ),
                  ),
                  StreamBuilder<ExtratoSaldoApiDto>(
                    stream: viewModel.extrato,
                    builder: (context, extrato) {
                      if (extrato.data == null) {
                        viewModel.loadExtrato(
                          snapshot.data!.materaId!,
                          initialParams,
                        );
                        return const CircularProgressIndicator();
                      } else {
                        return Expanded(
                          child: TimelineExtrato(
                            extratoSaldo: extrato.data!,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
