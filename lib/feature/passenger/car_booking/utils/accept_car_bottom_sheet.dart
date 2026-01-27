import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/widgets/custom_button.dart';
import 'package:ride_sharing/widgets/logo.dart';
import 'package:ride_sharing/services/socket_services.dart';

import 'booking_car_bottomsheet.dart';

// Model for car information from driver
class CarInformation {
  final String id;
  final String brand;
  final String model;
  final String yearOfManufacture;
  final String? licensePlateNumber;
  final String? licensePlatePicture;

  CarInformation({
    required this.id,
    required this.brand,
    required this.model,
    required this.yearOfManufacture,
    this.licensePlateNumber,
    this.licensePlatePicture,
  });

  factory CarInformation.fromJson(Map<String, dynamic> json) {
    final licensePlate = json['licensePlate'] as Map<String, dynamic>?;

    return CarInformation(
      id: json['_id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      yearOfManufacture: json['yearOfManufacture'] ?? '',
      licensePlateNumber: licensePlate?['number'],
      licensePlatePicture: licensePlate?['picture'],
    );
  }
}

class NearbyDriver {
  final String id;
  final String name;
  final String email;
  final String locationName;
  final double distance;
  final List<double> coordinates;
  final String? profilePicture;
  final double rating;
  final int totalReviews;
  final CarInformation? carInformation;
  String? bidAmount; // Dynamic bid amount from driver

  NearbyDriver({
    required this.id,
    required this.name,
    this.email = '',
    this.locationName = '',
    this.distance = 0.0,
    this.coordinates = const [0.0, 0.0],
    this.profilePicture,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.carInformation,
    this.bidAmount,
  });

