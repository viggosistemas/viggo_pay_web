import 'package:flutter/material.dart';
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
          eventCard: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Valor total R\$ $index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Destinatário...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
