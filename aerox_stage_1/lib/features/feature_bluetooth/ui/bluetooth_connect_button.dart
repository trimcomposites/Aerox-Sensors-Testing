import 'dart:async';

import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_rackets_list.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothConnectButton extends StatelessWidget {
  const BluetoothConnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool _isModalOpen = false;

    return Container(
      width: 250,
      height: 100,
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          if (_isModalOpen) return;
          _isModalOpen = true;

          StreamSubscription<BluetoothAdapterState>? bluetoothSub;

          try {
            final state = await FlutterBluePlus.adapterState
                .firstWhere((s) => s == BluetoothAdapterState.on)
                .timeout(const Duration(seconds: 5));

            if (!context.mounted) return;

            await showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              builder: (BuildContext context) {
                bluetoothSub = FlutterBluePlus.adapterState.listen((s) {
                  if (s != BluetoothAdapterState.on) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                });

                return const BluetoothRacketsList();
              },
            );

            bluetoothSub?.cancel();

            if (context.mounted) {
              final sensorsBloc = BlocProvider.of<SensorsBloc>(context);
              sensorsBloc.add(OnStopScanBluetoothSensors());
            }
          } catch (e) {
            bluetoothSub?.cancel();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Activa el Bluetooth para conectar.")),
              );
            }
          } finally {
            _isModalOpen = false;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                'CONECTA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 40,
                width: 40,
                color: appYellowColor,
                child: const Icon(Icons.bluetooth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
