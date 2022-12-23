import 'package:aibas/view/components/create_pj/temp/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class CompSetIgnoreFiles extends ConsumerStatefulWidget {
  const CompSetIgnoreFiles({super.key});

  @override
  _CompSetIgnoreFilesState createState() => _CompSetIgnoreFilesState();
}

class _CompSetIgnoreFilesState extends ConsumerState<CompSetIgnoreFiles> {
  String _selectedNode = '';
  TreeViewController _treeViewController = TreeViewController();
  bool docsOpen = true;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = {
    ExpanderType.none: Container(),
    ExpanderType.caret: const Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: const Icon(Icons.arrow_downward),
    ExpanderType.chevron: const Icon(Icons.expand_more),
    ExpanderType.plusMinus: const Icon(Icons.add),
  };
  final ExpanderPosition _expanderPosition = ExpanderPosition.start;
  final ExpanderType _expanderType = ExpanderType.caret;
  final ExpanderModifier _expanderModifier = ExpanderModifier.none;
  final bool _allowParentSelect = false;
  final bool _supportParentDoubleTap = false;

  @override
  void initState() {
    _treeViewController = _treeViewController.loadJSON<String>(json: us);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        size: 20,
        color: Colors.blue,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: TreeView(
                  controller: _treeViewController,
                  allowParentSelect: _allowParentSelect,
                  supportParentDoubleTap: _supportParentDoubleTap,
                  onExpansionChanged: _expandNode,
                  onNodeTap: (key) {
                    debugPrint('Selected: $key');
                    setState(() {
                      _selectedNode = key;
                      _treeViewController =
                          _treeViewController.copyWith<Key>(selectedKey: key);
                    });
                  },
                  theme: treeViewTheme,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  _treeViewController.getNode<dynamic>(_selectedNode) == null
                      ? ''
                      : _treeViewController
                              .getNode<dynamic>(_selectedNode)
                              ?.label ??
                          '',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _expandNode(String key, bool expanded) {
    final msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    final node = _treeViewController.getNode<dynamic>(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode<dynamic>(
          key,
          node.copyWith(
            expanded: expanded,
            icon: expanded ? Icons.folder_open : Icons.folder,
          ),
        );
      } else {
        updated = _treeViewController.updateNode<dynamic>(
          key,
          node.copyWith(expanded: expanded),
        );
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController =
            _treeViewController.copyWith<dynamic>(children: updated);
      });
    }
  }
}
