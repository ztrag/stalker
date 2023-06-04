import 'package:flutter/material.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/map/stalker_map_page.dart';

class StalkTargetCard extends StatefulWidget {
  final StalkTarget stalkTarget;

  const StalkTargetCard({Key? key, required this.stalkTarget})
      : super(key: key);

  @override
  State<StalkTargetCard> createState() => _StalkTargetCardState();
}

class _StalkTargetCardState extends State<StalkTargetCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _TopRow(
                  stalkTarget: widget.stalkTarget,
                  isExpanded: _isExpanded,
                ),
                if (_isExpanded) _BottomRow(stalkTarget: widget.stalkTarget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  final StalkTarget stalkTarget;
  final bool isExpanded;

  const _TopRow({Key? key, required this.stalkTarget, required this.isExpanded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (stalkTarget.profilePictureUrl != null) ...[
          SizedBox(
            width: 60,
            height: 60,
            child: InkWell(
              onTap: () {
                print('Target menu...');
              },
              child: Image(
                image: NetworkImage(stalkTarget.profilePictureUrl!),
                errorBuilder: (c, _, __) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${stalkTarget.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${stalkTarget.token}',
                maxLines: isExpanded ? null : 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(value: true, onChanged: (v) {}),
      ],
    );
  }
}

class _BottomRow extends StatelessWidget {
  final StalkTarget stalkTarget;

  const _BottomRow({Key? key, required this.stalkTarget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Last seen',
                  style: TextStyle(fontSize: 7),
                ),
                Text(
                  '2d ago',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '@45.4343,-122.3232',
                  style: TextStyle(fontSize: 7),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => StalkerMapPage(stalkTarget: stalkTarget),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('STALK'),
            ),
          ),
        ],
      ),
    );
  }
}
