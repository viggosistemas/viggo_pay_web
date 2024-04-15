import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/components/timeline_tile.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/utils/container.dart';

class TimelineMatriz extends StatelessWidget {
  const TimelineMatriz({
    super.key,
    required this.listTransferencia,
  });

  final List<ExtratoApiDto> listTransferencia;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return listTransferencia.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
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
                  itemCount: listTransferencia.length,
                  itemBuilder: (ctx, index) => TimelineAppTile(
                    isFirst: index == 0,
                    isLast: index == listTransferencia.length - 1,
                    isPast: index != listTransferencia.length - 1,
                    iconInfo: Icons.monetization_on_outlined,
                    eventCard: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              listTransferencia[index].description,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                                    : Theme.of(context).colorScheme.onPrimary,
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
                              '${listTransferencia[index].type == 'D' ? '-' : '+'} R\$ ${listTransferencia[index].amount}',
                              style: GoogleFonts.lato(
                                color: listTransferencia[index].type == 'D' ? Colors.red : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(listTransferencia[index].creditDate)),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color:
                                    Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
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
