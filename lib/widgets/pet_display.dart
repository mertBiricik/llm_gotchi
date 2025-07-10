import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';

class PetDisplay extends StatelessWidget {
  final Pet pet;

  const PetDisplay({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pet Face
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getBackgroundColor().withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                pet.faceEmoji,
                style: const TextStyle(fontSize: 60),
              )
                  .animate(
                    effects: pet.isDead
                        ? []
                        : [
                            const ScaleEffect(
                              duration: Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              begin: Offset(0.95, 0.95),
                              end: Offset(1.05, 1.05),
                            ),
                          ],
                  )
                  .then()
                  .animate(
                    effects: pet.isDead
                        ? []
                        : [
                            const ScaleEffect(
                              duration: Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              begin: Offset(1.05, 1.05),
                              end: Offset(0.95, 0.95),
                            ),
                          ],
                  ),
            ),
          ),
          const SizedBox(height: 15),

          // Pet Name
          Text(
            pet.name,
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 5),

          // Pet Stage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStageColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: _getStageColor(), width: 1),
            ),
            child: Text(
              _getStageText(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getStageColor(),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Pet Status
          Text(
            pet.statusText,
            style: TextStyle(
              fontSize: 16,
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),

          // Age Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cake,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 5),
              Text(
                '${pet.age} day${pet.age == 1 ? '' : 's'} old',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (pet.isDead) return Colors.grey.shade300;
    if (pet.isSleeping) return Colors.blue.shade100;
    
    switch (pet.mood) {
      case PetMood.happy:
        return Colors.yellow.shade100;
      case PetMood.sad:
        return Colors.blue.shade100;
      case PetMood.sick:
        return Colors.red.shade100;
      case PetMood.neutral:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStageColor() {
    switch (pet.stage) {
      case PetStage.egg:
        return Colors.orange;
      case PetStage.baby:
        return Colors.pink;
      case PetStage.child:
        return Colors.blue;
      case PetStage.adult:
        return Colors.purple;
    }
  }

  String _getStageText() {
    switch (pet.stage) {
      case PetStage.egg:
        return 'Egg Stage';
      case PetStage.baby:
        return 'Baby Stage';
      case PetStage.child:
        return 'Child Stage';
      case PetStage.adult:
        return 'Adult Stage';
    }
  }

  Color _getStatusColor() {
    if (pet.isDead) return Colors.red;
    if (pet.isSleeping) return Colors.blue;
    
    switch (pet.mood) {
      case PetMood.happy:
        return Colors.green;
      case PetMood.sad:
        return Colors.orange;
      case PetMood.sick:
        return Colors.red;
      case PetMood.neutral:
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
} 