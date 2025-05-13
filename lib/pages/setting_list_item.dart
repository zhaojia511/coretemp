import 'package:flutter/material.dart';

/// 列表项
class ListItem extends StatefulWidget {
  /// 点击事件
  final VoidCallback? onPressed;

  /// 标题
  final String title;
  final double? titleFontSize;
  final Color? titleColor;
  final String? imgPath;

  /// 描述
  final String describe;
  final Color describeColor;

  /// 右侧控件
  final Widget? rightWidget;
  final bool isShowLine;

  /// 构造函数
  const ListItem({
    Key? key,
    this.onPressed,
    this.title = "",
    this.titleFontSize,
    this.titleColor,
    this.describe = "",
    this.describeColor = const Color(0xFF999999),
    this.rightWidget,
    this.imgPath,
    this.isShowLine = true,
  }) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isShowLine
                  ? const Divider(
                color: Color(0xFFEEEEEE),
                height: 1,
              )
                  : Container(),
              const Divider(
                height: 14,
                color: Colors.transparent,
              ),
              Wrap(children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.titleColor ?? const Color(0xFF222222),
                      fontSize: widget.titleFontSize ?? 14),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                ),
                Container(),
              ]),
              const Padding(padding: EdgeInsets.all(2)),
              Text(
                widget.describe,
                style: TextStyle(color: widget.describeColor, fontSize: 12),
              ),
              const Divider(
                height: 14,
                color: Colors.transparent,
              )
            ],
          )),
    );
  }
}

class ListSectionTitle extends StatelessWidget {
  const ListSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 44,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),),
              icon,
            ],
          ),
        )
    );
  }
}
