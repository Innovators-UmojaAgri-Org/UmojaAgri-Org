// models/transporter/route_models.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteWaypoint {
  final int stop;
  final String name;
  final String distanceKm;
  final String eta;

  const RouteWaypoint({
    required this.stop,
    required this.name,
    required this.distanceKm,
    required this.eta,
  });
}

class RouteOption {
  final String id;
  final String title;
  final String subtitle;
  final String distanceKm;
  final String duration;
  final String trafficStatus;
  final String trafficColor; // 'light' | 'moderate' | 'heavy'
  final String totalTolls;
  final String estFuelCost;
  final String roadQuality;
  final bool isAiPick;
  final bool isActive;
  final List<String> aiReasons;
  final List<RouteWaypoint> waypoints;

  const RouteOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.distanceKm,
    required this.duration,
    required this.trafficStatus,
    required this.trafficColor,
    required this.totalTolls,
    required this.estFuelCost,
    required this.roadQuality,
    this.isAiPick = false,
    this.isActive = false,
    this.aiReasons = const [],
    this.waypoints = const [],
  });
}

class WhyThisRoute {
  final IconData icon;
  final String title;
  final String description;

  const WhyThisRoute({
    required this.icon,
    required this.title,
    required this.description,
  });
}



class RouteMockData {
  static const String totalDistance = '752 km';
  static const String estTime = '11.5 hrs';

  static const List<RouteOption> routes = [
    RouteOption(
      id: 'kaduna_lagos',
      title: 'Kaduna – Lagos Route',
      subtitle: '752 km  •  11 hrs 30 min',
      distanceKm: '752',
      duration: '11 hrs 30 min',
      trafficStatus: 'Moderate',
      trafficColor: 'moderate',
      totalTolls: '₦12,500',
      estFuelCost: '₦84,500',
      roadQuality: 'Good',
      isActive: true,
      aiReasons: [],
      waypoints: [],
    ),
    RouteOption(
      id: 'alternative_abuja',
      title: 'Alternative Route via Abuja',
      subtitle: '700 km  •  09 hrs 45 min',
      distanceKm: '812',
      duration: '12 hrs 45 min',
      trafficStatus: 'Light',
      trafficColor: 'light',
      totalTolls: '₦9,300',
      estFuelCost: '₦84,500',
      roadQuality: 'Good',
      isAiPick: true,
      aiReasons: [
        'Light traffic conditions throughout the route',
        'Better road quality via Abuja expressway',
        'Lower fuel consumption on highway sections',
        'Fewer toll gates compared to direct route',
      ],
      waypoints: [
        RouteWaypoint(stop: 1, name: 'Kaduna (Start)', distanceKm: '0 km', eta: '0 min'),
        RouteWaypoint(stop: 2, name: 'Zaria', distanceKm: '82 km', eta: '1 hr 15 min'),
        RouteWaypoint(stop: 3, name: 'Abuja', distanceKm: '205 km', eta: '4 hrs 30 min'),
        RouteWaypoint(stop: 4, name: 'Lokoja', distanceKm: '409 km', eta: '7 hrs 45 min'),
        RouteWaypoint(stop: 5, name: 'Ibadan', distanceKm: '640 km', eta: '10 hrs 20 min'),
        RouteWaypoint(stop: 6, name: 'Lagos (End)', distanceKm: '812 km', eta: '12 hrs 45 min'),
      ],
    ),
  ];

  static const List<RouteOption> aiRecommendationRoutes = [
    RouteOption(
      id: 'current_route',
      title: 'Current Route',
      subtitle: '2hrs 45min  •  485 km',
      distanceKm: '485',
      duration: '2 hrs 45 min',
      trafficStatus: 'Heavy Traffic',
      trafficColor: 'heavy',
      totalTolls: '₦15,200',
      estFuelCost: '₦84,500',
      roadQuality: 'Moderate',
      aiReasons: [
        'Via A2 Express – Major delay at Abuja checkpoint',
        'Abuja Checkpoint: 45min delay due to inspection',
      ],
    ),
    RouteOption(
      id: 'ai_recommended',
      title: 'AI-Recommended Route',
      subtitle: '2hrs  •  452 km',
      distanceKm: '452',
      duration: '2 hrs',
      trafficStatus: 'Clear Traffic',
      trafficColor: 'light',
      totalTolls: '₦9,300',
      estFuelCost: '₦79,000',
      roadQuality: 'Good',
      isAiPick: true,
      aiReasons: ['Via A1 & R5 Route – Smooth highway conditions'],
    ),
  ];

  static const List<WhyThisRoute> whyThisRoute = [
    WhyThisRoute(
      icon: Icons.thermostat_outlined,
      title: 'Temperature Control',
      description: 'Reduced travel time helps maintain optimal temperature',
    ),
    WhyThisRoute(
      icon: Icons.eco_outlined,
      title: 'Freshness Window Extended by 12 Hours',
      description: 'Preserve market value and reduce post-harvest losses by ₦65,000',
    ),
    WhyThisRoute(
      icon: Icons.local_gas_station_outlined,
      title: 'Fuel Efficiency',
      description: 'Save ₦5,500 on fuel costs with optimized routing',
    ),
  ];
}