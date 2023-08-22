import 'package:flutter/material.dart';
import 'package:zzsports/pages/setting_list_item.dart';

class DeviceSetting extends StatelessWidget {
  DeviceSetting({super.key});

  final List<String> deviceInfo = [
    '名称',
    '序列号',
    'ANT +id',
    '电量',
    '固件版本',
  ];

  final List<String> warnings = [
    '温度预警'
    '高温预警 - 40℃',
    '低温预警 - 34℃',
  ];

  final List<String> preferences = [
    '偏好设置1',
    '偏好设置2',
    '偏好设置3',
    '偏好设置4',
    '偏好设置5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body:
      ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildSection('设备信息', deviceInfo);
          } else if (index == 1) {
            return _buildSection('预警', warnings);
          } else if (index == 2) {
            return _buildSection('偏好设置', preferences);
          }
          return Container(); // 返回一个空容器作为默认情况
        },
      ),
    );
  }

  Widget _buildSection(String title, List<String> rowsData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.info_outline_rounded),
        ),
        const Divider(),
        Column(children: rowsData.map((e) => _buildInfoRow(e, e, Icons.info)).toList()),
        const Divider(),
      ],
    );
  }

  Widget _buildInfoRow(String title, String info, IconData icon) {
    return ListTile(
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(info),
        ],
      ),
      trailing: Icon(icon),
    );
  }

  Widget _buildSwitchRow(String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Switch(
        value: true,
        onChanged: (bool value) {},
      ),
    );
  }

  Widget _buildTextRow(String title, String info, IconData icon) {
    return ListTile(
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(info),
        ],
      ),
      trailing: Icon(icon),
    );
  }
}