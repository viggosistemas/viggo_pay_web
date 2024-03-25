import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';

class ExtratoTimeline extends StatelessWidget {
  const ExtratoTimeline({
    super.key,
    required this.listExtrato,
    required this.lengthExtrato,
  });

  final List<ExtratoApiDto> listExtrato;
  final int lengthExtrato;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: MediaQuery.of(context).size.width * 0.3,
      child: ListView.builder(
        itemCount: lengthExtrato <= listExtrato.length
            ? lengthExtrato
            : listExtrato.length,
        itemBuilder: (ctx, index) => Card(
          elevation: 3,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.8)
              : Theme.of(context).colorScheme.primary,
          child: ListTile(
            horizontalTitleGap: 20,
            leading: CircleAvatar(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              listExtrato[index].description,
              style: GoogleFonts.lato(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${listExtrato[index].type == 'D' ? '-' : '+'} R\$ ${listExtrato[index].amount}',
                  style: GoogleFonts.lato(
                    color: listExtrato[index].type == 'D'
                        ? Colors.red
                        : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(listExtrato[index].creditDate)),
                  style: GoogleFonts.lato(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        // TimelineAppTile(
        //   isFirst: index == 0,
        //   isLast: index == listExtrato.length - 1,
        //   isPast: index != listExtrato.length - 1,
        //   iconInfo: Icons.monetization_on_outlined,
        //   eventCard: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Row(
        //         children: [
        //           const Icon(
        //             Icons.pix_outlined,
        //             color: Colors.white,
        //           ),
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           Text(
        //             listExtrato[index].description,
        //             style: GoogleFonts.lato(
        //               color: Colors.white,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Text(
        //             '${listExtrato[index].type == 'D' ? '-' : '+'} R\$ ${listExtrato[index].amount}',
        //             style: GoogleFonts.lato(
        //               color: listExtrato[index].type == 'D'
        //                   ? Colors.red
        //                   : Colors.green,
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           Text(
        //             DateFormat('dd/MM/yyyy')
        //                 .format(DateTime.parse(listExtrato[index].creditDate)),
        //             style: GoogleFonts.lato(
        //               color: Colors.white.withOpacity(0.7),
        //             ),
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