  factory NearbyDriver.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coords = location?['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
    final carInfo = json['carInformation'] as Map<String, dynamic>?;

    return NearbyDriver(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      locationName: json['locationName'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      coordinates: coords.map((e) => (e as num).toDouble()).toList(),
      profilePicture: json['profilePicture'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      carInformation: carInfo != null ? CarInformation.fromJson(carInfo) : null,
    );
  }
}

// Model for bid data from socket (updated structure with driver object)
class BidData {
  final String rideId;
  final String amount;
  final String driverId;
  final String driverName;
  final String? profilePicture;
  final double rating;
  final int totalReviews;
  final CarInformation? carInformation;

  BidData({
    required this.rideId,
    required this.amount,
    required this.driverId,
    required this.driverName,
    this.profilePicture,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.carInformation,
  });

  factory BidData.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] as Map<String, dynamic>?;
    final carInfo = driver?['carInformation'] as Map<String, dynamic>?;

    return BidData(
      rideId: json['rideId'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      driverId: driver?['_id'] ?? '',
      driverName: driver?['name'] ?? '',
      profilePicture: driver?['profilePicture'],
      rating: (driver?['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (driver?['totalReviews'] as num?)?.toInt() ?? 0,
      carInformation: carInfo != null ? CarInformation.fromJson(carInfo) : null,
    );
  }
}

class AcceptCarBottomSheet extends StatefulWidget {
  final String pickUpAddress;
  final String destinationAddress;
  final String tripDistance; // Distance of the trip (e.g., "7.3" km)
  final List<dynamic>? initialDriversData;

  const AcceptCarBottomSheet({
    Key? key,
    required this.pickUpAddress,
    required this.destinationAddress,
    this.tripDistance = '',
    this.initialDriversData,
  }) : super(key: key);

  @override
  _AcceptCarBottomSheetState createState() => _AcceptCarBottomSheetState();
}

class _AcceptCarBottomSheetState extends State<AcceptCarBottomSheet> {
  List<NearbyDriver> nearbyDrivers = [];
  Map<String, String> driverBids = {}; // Map of driverId -> bidAmount
  Map<String, String> driverRideIds = {}; // Map of driverId -> rideId
  bool isLoading = true;
  bool isAccepting = false; // Loading state when accepting a bid
  String? acceptingDriverId; // Track which driver's bid is being accepted
  NearbyDriver? acceptedDriver; // Store the accepted driver's data
  String? acceptedBidAmount; // Store the accepted bid amount
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initDriversData();
    _initSocketAndListen();
    _initNewBidListener();
    _initRideAcceptedListener();
  }

  void _initDriversData() {
    // If initial data is provided, use it immediately
    if (widget.initialDriversData != null && widget.initialDriversData!.isNotEmpty) {
      _logger.i('Using initial drivers data: ${widget.initialDriversData!.length} drivers');
      nearbyDrivers = widget.initialDriversData!
          .map((driverJson) => NearbyDriver.fromJson(driverJson as Map<String, dynamic>))
          .toList();
      isLoading = false;
      _logger.i('Initialized with ${nearbyDrivers.length} drivers');
    }
  }

  Future<void> _initSocketAndListen() async {
    final socketService = SocketIoService.to;

    _logger.i('Current socket status - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');

    // Ensure socket is connected
    if (!socketService.isConnected.value) {
      _logger.i('Socket not connected, connecting...');
      await socketService.connect();

      // Wait a bit for connection to establish
      await Future.delayed(const Duration(milliseconds: 500));
      _logger.i('After connect - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');
    }

    _logger.i('Setting up listener for nearest-drivers event (for future updates)');

    // Use the dedicated method for nearest-drivers (for future updates)
    socketService.onNearestDrivers((data) {
      _logger.i('Received nearest-drivers event in AcceptCarBottomSheet: $data');

      if (data != null) {
        List<dynamic> driversList;

        // Handle both List and other formats
        if (data is List) {
          driversList = data;
        } else if (data is Map && data['data'] is List) {
          driversList = data['data'] as List;
        } else {
          _logger.e('Unexpected data format: ${data.runtimeType}');
          return;
        }

        if (mounted) {
          setState(() {
            nearbyDrivers = driversList
                .map((driverJson) => NearbyDriver.fromJson(driverJson as Map<String, dynamic>))
                .toList();
            isLoading = false;
          });
          _logger.i('Updated drivers list: ${nearbyDrivers.length} drivers');
        }
      }
    });
  }

  Future<void> _initNewBidListener() async {
    final socketService = SocketIoService.to;

    // Ensure socket is connected before setting up listener
    if (!socketService.isConnected.value) {
      _logger.i('Socket not connected for new-bid, connecting...');
      await socketService.connect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    _logger.i('Setting up listener for new-bid event');

    // Listen for new bids from drivers
    socketService.onNewBid((data) {
      _logger.i('Received new-bid event in AcceptCarBottomSheet: $data');

      if (data != null && data is Map<String, dynamic>) {
        final bidData = BidData.fromJson(data);
        _logger.i('Parsed bid - driverId: ${bidData.driverId}, name: ${bidData.driverName}, amount: ${bidData.amount}');

        if (mounted) {
          setState(() {
            // Store the bid amount and rideId for this driver
            driverBids[bidData.driverId] = bidData.amount;
            driverRideIds[bidData.driverId] = bidData.rideId;

            // Check if driver exists in the list
            bool driverExists = false;
            for (int i = 0; i < nearbyDrivers.length; i++) {
              if (nearbyDrivers[i].id == bidData.driverId) {
                // Replace with updated driver info from bid data
                nearbyDrivers[i] = NearbyDriver(
                  id: bidData.driverId,
                  name: bidData.driverName,
                  email: nearbyDrivers[i].email,
                  locationName: nearbyDrivers[i].locationName,
                  distance: nearbyDrivers[i].distance,
                  coordinates: nearbyDrivers[i].coordinates,
                  profilePicture: bidData.profilePicture ?? nearbyDrivers[i].profilePicture,
                  rating: bidData.rating > 0 ? bidData.rating : nearbyDrivers[i].rating,
                  totalReviews: bidData.totalReviews > 0 ? bidData.totalReviews : nearbyDrivers[i].totalReviews,
                  carInformation: bidData.carInformation ?? nearbyDrivers[i].carInformation,
                  bidAmount: bidData.amount,
                );
                driverExists = true;
                break;
              }
            }

            // If driver doesn't exist, add them to the list
            if (!driverExists) {
              final newDriver = NearbyDriver(
                id: bidData.driverId,
                name: bidData.driverName,
                profilePicture: bidData.profilePicture,
                rating: bidData.rating,
                totalReviews: bidData.totalReviews,
                carInformation: bidData.carInformation,
                bidAmount: bidData.amount,
              );
              nearbyDrivers.add(newDriver);
              _logger.i('Added new driver to list: ${bidData.driverName}');
            }

            // Mark as not loading since we have at least one driver
            isLoading = false;
          });
          _logger.i('Updated bid for driver ${bidData.driverId}: \$${bidData.amount}, rideId: ${bidData.rideId}');
        }
      }
    });
  }

  Future<void> _initRideAcceptedListener() async {
    final socketService = SocketIoService.to;

    // Ensure socket is connected before setting up listener
    if (!socketService.isConnected.value) {
      _logger.i('Socket not connected for ride-accepted, connecting...');
      await socketService.connect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    _logger.i('Setting up listener for ride-accepted event');

    // Listen for ride-accepted response from server (sent after passenger accepts bid)
    socketService.onRideAccepted((data) {
      _logger.i('Received ride-accepted event in AcceptCarBottomSheet: $data');

      if (mounted && acceptedDriver != null) {
        // Close current bottom sheet and show BookingCarsBottomSheet with driver data
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return BookingCarsBottomSheet(
              rideId: driverRideIds[acceptedDriver!.id] ?? '',
              driverName: acceptedDriver!.name,
              driverProfilePicture: acceptedDriver!.profilePicture,
              driverRating: acceptedDriver!.rating,
              driverTotalReviews: acceptedDriver!.totalReviews,
              carBrand: acceptedDriver!.carInformation?.brand ?? '',
              carModel: acceptedDriver!.carInformation?.model ?? '',
              licensePlateNumber: acceptedDriver!.carInformation?.licensePlateNumber ?? '',
              licensePlatePicture: acceptedDriver!.carInformation?.licensePlatePicture,
              bidAmount: acceptedBidAmount ?? '',
              tripDistance: widget.tripDistance,
              pickUpAddress: widget.pickUpAddress,
              destinationAddress: widget.destinationAddress,
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _logger.i('Disposing AcceptCarBottomSheet, removing socket listeners');
    SocketIoService.to.offNearestDrivers();
    SocketIoService.to.offNewBid();
    SocketIoService.to.offRideAccepted();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Logo and Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LogoWidget(
                width: 40.w,
                height: 40.h,
                fontSize: 15.sp,
              ),
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.greenShade50,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 12.sp),

          // Pickup Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppImage.greetings),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  widget.pickUpAddress.isNotEmpty
                      ? widget.pickUpAddress
                      : 'Pickup location',
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Vertical line connector
          Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Container(
              height: 20.h,
              width: 2,
              color: Colors.black,
            ),
          ),

          // Destination Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.primaryColor),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  widget.destinationAddress.isNotEmpty
                      ? widget.destinationAddress
                      : 'Destination',
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Divider(
            color: AppColors.grayShade100,
            thickness: 1,
          ),

          SizedBox(height: 8.sp),

          // Drivers List
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(height: 16.sp),
                        Text(
                          'Finding nearby drivers...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.appGreyColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : nearbyDrivers.isEmpty
                    ? Center(
                        child: Text(
                          'No drivers available nearby',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.appGreyColor,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: nearbyDrivers.length,
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.grayShade100,
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          final driver = nearbyDrivers[index];
                          return _buildDriverCard(driver);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(NearbyDriver driver) {
    // Calculate filled stars based on rating (0-5)
    final int filledStars = driver.rating.round().clamp(0, 5);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Column(
        children: [
          Row(
            children: [
              // Profile image from driver data
              ClipOval(
                child: Image.network(
                  driver.profilePicture ?? 'https://picsum.photos/250?image=9',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.grayShade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.appGreyColor,
                        size: 30.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.sp),

              // Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.sp),
                    // Rating stars based on driver's actual rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < filledStars ? Colors.yellow : Colors.grey,
                            size: 14.sp,
                          );
                        }),
                        SizedBox(width: 4.sp),
                        Text(
                          '(${driver.totalReviews})',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.appGreyColor,
                          ),
                        ),
                      ],
                    ),
                    // Car info if available
                    if (driver.carInformation != null)
                      Text(
                        '${driver.carInformation!.brand} ${driver.carInformation!.model}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.appGreyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Distance and price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // Display dynamic bid amount or default '--'
                    driverBids[driver.id] != null
                        ? '\$${driverBids[driver.id]}'
                        : driver.bidAmount != null
                            ? '\$${driver.bidAmount}'
                            : '--',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: driverBids[driver.id] != null || driver.bidAmount != null
                          ? AppColors.primaryColor
                          : AppColors.darkColor,
                    ),
                  ),
                  Text(
                    '${(driver.distance / 1000).toStringAsFixed(1)} km',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.appGreyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.sp),

          // Accept button (smaller size)
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: CustomButton(
              height: 40,
              onPressed: (isAccepting && acceptingDriverId == driver.id)
                  ? null
                  : () async {
                      // Check if this driver has submitted a bid
                      final rideId = driverRideIds[driver.id];
                      if (rideId != null && rideId.isNotEmpty) {
                        _logger.i('Accepting bid - rideId: $rideId, driverId: ${driver.id}');

                        // Set loading state and store accepted driver data
                        setState(() {
                          isAccepting = true;
                          acceptingDriverId = driver.id;
                          acceptedDriver = driver;
                          acceptedBidAmount = driverBids[driver.id] ?? driver.bidAmount;
                        });

                        // Emit accept-bid socket event
                        await SocketIoService.to.emitAcceptBid(
                          rideId: rideId,
                          driverId: driver.id,
                        );

                        _logger.i('Accept-bid emitted successfully, waiting for socket response...');
                        // Navigation will happen when accept-bid event is received from socket
                      } else {
                        _logger.w('No bid found for driver ${driver.id}, cannot accept');
                      }
                    },
              title: (isAccepting && acceptingDriverId == driver.id)
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Accept',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
