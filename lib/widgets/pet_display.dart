import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';
import '../theme/retro_theme.dart';

class PetDisplay extends StatefulWidget {
  final Pet pet;
  final VoidCallback? onPetTap;
  final VoidCallback? onPetCustomize;

  const PetDisplay({
    super.key,
    required this.pet,
    this.onPetTap,
    this.onPetCustomize,
  });

  @override
  State<PetDisplay> createState() => _PetDisplayState();
}

class _PetDisplayState extends State<PetDisplay>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _particleController;
  late AnimationController _tapController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _tapAnimation;
  
  final List<Particle> _particles = [];
  final Random _random = Random();
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    
    // Breathing animation for alive pets
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // Particle animation for happy pets
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Tap animation
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
    _generateParticles();
  }

  void _startAnimations() {
    if (!widget.pet.isDead) {
      _breathingController.repeat(reverse: true);
    }
    
    if (widget.pet.mood == PetMood.happy) {
      _particleController.repeat();
    }
  }

  void _generateParticles() {
    _particles.clear();
    if (widget.pet.mood == PetMood.happy && !widget.pet.isDead) {
      for (int i = 0; i < 8; i++) {
        _particles.add(Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 4 + 2,
          speed: _random.nextDouble() * 0.02 + 0.01,
          opacity: _random.nextDouble() * 0.6 + 0.4,
        ));
      }
    }
  }

  @override
  void didUpdateWidget(PetDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pet.mood != widget.pet.mood || 
        oldWidget.pet.isDead != widget.pet.isDead) {
      _startAnimations();
      _generateParticles();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _particleController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onPetTapped() {
    HapticFeedback.lightImpact();
    _tapController.forward().then((_) => _tapController.reverse());
    
    setState(() {
      _showHeart = true;
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
    
    widget.onPetTap?.call();
  }

  String _getMoodText() {
    if (widget.pet.isDead) return 'SYSTEM OFFLINE';
    
    switch (widget.pet.mood) {
      case PetMood.happy:
        return 'FEELING GREAT!';
      case PetMood.sad:
        return 'FEELING SAD';
      case PetMood.neutral:
        return 'SYSTEM NORMAL';
      case PetMood.sick:
        return 'DIAGNOSTIC REQUIRED';
      case PetMood.sleeping:
        return 'SLEEP MODE';
      case PetMood.dead:
        return 'SYSTEM OFFLINE';
      default:
        return 'STATUS UNKNOWN';
    }
  }

  Color _getMoodColor() {
    if (widget.pet.isDead) return Colors.red;
    
    switch (widget.pet.mood) {
      case PetMood.happy:
        return RetroTheme.primaryGreen;
      case PetMood.sad:
        return RetroTheme.energyColor;
      case PetMood.neutral:
        return RetroTheme.terminalAmber;
      case PetMood.sick:
        return RetroTheme.healthColor;
      case PetMood.sleeping:
        return RetroTheme.energyColor;
      case PetMood.dead:
        return Colors.red;
      default:
        return RetroTheme.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: _getMoodColor(),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Pet Container with interactions
          GestureDetector(
            onTap: _onPetTapped,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF003366), // Dark blue background like in image
                border: Border.all(color: _getMoodColor(), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pet sprite with enhanced animations
                  AnimatedBuilder(
                    animation: Listenable.merge([_breathingAnimation, _tapAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _breathingAnimation.value * _tapAnimation.value,
                        child: Text(
                          '🐣', // Simple emoji pet for now
                          style: const TextStyle(fontSize: 32),
                        ),
                      );
                    },
                  ),

                  // Heart effect when tapped
                  if (_showHeart)
                    const Positioned(
                      top: 10,
                      right: 20,
                      child: Text(
                        '❤️',
                        style: TextStyle(fontSize: 16),
                      ),
                    ).animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.5, 0.5))
                      .moveY(begin: 0, end: -20, duration: 1000.ms)
                      .fadeOut(delay: 1000.ms),

                  // Particle effects for happy mood
                  if (widget.pet.mood == PetMood.happy && !widget.pet.isDead)
                    AnimatedBuilder(
                      animation: _particleAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(double.infinity, 80),
                          painter: ParticlePainter(
                            particles: _particles,
                            animationValue: _particleAnimation.value,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Pet status text
          Text(
            _getMoodText(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getMoodColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Particle class for animation effects
class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

// Custom painter for particle effects
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed;
      if (particle.y < 0) {
        particle.y = 1.0;
        particle.x = Random().nextDouble();
      }

      // Draw particle
      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint..color = Colors.yellow.withValues(alpha: particle.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 