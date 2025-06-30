import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TvPage extends StatefulWidget {
  const TvPage({super.key});

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation requests including HTTPS
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
          onPageFinished: (String url) {
            debugPrint('TV page loaded: $url');
            // Add CORS and HTTPS headers
            _controller.runJavaScript('''
              // Set CORS headers for iframe communication
              if (window.postMessage) {
                window.addEventListener('message', function(event) {
                  // Allow cross-origin communication with OK.ru
                  if (event.origin.includes('ok.ru')) {
                    console.log('Message from OK.ru:', event.data);
                  }
                }, false);
              }
              
              // Ensure iframe can load HTTPS content
              const iframe = document.querySelector('iframe');
              if (iframe) {
                iframe.setAttribute('referrerPolicy', 'no-referrer-when-downgrade');
                iframe.setAttribute('sandbox', 'allow-scripts allow-same-origin allow-presentation allow-forms');
              }
            ''');
          },
        ),
      )
      ..enableZoom(false)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval'; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src * 'unsafe-inline'; img-src * data: blob: 'unsafe-inline'; frame-src *; style-src * 'unsafe-inline';">
    <meta http-equiv="X-Frame-Options" content="ALLOWALL">
    <title>Weru TV</title>
    <style>
        .okru-wrapper {
          position: relative;
          width: 100%;
          max-width: 100%;
          aspect-ratio: 16 / 9;
          background: #000;
          overflow: hidden;
          border-radius: 8px;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
          margin-top: 10px;
        }

        .okru-wrapper iframe {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          z-index: 1;
          border: none;
        }

        .overlay {
          position: absolute;
          z-index: 2;
          background: transparent;       /* fully transparent, no shading */
          pointer-events: all;           /* block interaction underneath */
          cursor: default;
          user-select: none;
        }

        /* 🎯 Top-left overlay (e.g., Weru Digital logo) */
        .logo-top-left {
          top: 0;
          left: 0;
          width: 15%;
          height: 12%;
        }

        /* 🔗 Top-right overlay (e.g., link icon/logo) */
        .logo-top-right {
          top: 0;
          right: 0;
          width: 8%;
          height: 12%;
        }

        /* ⬇ Bottom-right overlay (e.g., watermark) */
        .logo-bottom-right {
          bottom: 2%;
          right: 2%;
          width: 12%;
          height: 10%;
        }

        /* 📱 Mobile adjustments for very narrow screens */
        @media (max-width: 600px) {
          .logo-top-left {
            width: 18%;
            height: 14%;
          }

          .logo-top-right {
            width: 10%;
            height: 14%;
          }

          .logo-bottom-right {
            width: 15%;
            height: 12%;
          }

          .okru-wrapper {
            border-radius: 0;
          }
        }
    </style>
</head>
<body>
    <div class="okru-wrapper">
      <iframe
        src="https://ok.ru/videoembed/330582007485?nochat=1&autoplay=0"
        frameborder="0"
        allow="autoplay; fullscreen; encrypted-media; microphone; camera"
        allowfullscreen
        sandbox="allow-scripts allow-same-origin allow-presentation allow-forms"
        referrerpolicy="no-referrer-when-downgrade"
      ></iframe>

      <!-- Transparent overlays to block branding logos -->
      <div class="overlay logo-top-left" aria-hidden="true"></div>
      <div class="overlay logo-top-right" aria-hidden="true"></div>
      <div class="overlay logo-bottom-right" aria-hidden="true"></div>
    </div>
</body>
</html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Weru TV'),
        backgroundColor: const Color(0xFFb00309),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFb00309).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: WebViewWidget(controller: _controller),
                ),
              ),
            ),
            const SizedBox(
                height: 8), // Reduced gap between player and schedule
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
                          Icons.tv,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'TV PROGRAMMING',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Empowering, Educating, and Entertaining Our Audience',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Reduced gap
            _buildTvSchedule(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTvSchedule() {
    final programs = [
      {
        'name': 'URIA NDAGITARI',
        'focus': 'Healthcare',
        'schedule': 'Mondays, 6:30 PM – 7:20 PM',
        'host': 'Ntinyari Kinyua',
        'description':
            'A flagship health program offering expert analysis, Q&A sessions, and actionable advice from leading medical professionals to promote community well-being.',
        'icon': Icons.local_hospital,
      },
      {
        'name': 'GIKARO NA KAUNTY',
        'focus': 'Influencer Profiles & Inspirational Stories',
        'schedule': 'Mondays, 8:15 PM – 9:00 PM',
        'host': 'Stella Karimi Kaunty',
        'description':
            'Prime-time interviews with trendsetters and influential figures, revealing their personal journeys and untold stories.',
        'icon': Icons.star,
      },
      {
        'name': 'TUTHUNKUME',
        'focus': 'Business & Entrepreneurship',
        'schedule': 'Wednesdays, 6:30 PM – 7:20 PM',
        'host': 'Munene Wa Kagwi',
        'description':
            'On-the-ground interviews with SME leaders, showcasing real-world challenges and strategies for success in competitive markets.',
        'icon': Icons.business_center,
      },
      {
        'name': 'RIIKONE',
        'focus': 'Culinary Arts',
        'schedule': 'Day/Time Pending',
        'host': 'Professional Chef',
        'description':
            'Step-by-step cooking demonstrations, ingredient breakdowns, and culinary techniques for home cooks and food enthusiasts.',
        'icon': Icons.restaurant,
      },
      {
        'name': 'MURIMI CARURUKU',
        'focus': 'Smart Agriculture',
        'schedule': 'Day/Time Pending',
        'host': 'Koome Kinyua',
        'description':
            'Educational demonstrations of modern farming techniques, sustainable practices, and solutions to agricultural challenges.',
        'icon': Icons.agriculture,
      },
      {
        'name': 'NKATHA CIETU',
        'focus': 'Women\'s Empowerment',
        'schedule': 'Tuesdays, 8:20 PM – 8:45 PM',
        'host': 'Makena Wa Matiri',
        'description':
            'Celebrating women who\'ve overcome adversity and achieved impact, inspiring viewers through their stories.',
        'icon': Icons.female,
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
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFfda609).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      program['schedule'] as String,
                      style: const TextStyle(
                        color: Color(0xFFfda609),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
                          Text(
                            'Host: ${program['host']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFb00309),
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
}
