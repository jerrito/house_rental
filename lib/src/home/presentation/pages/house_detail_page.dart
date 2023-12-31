import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_rental/core/size/sizes.dart';
import 'package:house_rental/core/spacing/whitspacing.dart';
import 'package:house_rental/core/theme/app_theme.dart';
import 'package:house_rental/core/theme/colors.dart';
import 'package:house_rental/src/authentication/presentation/widgets/default_button.dart';
import 'package:house_rental/src/home/presentation/widgets/gallery_row.dart';
import 'package:house_rental/src/home/presentation/widgets/house_detail_container.dart';
import 'package:house_rental/src/home/presentation/widgets/owner_row_detail.dart';
import 'package:go_router/go_router.dart';

class HouseDetailPage extends StatefulWidget {
  const HouseDetailPage({super.key});

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes().width(context, 0.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space().height(context, 0.05),
                HouseDetailContainer(
                  arrowBackOnTap: () {
                    context.pop();
                  },
                  favouriteOnTap: null,
                ),
                Space().height(context, 0.020),
                Text(
                  "Description",
                  style: appTheme.textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w500, color: houseBlack100),
                ),
                Space().height(context, 0.020),
                Text(
                  "The 3 level house that has a modern design, has a large pool and a garage that fits up to four cars... Show More",
                  style: appTheme.textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: searchTextColor1,
                      fontSize: 12),
                ),
                Space().height(context, 0.024),
                const OwnerRowDetails(),
                Space().height(context, 0.022),
                Text(
                  "Gallery",
                  style: appTheme.textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w500, color: houseBlack100),
                ),
                Space().height(context, 0.018),
                const GalleryRow(),
                Space().height(context, 0.022),
                Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        color: searchTextColor1,
                        borderRadius: BorderRadius.circular(10)),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    )),
                Space().height(context, 0.004),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("RSP 250,000.00 / Year",
                        style: appTheme.textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: houseBlack100,
                        )),
                    const SizedBox(
                      width: 120,
                      height: 50,
                      child: DefaultButton(
                        label: "Rent Now",
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.2, 0.085749655962),
    zoom: 14.4746,
  );
}
