import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  
  int _currentPage = 0;
  final int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Progress Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / _totalPages,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_currentPage + 1}/$_totalPages',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildInteractivePetPage(),
                    _buildChallengesPage(),
                    _buildInsightsPage(),
                    _buildGetStartedPage(),
                  ],
                ),
              ),

              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousPage,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF667eea),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == _totalPages - 1 ? 'Get Started!' : 'Next',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_floatingAnimation.value),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '💖',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Welcome to',
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              color: Colors.white.withOpacity(0.9),
            ),
          ).animate()
            .fadeIn(delay: 500.ms, duration: 800.ms)
            .slideY(begin: 0.3, duration: 800.ms),
          
          Text(
            'TenderTouch',
            style: GoogleFonts.comicNeue(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate()
            .fadeIn(delay: 700.ms, duration: 800.ms)
            .slideY(begin: 0.3, duration: 800.ms),
          
          const SizedBox(height: 16),
          
          Text(
            'Gentle Care, Shared Love',
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate()
            .fadeIn(delay: 900.ms, duration: 800.ms)
            .slideY(begin: 0.3, duration: 800.ms),
          
          const SizedBox(height: 32),
          
          Text(
            'A virtual pet experience designed\nfor couples to grow closer together',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate()
            .fadeIn(delay: 1100.ms, duration: 800.ms)
            .slideY(begin: 0.3, duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildInteractivePetPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '🐾',
                  style: TextStyle(fontSize: 64),
                ).animate()
                  .scale(duration: 1000.ms, curve: Curves.bounceOut)
                  .then()
                  .shake(duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Interactive Pet Care',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  '• Tap your pet for loving interactions\n'
                  '• Watch breathing animations and particle effects\n'
                  '• Customize your pet\'s name and appearance\n'
                  '• Track health, happiness, hunger, and energy\n'
                  '• Get real-time care recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 32))
                        .animate(delay: 0.ms)
                        .fadeIn(duration: 500.ms)
                        .scale(),
                    const SizedBox(width: 8),
                    const Text('💌', style: TextStyle(fontSize: 32))
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 500.ms)
                        .scale(),
                    const SizedBox(width: 8),
                    const Text('🧠', style: TextStyle(fontSize: 32))
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 500.ms)
                        .scale(),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Daily Challenges',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  '• Complete daily challenges together\n'
                  '• Earn XP and happiness rewards\n'
                  '• Care, bonding, memory, and achievement tasks\n'
                  '• Progress tracking with beautiful animations\n'
                  '• New challenges refresh every 24 hours',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Icon(Icons.analytics, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Icon(Icons.insights, color: Colors.white, size: 20),
                    ],
                  ),
                ).animate()
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5)),
                
                const SizedBox(height: 16),
                
                Text(
                  'Smart Insights',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  '• Advanced stats with trend analysis\n'
                  '• Personalized care recommendations\n'
                  '• Overall health indicators\n'
                  '• Visual progress bars with animations\n'
                  '• Relationship insights and tips',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '🚀',
                  style: TextStyle(fontSize: 64),
                ).animate()
                  .scale(duration: 1000.ms, curve: Curves.elasticOut),
                
                const SizedBox(height: 24),
                
                Text(
                  'Ready to Begin!',
                  style: GoogleFonts.comicNeue(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Your virtual pet is waiting for you!\n\n'
                  'Start by feeding, cleaning, and playing with your pet. '
                  'Complete daily challenges together and watch your '
                  'relationship blossom through shared care.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '💡 Quick Tip',
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the daily tip button on the home screen for helpful care advice!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 