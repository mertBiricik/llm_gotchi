import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: _getBackgroundColor(),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          // Pet Container with interactions
          GestureDetector(
            onTap: _onPetTapped,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated background square
                AnimatedBuilder(
                  animation: _breathingAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: _getBackgroundColor(),
                        borderRadius: BorderRadius.zero,
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),

                // Particle effects for happy mood
                if (widget.pet.mood == PetMood.happy && !widget.pet.isDead)
                  AnimatedBuilder(
                    animation: _particleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(140, 140),
                        painter: ParticlePainter(
                          particles: _particles,
                          animationValue: _particleAnimation.value,
                        ),
                      );
                    },
                  ),

                // Pet sprite with enhanced animations
                AnimatedBuilder(
                  animation: Listenable.merge([_breathingAnimation, _tapAnimation]),
                  builder: (context, child) {
                    final scale = widget.pet.isDead 
                        ? _tapAnimation.value 
                        : _breathingAnimation.value * _tapAnimation.value;
                    
                    return Transform.scale(
                      scale: scale,
                      child: Text(
                        _getPixelPetSprite(),
                        style: const TextStyle(
                          fontSize: 64,
                          fontFamily: 'monospace',
                          color: Color(0xFF00FF00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),

                // Floating heart on tap
                if (_showHeart)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: const Text(
                      '<3',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'monospace',
                        color: Color(0xFFFF00FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.5, 0.5))
                      .moveY(begin: 0, end: -30, duration: 1500.ms)
                      .fadeOut(delay: 1000.ms, duration: 500.ms),
                  ),

                // Customize button
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: widget.onPetCustomize,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF00),
                        borderRadius: BorderRadius.zero,
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0xFF000000), width: 2),
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Pet Info Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.pet.name.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF00),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),

          // Stage and Age Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stage Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStageColor(),
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 2,
                  ),
                ),
                child: Text(
                  _getStageText().toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Age Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFFF),
                  borderRadius: BorderRadius.zero,
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFF000000), width: 2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cake,
                      size: 14,
                      color: Color(0xFF000000),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.pet.age}D',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),

          // Enhanced Status with mood indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: _getStatusColor(),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ).animate(target: widget.pet.mood == PetMood.happy ? 1 : 0)
                  .scale(duration: const Duration(milliseconds: 1000))
                  .then()
                  .scale(duration: const Duration(milliseconds: 1000), begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2))
                  .then()
                  .scale(duration: const Duration(milliseconds: 1000), begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0)),
                
                const SizedBox(width: 8),
                
                Flexible(
                  child: Text(
                    widget.pet.statusText.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Interaction stats
          if (widget.pet.totalInteractions > 0) ...[
            const SizedBox(height: 12),
            Text(
              '${widget.pet.totalInteractions} LOVING INTERACTIONS <3',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF00FFFF),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPixelPetSprite() {
    if (widget.pet.isDead) return 'X_X';
    if (widget.pet.isSleeping) return 'z_z';
    
    switch (widget.pet.mood) {
      case PetMood.happy:
        return '^_^';
      case PetMood.sad:
        return 'T_T';
      case PetMood.sick:
        return '@_@';
      case PetMood.neutral:
        return 'o_o';
      default:
        return '-_-';
    }
  }

  Color _getBackgroundColor() {
    if (widget.pet.isDead) return const Color(0xFF555555);
    if (widget.pet.isSleeping) return const Color(0xFF0000FF);
    
    switch (widget.pet.mood) {
      case PetMood.happy:
        return const Color(0xFFFFFF00);
      case PetMood.sad:
        return const Color(0xFF0080FF);
      case PetMood.sick:
        return const Color(0xFFFF0000);
      case PetMood.neutral:
        return const Color(0xFF00FF00);
      default:
        return const Color(0xFF808080);
    }
  }

  Color _getStageColor() {
    switch (widget.pet.stage) {
      case PetStage.egg:
        return const Color(0xFFFF8000);
      case PetStage.baby:
        return const Color(0xFFFF00FF);
      case PetStage.child:
        return const Color(0xFF00FFFF);
      case PetStage.adult:
        return const Color(0xFF8000FF);
    }
  }

  String _getStageText() {
    switch (widget.pet.stage) {
      case PetStage.egg:
        return 'egg';
      case PetStage.baby:
        return 'baby';
      case PetStage.child:
        return 'child';
      case PetStage.adult:
        return 'adult';
    }
  }

  Color _getStatusColor() {
    if (widget.pet.isDead) return const Color(0xFFFF0000);
    if (widget.pet.isSleeping) return const Color(0xFF0000FF);
    
    switch (widget.pet.mood) {
      case PetMood.happy:
        return const Color(0xFF00FF00);
      case PetMood.sad:
        return const Color(0xFFFF8000);
      case PetMood.sick:
        return const Color(0xFFFF0000);
      case PetMood.neutral:
        return const Color(0xFF00FFFF);
      default:
        return const Color(0xFF808080);
    }
  }
}

// Particle class for happiness effects
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
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed;
      if (particle.y < 0) {
        particle.y = 1.0;
        particle.x = Random().nextDouble();
      }
      
      // Draw particle
      paint.color = const Color(0xFFFFFF00).withOpacity(particle.opacity * 0.6);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(
            particle.x * size.width,
            particle.y * size.height,
          ),
          width: particle.size * 2,
          height: particle.size * 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
} 