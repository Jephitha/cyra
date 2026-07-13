import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/journal/providers/journal_providers.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  final String entryId;

  const JournalEntryScreen({super.key, required this.entryId});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  int _moodRating = 0;
  List<String> _photoPaths = [];
  List<String> _voiceNotePaths = [];
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  AudioPlayer? _audioPlayer;

  bool _isAudioPlaying = false;
  double _playbackProgress = 0.0;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _selectedDate = DateTime.now();
    _loadEntry();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _recorder.dispose();
    _audioPlayer?.dispose();
    _playbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadEntry() async {
    final entry = await ref.read(journalRepositoryProvider).getEntry(widget.entryId);
    if (entry == null || !mounted) return;

    setState(() {
      _titleController.text = entry.title ?? '';
      _contentController.text = entry.content ?? '';
      _selectedDate = entry.date;
      _moodRating = entry.moodRating;
      _photoPaths = List.from(entry.photoPaths);
      _voiceNotePaths = List.from(entry.voiceNotePaths);
    });

    _titleController.addListener(_onFieldChanged);
    _contentController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _handlePopInvoked(bool didPop) async {
    if (didPop) return;
    if (_hasUnsavedChanges) {
      await _saveEntry();
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _saveEntry() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final current = await ref
          .read(journalRepositoryProvider)
          .getEntry(widget.entryId);
      if (current == null) return;

      final updated = current.copyWith(
        title: _titleController.text.isNotEmpty ? _titleController.text : null,
        content:
            _contentController.text.isNotEmpty ? _contentController.text : null,
        date: _selectedDate,
        moodRating: _moodRating,
        photoPaths: List.from(_photoPaths),
        voiceNotePaths: List.from(_voiceNotePaths),
      );

      await ref.read(journalWriterProvider.notifier).updateEntry(updated);
      setState(() => _hasUnsavedChanges = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteEntry() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this journal entry? Photos and voice notes will also be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(journalWriterProvider.notifier).deleteEntry(widget.entryId);
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Photo'),
        content: const Text('Choose a source for the photo.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.camera),
              child: const Text('Camera')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
              child: const Text('Gallery')),
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
        ],
      ),
    );

    if (source == null || !mounted) return;

    try {
      final xfile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xfile == null || !mounted) return;

      final encryptedPath = await ref
          .read(journalRepositoryProvider)
          .savePhotoFile(xfile.path);

      setState(() {
        _photoPaths.add(encryptedPath);
        _hasUnsavedChanges = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo added and encrypted.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add photo: $e')),
        );
      }
    }
  }

  Future<void> _viewPhoto(String encryptedPath) async {
    try {
      final file = await ref
          .read(journalRepositoryProvider)
          .getDecryptedPhoto(encryptedPath);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            backgroundColor: AppColors.shadow,
            appBar: AppBar(
              backgroundColor: AppColors.shadow,
              foregroundColor: AppColors.onBrand,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      _photoPaths.remove(encryptedPath);
                      _hasUnsavedChanges = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Center(
              child: InteractiveViewer(
                child: Image.file(file, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load photo')),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/temp_voice/${DateTime.now().millisecondsSinceEpoch}.m4a';
      final parent = Directory(path).parent;
      if (!await parent.exists()) await parent.create(recursive: true);

      await _recorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path == null) return;

      final encryptedPath = await ref
          .read(journalRepositoryProvider)
          .saveVoiceNoteFile(path);

      final tempFile = File(path);
      if (await tempFile.exists()) await tempFile.delete();

      setState(() {
        _isRecording = false;
        _voiceNotePaths.add(encryptedPath);
        _hasUnsavedChanges = true;
      });
    } catch (e) {
      setState(() => _isRecording = false);
    }
  }

  Future<void> _playVoiceNote(String encryptedPath) async {
    try {
      if (_isAudioPlaying) {
        _audioPlayer?.pause();
        _playbackTimer?.cancel();
        setState(() => _isAudioPlaying = false);
        return;
      }

      await ref
          .read(journalRepositoryProvider)
          .getDecryptedVoiceNote(encryptedPath);

      setState(() {
        _isAudioPlaying = true;
        _playbackProgress = 0.0;
      });

      _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        setState(() {
          _playbackProgress += 0.01;
          if (_playbackProgress >= 1.0) {
            _playbackProgress = 1.0;
            t.cancel();
            _isAudioPlaying = false;
          }
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to play voice note')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _handlePopInvoked(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('MMM d, yyyy').format(_selectedDate)),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteEntry,
              tooltip: 'Delete',
            ),
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              onPressed: _isSaving ? null : _saveEntry,
              tooltip: 'Save',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
          children: [
            _buildDatePicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTitleField(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildContentField(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildMoodSelector(context),
            const SizedBox(height: AppSpacing.lg),
            _buildPhotoSection(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildVoiceNoteSection(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            _hasUnsavedChanges = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                  ),
            ),
            const Spacer(),
            const Icon(Icons.edit_rounded,
                size: 16, color: AppColors.slate),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context, bool isDark) {
    return TextField(
      controller: _titleController,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
      decoration: const InputDecoration(
        hintText: 'Title (optional)',
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildContentField(BuildContext context, bool isDark) {
    return TextField(
      controller: _contentController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
      decoration: const InputDecoration(
        hintText: 'How are you feeling?',
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMoodSelector(BuildContext context) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = _moodRating == rating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _moodRating =
                        _moodRating == rating ? 0 : rating;
                    _hasUnsavedChanges = true;
                  });
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected || _moodRating == 0 ? 1.0 : 0.4,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _moodColor(rating).withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: _moodColor(rating), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        _moodEmoji(rating),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_rounded,
                size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text('Photos',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const Spacer(),
            TextButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Photo'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_photoPaths.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Center(
              child: Text('No photos attached',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.slate)),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _photoPaths.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _viewPhoto(_photoPaths[index]),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                        child: Image.file(
                          File(_photoPaths[index]),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: isDark
                                ? AppColors.charcoal
                                : AppColors.borderLight,
                            child: const Icon(Icons.broken_image_outlined,
                                color: AppColors.slate),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _photoPaths.removeAt(index);
                            _hasUnsavedChanges = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.shadow.withValues(alpha: 0.54),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.onBrand,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.shadow.withValues(alpha: 0.54),
                          borderRadius:
                              BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 11,
                          color: AppColors.onBrand.withValues(alpha: 0.70),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Photos are encrypted at rest.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.slate,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Widget _buildVoiceNoteSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.mic_rounded,
                size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text('Voice Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const Spacer(),
            if (!_isRecording)
              TextButton.icon(
                onPressed: _startRecording,
                icon: const Icon(Icons.mic_rounded, size: 18),
                label: const Text('Record'),
              )
            else
              TextButton.icon(
                onPressed: _stopRecording,
                icon: const Icon(Icons.stop_rounded,
                    size: 18, color: AppColors.error),
                label: Text('Stop',
                    style: TextStyle(color: AppColors.error)),
              ),
          ],
        ),
        if (_isRecording) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Recording...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.error)),
                const Spacer(),
                const _RecordingWaveform(),
              ],
            ),
          ),
        ],
        if (_voiceNotePaths.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ..._voiceNotePaths.asMap().entries.map((entry) {
            final idx = entry.key;
            final path = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isAudioPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.forestGreen,
                    ),
                    onPressed: () => _playVoiceNote(path),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Voice note ${idx + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        if (_isAudioPlaying)
                          LinearProgressIndicator(
                            value: _playbackProgress,
                            color: AppColors.forestGreen,
                            backgroundColor: AppColors.forestGreen
                                .withValues(alpha: 0.15),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.slate),
                    onPressed: () {
                      setState(() {
                        _voiceNotePaths.removeAt(idx);
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        ],
        Text(
          'Voice notes are encrypted at rest.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.slate,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  String _moodEmoji(int rating) {
    switch (rating) {
      case 1:
        return '\u{1F622}';
      case 2:
        return '\u{1F641}';
      case 3:
        return '\u{1F610}';
      case 4:
        return '\u{1F642}';
      case 5:
        return '\u{1F601}';
      default:
        return '';
    }
  }

  Color _moodColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.period;
      case 3:
        return AppColors.softGold;
      case 4:
        return AppColors.sage;
      case 5:
        return AppColors.forestGreen;
      default:
        return AppColors.slate;
    }
  }
}

class AudioPlayer {
  void pause() {}
  Future<void> dispose() async {}
}

class _RecordingWaveform extends StatefulWidget {
  const _RecordingWaveform();

  @override
  State<_RecordingWaveform> createState() => _RecordingWaveformState();
}

class _RecordingWaveformState extends State<_RecordingWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: 60,
          height: 24,
          child: CustomPaint(
            painter: _WaveformPainter(progress: _controller.value),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;

  _WaveformPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final barCount = 6;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = barWidth * i + barWidth / 2;
      final amplitude = (i.isEven ? 0.3 : 0.7) +
          (progress * (i.isEven ? 0.5 : 0.2));
      final height = (size.height * 0.8) * amplitude;
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
