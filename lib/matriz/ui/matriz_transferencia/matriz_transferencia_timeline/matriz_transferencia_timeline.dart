import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/components/timeline_tile.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';

class TimelineMatriz extends StatelessWidget {
  const TimelineMatriz({
    super.key,
    required this.listTransferencia,
  });

  final List<TransacaoApiDto> listTransferencia;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
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
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
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
                    'Transferência de retirada',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7)
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
                    'R\$ ${listTransferencia[index].totalAmount}',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(
                        listTransferencia[index].transactionDate)),
                    style: GoogleFonts.lato(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7)
                          : Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.7),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
