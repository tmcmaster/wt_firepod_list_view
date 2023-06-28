import 'package:flutter/material.dart';
import 'package:wt_models/wt_models.dart';

class FirepodListTile<T extends IdJsonSupport> extends StatefulWidget {
  final T model;
  final Widget Function(T model) itemBuilder;
  final void Function(T model)? onDelete;
  final void Function(T model)? onEdit;
  final void Function(T model)? onTap;
  final void Function(T model, bool selected)? onSelect;
  final bool initSelected;
  final EdgeInsets padding;
  const FirepodListTile({
    super.key,
    required this.model,
    required this.itemBuilder,
    this.onDelete,
    this.onEdit,
    this.onTap,
    this.onSelect,
    this.initSelected = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<FirepodListTile<T>> createState() => _FirepodListTileState<T>();
}

class _FirepodListTileState<T extends IdJsonSupport> extends State<FirepodListTile<T>> {
  bool? selected;

  @override
  Widget build(BuildContext context) {
    final item = Padding(
      padding: widget.padding,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        style: ListTileStyle.list,
        horizontalTitleGap: 0,
        leading: widget.onSelect == null
            ? null
            : Checkbox(
                value: selected ?? widget.initSelected,
                onChanged: (value) {
                  widget.onSelect?.call(widget.model, value ?? false);
                  setState(() {
                    selected = value ?? false;
                  });
                },
              ),
        title: widget.itemBuilder(widget.model),
        trailing: widget.onEdit == null
            ? null
            : IconButton(
                onPressed: () => widget.onEdit?.call(widget.model),
                icon: const Icon(Icons.edit),
              ),
      ),
    );
    final tile = widget.onDelete == null
        ? item
        : Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction) {
              widget.onDelete?.call(widget.model);
            },
            key: ValueKey(widget.model.getId()),
            child: item,
          );
    return widget.onTap == null
        ? tile
        : GestureDetector(
            onTap: () => widget.onTap?.call(widget.model),
            child: tile,
          );
  }
}
