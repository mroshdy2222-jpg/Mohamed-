import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../data/photos.dart';
import '../data/tagging.dart';
import '../domain/fashion_color.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'item_swatch.dart';
import 'labels.dart';
import 'theme.dart';

/// Adds one piece: an optional photo, then type, colour and styles. When the
/// build has a server, the photo pre-fills these choices; the screen stays the
/// place to check and correct them.
class AddItemScreen extends StatefulWidget {
  final AppState state;

  /// Replaces the camera and gallery in tests.
  final Future<Uint8List?> Function(ImageSource source)? pickPhoto;

  const AddItemScreen({super.key, required this.state, this.pickPhoto});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  Category _category = Category.top;
  FashionColor _color = Palette.white;
  Pattern _pattern = Pattern.solid;
  Season _season = Season.all;
  final Set<Style> _styles = {Style.casual};
  Uint8List? _photo;
  bool _saving = false;

  /// Types most pieces fall into; the rest open behind "more types".
  static const _commonTypes = [
    Category.top,
    Category.bottom,
    Category.onePiece,
    Category.outerwear,
    Category.shoes,
    Category.bag,
    Category.headscarf,
  ];
  bool _allTypes = false;

  /// What the auto-tagging said about the last photo, shown under it.
  String? Function(AppLocalizations)? _tagNote;

  /// Headscarves, sunglasses and other accessories go with every style, so
  /// the style question is skipped for them. Bags, belts, watches, jewellery
  /// and perfume do depend on it: a gym bag is not an evening clutch.
  bool get _styleFree =>
      const {Category.headscarf, Category.sunglasses, Category.neckScarf, Category.accessory}.contains(_category);

  Future<void> _pick(ImageSource source) async {
    final Uint8List? bytes;
    if (widget.pickPhoto != null) {
      bytes = await widget.pickPhoto!(source);
    } else {
      final file = await ImagePicker().pickImage(source: source, maxWidth: 900, imageQuality: 75);
      bytes = await file?.readAsBytes();
    }
    if (bytes == null || !mounted) return;
    setState(() {
      _photo = bytes;
      _tagNote = null;
    });
    final tagger = widget.state.taggingService;
    if (tagger != null) await _autoTag(tagger, bytes);
  }

  Future<void> _autoTag(TaggingService tagger, Uint8List bytes) async {
    setState(() => _tagNote = (t) => t.tagging);
    try {
      final tags = await tagger.tag(bytes);
      if (!mounted) return;
      setState(() {
        _category = tags.category ?? _category;
        _color = tags.color ?? _color;
        _pattern = tags.pattern ?? _pattern;
        _season = tags.season ?? _season;
        if (tags.styles.isNotEmpty) {
          _styles
            ..clear()
            ..addAll(tags.styles);
        }
        _tagNote = (t) => t.tagged;
      });
    } on TaggingException catch (e) {
      if (!mounted) return;
      setState(() => _tagNote = e.reason == TagFailure.personInPhoto ? (t) => t.tagPerson : (t) => t.tagFailed);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final id = 'i-${DateTime.now().microsecondsSinceEpoch}';
    final photo = _photo == null ? null : await savePhoto(id, _photo!);
    widget.state.addItems([
      Item(
        id: id,
        category: _category,
        color: _color,
        pattern: _pattern,
        season: _season,
        styles: _styleFree ? const {} : Set.of(_styles),
        photoPath: photo,
      ),
    ]);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(top: Space.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleMedium),
          const SizedBox(height: Space.s2),
          child,
        ],
      ),
    );

    Widget chips<T>(List<T> values, bool Function(T) selected, String Function(T) label, void Function(T) onTap) =>
        Wrap(
          spacing: Space.s2,
          runSpacing: Space.s2,
          children: [
            for (final v in values)
              ChoiceChip(label: Text(label(v)), selected: selected(v), onSelected: (_) => onTap(v)),
          ],
        );

    return Scaffold(
      appBar: AppBar(title: Text(t.addItem), backgroundColor: c.surface),
      body: ListView(
        padding: const EdgeInsets.all(Space.s4),
        children: [
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 128,
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.sm),
                        child: Image.memory(
                          _photo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => ItemSwatch(
                            onPage: true,
                            item: Item(id: 'preview', category: _category, color: _color),
                          ),
                        ),
                      )
                    : ItemSwatch(
                        onPage: true,
                        item: Item(id: 'preview', category: _category, color: _color),
                      ),
              ),
              const SizedBox(width: Space.s4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: Space.s2,
                      runSpacing: Space.s2,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _pick(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: Text(t.takePhoto),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _pick(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(t.fromGallery),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.s2),
                    Text(t.photoOptional, style: text.bodyMedium),
                    if (_tagNote?.call(t) case final note?) ...[
                      const SizedBox(height: Space.s1),
                      Text(note, key: const Key('tagNote'), style: text.bodyLarge),
                    ],
                  ],
                ),
              ),
            ],
          ),
          section(
            t.categoryLabel,
            Wrap(
              spacing: Space.s2,
              runSpacing: Space.s2,
              children: [
                for (final v in _allTypes || !_commonTypes.contains(_category) ? Category.values : _commonTypes)
                  ChoiceChip(
                    label: Text(t.category(v)),
                    selected: v == _category,
                    onSelected: (_) => setState(() => _category = v),
                  ),
                if (!_allTypes && _commonTypes.contains(_category))
                  ActionChip(
                    key: const Key('moreTypes'),
                    label: Text(t.moreTypes),
                    avatar: const Icon(Icons.add_rounded, size: 18),
                    onPressed: () => setState(() => _allTypes = true),
                  ),
              ],
            ),
          ),
          section(
            t.colorLabel,
            Wrap(
              spacing: Space.s2,
              runSpacing: Space.s2,
              children: [
                for (final col in Palette.all)
                  Tooltip(
                    message: t.color(col),
                    child: Semantics(
                      label: t.color(col),
                      selected: col == _color,
                      button: true,
                      child: InkWell(
                        key: Key('color-${col.key}'),
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _color = col),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorOf(col),
                            shape: BoxShape.circle,
                            border: Border.all(color: col == _color ? c.nile : c.line, width: col == _color ? 3 : 1),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Space.s2),
            child: Text(t.color(_color), style: text.bodyMedium),
          ),
          if (!_styleFree)
            section(
              t.stylesLabel,
              chips(
                Style.values,
                _styles.contains,
                t.style,
                (v) => setState(() => _styles.contains(v) && _styles.length > 1 ? _styles.remove(v) : _styles.add(v)),
              ),
            ),
          // Most pieces are solid and worn all year; the answer is pre-filled
          // when the photo is tagged, so the question stays folded away.
          Padding(
            padding: const EdgeInsets.only(top: Space.s4),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: const Key('moreDetails'),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(t.moreDetails, style: text.titleMedium),
                children: [
                  section(
                    t.patternLabel,
                    chips(Pattern.values, (v) => v == _pattern, t.pattern, (v) => setState(() => _pattern = v)),
                  ),
                  section(
                    t.seasonLabel,
                    chips(Season.values, (v) => v == _season, t.season, (v) => setState(() => _season = v)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.s8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.s4),
          child: FilledButton(key: const Key('saveItem'), onPressed: _saving ? null : _save, child: Text(t.saveItem)),
        ),
      ),
    );
  }
}
