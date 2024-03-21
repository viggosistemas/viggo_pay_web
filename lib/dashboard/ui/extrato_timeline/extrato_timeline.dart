import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';

class ExtratoTimeline extends StatelessWidget {
  const ExtratoTimeline({
    super.key,
    required this.listExtrato,
  });

  final List<ExtratoApiDto> listExtrato;

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
        itemCount: 5,//listExtrato.length,
        itemBuilder: (ctx, index) => ListTile(
          horizontalTitleGap: 20,
          leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.pix_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          contentPadding: const EdgeInsets.only(right: 16),
          title: Text(
            listExtrato[index].description,
            style: GoogleFonts.lato(
              color: Theme.of(context).colorScheme.primary,
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
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
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
