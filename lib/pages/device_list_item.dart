import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

typedef OnTapDeviceAction = Function(BuildContext context, DiscoveredDevice device);

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({
    super.key,
    required this.device,
    required this.onTapAction,
  });

  final DiscoveredDevice device;
  final OnTapDeviceAction onTapAction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        device.name.isNotEmpty ? device.name : "Unnamed",
      ),
      subtitle: Text(
        """
${device.id}
RSSI: ${device.rssi}
${device.connectable}
                      """,
      ),
      leading: const Icon(Icons.bluetooth),
      onTap: () => onTapAction(context, device),
    );
  }
}