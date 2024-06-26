import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/components/timeline_tile.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/utils/container.dart';

class TimelineExtrato extends StatelessWidget {
  const TimelineExtrato({
    super.key,
    required this.extratoSaldo,
  });

  final ExtratoSaldoApiDto extratoSaldo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return extratoSaldo.extrato.isEmpty
            ? Center(
                child: Text(
                  'Nenhum lançamento registrado pro dia de hoje!',
                  style: GoogleFonts.lato(fontSize: 18),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                width: ContainerClass().maxWidthContainer(constraints, context, true),
                child: ListView.builder(
                  itemCount: extratoSaldo.extrato.length,
                  itemBuilder: (ctx, index) => TimelineAppTile(
                    isFirst: index == 0,
                    isLast: index == extratoSaldo.extrato.length - 1,
                    isPast: index != extratoSaldo.extrato.length - 1,
                    iconInfo: Icons.monetization_on_outlined,
                    eventCard: Wrap(
                      alignment: constraints.maxWidth <= 960 ? WrapAlignment.center : WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: constraints.maxWidth <= 960 ? Axis.horizontal : Axis.vertical,
                      runAlignment: constraints.maxWidth <= 960 ? WrapAlignment.center : WrapAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onPrimary,
                                  child: Icon(
                                    Icons.pix_outlined,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  extratoSaldo.extrato[index].description,
                                  style: GoogleFonts.lato(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(extratoSaldo.extrato[index].creditDate)),
                              style: GoogleFonts.lato(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                                    : Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${extratoSaldo.extrato[index].type == 'D' ? '-' : '+'} R\$ ${extratoSaldo.extrato[index].amount}',
                              style: GoogleFonts.lato(
                                color: extratoSaldo.extrato[index].type == 'D' ? Colors.red : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Saldo: R\$ ${extratoSaldo.extrato[index].saldoPre} - R\$ ${extratoSaldo.extrato[index].saldoPos}',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                                    : Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
