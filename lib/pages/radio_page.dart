import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes for better streaming experience
    switch (state) {
      case AppLifecycleState.paused:
        // Keep playing in background
        break;
      case AppLifecycleState.resumed:
        // Resume if was playing
        if (_isPlaying && !_audioPlayer.playing) {
          _reconnectStream();
        }
        break;
      case AppLifecycleState.detached:
        _audioPlayer.stop();
        break;
      default:
        break;
    }
  }

  void _initializeAudioPlayer() {
    // Configure audio player for streaming
    _audioPlayer.setCanUseNetworkResourcesForLiveStreamingWhilePaused(true);

    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });

        // Handle connection errors and auto-reconnect
        if (state.processingState == ProcessingState.idle && _isPlaying) {
          _reconnectStream();
        }
      }
    });

    // Listen for errors and handle reconnection
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        if (mounted) {
          _handleStreamError(e);
        }
      },
    );
  }

  Future<void> _reconnectStream() async {
    if (!mounted) return;

    try {
      await _audioPlayer.setUrl(
        'https://media2.streambrothers.com:2020/stream/8212',
        preload: false,
      );
      await _audioPlayer.play();
    } catch (e) {
      _handleStreamError(e);
    }
  }

  void _handleStreamError(Object error) {
    if (!mounted) return;

    setState(() {
      _isPlaying = false;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Stream interrupted. Tap play to reconnect.'),
        backgroundColor: const Color(0xFFb00309),
        action: SnackBarAction(
          label: 'Reconnect',
          textColor: Colors.white,
          onPressed: () => _togglePlayback(),
        ),
      ),
    );
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        // Enhanced connection with timeout and retry logic
        await _audioPlayer
            .setUrl(
          'https://media2.streambrothers.com:2020/stream/8212',
          preload: false,
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                'Connection timeout', const Duration(seconds: 10));
          },
        );

        await _audioPlayer.play();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.radio, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Connected to Weru Radio Live!'),
                ],
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Failed to connect. Check your internet connection.',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
              backgroundColor: const Color(0xFFb00309),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _togglePlayback(),
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildRadioSchedule() {
    final programs = [
      {
        'name': 'TUTHARIMWE',
        'focus': 'Spiritual Growth',
        'schedule': 'Daily, 4:00 AM – 6:00 AM',
        'host': 'Makena Wa Matiri',
        'description':
            'Devotional program featuring prayers, scripture, sermons, and worship music to start the day with faith.',
        'icon': Icons.church,
      },
      {
        'name': 'CHANCHAMUKA',
        'focus': 'News & Current Affairs',
        'schedule': 'Weekdays, 7:00 AM – 10:00 AM',
        'host': 'Karimi Kaunty & Martin Gichunge',
        'description':
            'Morning rundown of regional/national news, with a TV/radio crossover segment (8:00 AM – 9:00 AM).',
        'icon': Icons.radio,
      },
      {
        'name': 'TUTHUNKUME',
        'focus': 'Business & Finance',
        'schedule': 'Time Pending',
        'host': 'Munene Wa Kagwi',
        'description':
            'Actionable financial insights, listener engagement, and celebratory segments (e.g., birthday surprises).',
        'icon': Icons.business_center,
      },
      {
        'name': 'TUBURUKE NA TASH',
        'focus': 'Music & Pop Culture',
        'schedule': 'Weekdays, 2:00 PM – 6:00 PM',
        'host': 'MC Tash',
        'description':
            'High-energy mix of new-generation music, trends, and discussions on politics, fashion, and relationships.',
        'icon': Icons.music_note,
      },
      {
        'name': 'NYONTOKA',
        'focus': 'News & Entertainment',
        'schedule': 'Time Pending',
        'host': 'Mwenda H The Pilot',
        'description':
            'Post-work recap of news, social media trends, and curated music (classic to contemporary).',
        'icon': Icons.mic,
      },
      {
        'name': 'REGGAEMANIA',
        'focus': 'Reggae/Dancehall & Social Commentary',
        'schedule': 'Daily, 7:00 PM – 10:00 PM',
        'host': 'Captain Goddie & DJ Tush Untamed',
        'description':
            'Music blended with discussions on politics and social issues.',
        'icon': Icons.queue_music,
      },
      {
        'name': 'MANTU KIMENCHU',
        'focus': 'Relationships & Sensitive Topics',
        'schedule': '10:00 PM – 1:00 AM',
        'host': 'Koome Kinyua',
        'description':
            'Candid conversations for mature audiences, addressing intimacy and adult life.',
        'icon': Icons.favorite,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: programs.map((program) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFb00309).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFb00309).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  program['icon'] as IconData,
                  color: const Color(0xFFb00309),
                  size: 24,
                ),
              ),
              title: Text(
                program['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFb00309),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program['focus'] as String,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFb00309).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      program['schedule'] as String,
                      style: const TextStyle(
                        color: Color(0xFFb00309),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFFb00309),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Host: ${program['host']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFb00309),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        program['description'] as String,
                        style: TextStyle(
                          color: Colors.grey[700],
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSocialIcons() {
    final socialLinks = [
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'url': 'https://www.facebook.com/WeruFM96.4',
        'color': const Color(0xFF1877F2),
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_video,
        'url': 'https://www.tiktok.com/@werutv.fm96.4',
        'color': Colors.black,
      },
      {
        'name': 'X',
        'icon': Icons.alternate_email,
        'url': 'https://x.com/WeruTV',
        'color': Colors.black,
      },
      {
        'name': 'YouTube',
        'icon': Icons.play_circle_fill,
        'url': 'https://www.youtube.com/@werutvfm3411',
        'color': const Color(0xFFFF0000),
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFfda609),
            const Color(0xFFfda609).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFfda609).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'FOLLOW US',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Stay connected with Weru Digital on social media',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: socialLinks.map((social) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _launchSocialUrl(social['url'] as String),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: social['color'] as Color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (social['color'] as Color)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                social['icon'] as IconData,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              social['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchSocialUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      // Try different launch modes to ensure compatibility
      bool launched = false;

      // First try with external application mode
      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print('External app launch failed: $e');
      }

      // If that fails, try with platform default
      if (!launched) {
        try {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );
        } catch (e) {
          print('Platform default launch failed: $e');
        }
      }

      // If that fails, try with in-app web view
      if (!launched) {
        try {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } catch (e) {
          print('In-app web view launch failed: $e');
        }
      }

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Unable to open $url. Please check if you have the app installed.'),
            backgroundColor: const Color(0xFFb00309),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFb00309),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Weru Radio'),
            if (_isPlaying) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: const Color(0xFFb00309),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFb00309),
                        const Color(0xFFb00309).withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/radio_logo.png',
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 160,
                              width: 160,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.radio,
                                size: 80,
                                color: Color(0xFFb00309),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.9),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _togglePlayback,
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _isLoading
                                          ? Colors.orange
                                          : const Color(0xFFb00309),
                                      shape: BoxShape.circle,
                                      boxShadow: _isPlaying
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFb00309)
                                                    .withOpacity(0.4),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Icon(
                                            _isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _isLoading
                                        ? 'CONNECTING...'
                                        : _isPlaying
                                            ? 'PAUSE LIVE RADIO'
                                            : 'PLAY LIVE RADIO',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _isLoading
                                          ? Colors.orange.shade700
                                          : const Color(0xFFb00309),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFb00309),
                        const Color(0xFFb00309).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFb00309).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.schedule,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'RADIO PROGRAMMING',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Empowering, Educating, and Entertaining Our Audience',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildRadioSchedule(),
                const SizedBox(height: 32),
                _buildSocialIcons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Floating Live Indicator
          if (_isPlaying)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
