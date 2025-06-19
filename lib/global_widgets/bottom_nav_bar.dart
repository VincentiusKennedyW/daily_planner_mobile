import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// 1. MODERN CURVED BOTTOM NAV
class ModernCurvedBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const ModernCurvedBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  _ModernCurvedBottomNavState createState() => _ModernCurvedBottomNavState();
}

class _ModernCurvedBottomNavState extends State<ModernCurvedBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Background Indicator
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: widget.selectedIndex *
                (MediaQuery.of(context).size.width - 40) /
                widget.items.length,
            child: Container(
              width: (MediaQuery.of(context).size.width - 40) /
                  widget.items.length,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Navigation Items
          Row(
            children: widget.items.asMap().entries.map((entry) {
              int index = entry.key;
              BottomNavItem item = entry.value;
              bool isSelected = widget.selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(index);
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            item.icon,
                            color: isSelected ? Colors.white : Colors.grey[400],
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 4),
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// 2. FLOATING BUBBLE BOTTOM NAV
class FloatingBubbleBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const FloatingBubbleBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          BottomNavItem item = entry.value;
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              onTap(index);
              HapticFeedback.mediumImpact();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 8),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 3. NEUMORPHIC BOTTOM NAV
class NeumorphicBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const NeumorphicBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F3),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          // Light shadow (top-left)
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 15,
          ),
          // Dark shadow (bottom-right)
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: Offset(5, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          BottomNavItem item = entry.value;
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              onTap(index);
              HapticFeedback.lightImpact();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F3),
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        // Inset shadow effect
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-2, -2),
                          blurRadius: 5,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(3, 3),
                          blurRadius: 8,
                        ),
                      ],
              ),
              child: Icon(
                item.icon,
                color: isSelected ? Color(0xFF6366F1) : Colors.grey[600],
                size: 24,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 4. MINIMAL DOTS BOTTOM NAV
class MinimalDotsBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const MinimalDotsBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          BottomNavItem item = entry.value;
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              onTap(index);
              HapticFeedback.selectionClick();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    item.icon,
                    color: isSelected ? Color(0xFF6366F1) : Colors.grey[500],
                    size: isSelected ? 28 : 24,
                  ),
                ),
                SizedBox(height: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isSelected ? 6 : 4,
                  height: isSelected ? 6 : 4,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
                    shape: BoxShape.circle,
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

// 5. GLASSMORPHISM BOTTOM NAV
class GlassmorphismBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const GlassmorphismBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                BottomNavItem item = entry.value;
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    onTap(index);
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 20 : 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 24,
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 8),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// Model untuk Bottom Nav Item
class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.label,
  });
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
