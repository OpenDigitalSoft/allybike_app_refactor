import 'dart:io';

import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:allybike/image-picker/domain/image_picker_cubit.dart';
import 'package:allybike/main.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:allybike/routes/domain/set-route-map/set_route_map_cubit.dart';
import 'package:allybike/type-sites/domain/type_site_cubit.dart';
import 'package:allybike/type-sites/models/type-site.repository.dart';
import 'package:allybike/widgets/appbars/appbar-home.widget.dart';
import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:allybike/widgets/formfileds/select.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

class CreateMapPointsRoutes extends StatefulWidget {
  static String route = "create-map-points";
  const CreateMapPointsRoutes({super.key});

  @override
  State<CreateMapPointsRoutes> createState() => _CreateMapPointsRoutesState();
}

class _CreateMapPointsRoutesState extends State<CreateMapPointsRoutes>
    with TickerProviderStateMixin {
  late AnimatedMapController animatedMapController;

  @override
  void initState() {
    animatedMapController = AnimatedMapController(vsync: this);
    context.read<SetRouteMapCubit>().startTrackingRoute();
    super.initState();
  }

  @override
  void dispose() {
    animatedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final idRoute = args['idRoute'] as int;
    final cubit = context.read<SetRouteMapCubit>();
    return Scaffold(
      appBar: AppBarHomePage(
        icon: Icons.add_road_outlined,
        title: "Trazar ruta",
        centerTitle: true,
      ),
      body: BlocBuilder<SetRouteMapCubit, SetRouteMapState>(
        builder: (context, state) {
          if (state is SetPositionCurrent) {
            final position = LatLng(
              state.position.latitude,
              state.position.longitude,
            );
            cubit.setIdRoute(idRoute);
            return FlutterMap(
              mapController: animatedMapController.mapController,
              options: _getMapOptions(position),
              children: [
                _LayerMap(),
                _CenterButton(onPressed: () => _centerMap(position)),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: _ListActions(state: state, cubit: cubit),
                ),
                if (state.path.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.path,
                        color: Colors.blue,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 20.0,
                      height: 20.0,
                      point: position,
                      child: _PositionMarker(),
                    ),
                    ...state.sites.map(
                      (site) => Marker(
                        width: 65.0,
                        height: 65.0,
                        alignment: Alignment.lerp(
                          Alignment.topCenter,
                          Alignment.center,
                          -0.4,
                        )!,
                        point: LatLng(site.latitude, site.longitude),
                        child: _ImageMarker(
                          imageUrl: site.photo,
                          size: 65,
                          borderColor: Colors.white,
                          borderWidth: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _centerMap(LatLng position) {
    animatedMapController.animateTo(
      dest: position,
      zoom: 16,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  _getMapOptions(LatLng position) {
    return MapOptions(initialCenter: position, initialZoom: 16);
  }
}

class _LayerMap extends StatelessWidget {
  const _LayerMap();

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate:
          "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
      subdomains: ['a', 'b', 'c'],
    );
  }
}

class _PositionMarker extends StatelessWidget {
  const _PositionMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: PaleteColors.red, width: 3),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _CenterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: PaleteColors.gray100),
        ),
        onPressed: onPressed,
        child: Icon(Icons.my_location, color: PaleteColors.red),
      ),
    );
  }
}

class _ListActions extends StatelessWidget {
  final SetPositionCurrent state;
  final SetRouteMapCubit cubit;
  const _ListActions({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return _Actions(
      actionButtons: [
        _ActionButton(
          icon: LucideIcons.flag,
          text: "Sitio",
          onPressed: () => _showModalSiteForm(context),
        ),
        _ActionButton(
          icon: LucideIcons.camera,
          text: "Fotografía",
          onPressed: () => context.read<SetRouteMapCubit>().getPhotoRoute(),
        ),
        if (!state.isPaused)
          _ActionButton(
            icon: Icons.pause,
            text: "Pausar",
            onPressed: () =>
                context.read<SetRouteMapCubit>().pauseTrackingRoute(),
          ),
        if (state.isPaused)
          _ActionButton(
            icon: Icons.play_arrow,
            text: "Reanudar",
            color: Colors.white,
            iconColor: PaleteColors.red,
            onPressed: () =>
                context.read<SetRouteMapCubit>().resumeTrackingRoute(),
          ),
        _ActionButton(
          icon: LucideIcons.flagTriangleLeft,
          text: "Finalizar",
          onPressed: () => _showModalFinish(context),
        ),
      ],
    );
  }

  _showModalSiteForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => dependencyRegister<ImagePickerCubit>()),
          ],
          child: _SiteForm(position: state.position),
        );
      },
    );
  }

  _showModalFinish(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(value: cubit, child: _FinishRoute());
      },
    );
  }
}

class _TitleModal extends StatelessWidget {
  final String title;
  const _TitleModal({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _Actions extends StatelessWidget {
  final List<_ActionButton> actionButtons;

  const _Actions({required this.actionButtons});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actionButtons
            .map(
              (button) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: button,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? iconColor;
  const _ActionButton({
    required this.icon,
    required this.text,
    this.onPressed,
    this.color = PaleteColors.red,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(color: PaleteColors.black, fontSize: 12)),
      ],
    );
  }
}

class _SiteForm extends StatefulWidget {
  final Position position;
  const _SiteForm({required this.position});

  @override
  State<_SiteForm> createState() => _SiteFormState();
}

class _SiteFormState extends State<_SiteForm> {
  final descriptionController = TextEditingController();
  final typeSiteController = TextEditingController(text: "1");
  late String imagePath;

  @override
  void dispose() {
    descriptionController.dispose();
    typeSiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          _TitleModal(title: "Crear sitio de interes"),
          SizedBox(height: 16),
          _ImageSite(
            onSetImage: (String path) {
              imagePath = path;
            },
          ),
          SizedBox(height: 16),
          _SelectTypeSite(
            onChanged: (int? id) {
              typeSiteController.text = id.toString();
            },
          ),
          SizedBox(height: 16),
          Input(
            isTextArea: true,
            hintText: "Descripción del sitio",
            controller: descriptionController,
            validators: [RequiredValidator()],
          ),
          Spacer(),
          PrimaryButton(
            text: "Guardar sitio",
            onPressed: () {
              _createSite();
            },
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  _createSite() {
    final description = descriptionController.text;
    final typeSite = typeSiteController.text;
    final idRoute =
        (context.read<SetRouteMapCubit>().state as SetPositionCurrent).idRoute;
    if (description.isEmpty || typeSite.isEmpty || imagePath.isEmpty) {
      return;
    }
    final site = SiteOffline(
      idRoute: idRoute!,
      description: description,
      photo: imagePath,
      latitude: widget.position.latitude,
      longitude: widget.position.longitude,
    );
    context.read<SetRouteMapCubit>().addSite(site);
    Navigator.pop(context);
  }
}

class _ImageSite extends StatelessWidget {
  final Function(String) onSetImage;
  const _ImageSite({required this.onSetImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      builder: (context, state) {
        if (state is SetImagePicker) {
          onSetImage(state.image.path);
          return Container(
                 width: double.infinity,
                 height: 150,
                 decoration: BoxDecoration(
                             image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(state.image),
                             ),
            ),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ButtonImagePicker(
              onPressed: () => context.read<ImagePickerCubit>().getPhoto(),
            ),
            SizedBox(width: 8),
            _ButtonImagePicker(
              isCamera: false,
              onPressed: () =>
                  context.read<ImagePickerCubit>().getPhotoFromGallery(),
            ),
          ],
        );
      },
    );
  }
}

class _ButtonImagePicker extends StatelessWidget {
  final Function()? onPressed;
  final bool isCamera;
  const _ButtonImagePicker({required this.onPressed, this.isCamera = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           onTap: onPressed,
           child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: PaleteColors.gray,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    isCamera
                        ? Icons.add_a_photo_outlined
                        : Icons.add_photo_alternate_outlined,
                    color: PaleteColors.gray200,
                    size: 40,
                  ),
            ),
    );
  }
}

class _SelectTypeSite extends StatelessWidget {
  final Function(int?) onChanged;
  const _SelectTypeSite({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypeSiteCubit, TypeSiteState>(
      builder: (context, state) {
        if (state is GetTypeSitesLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is GetTypeSitesSuccess) {
          return SelectDropdown<TypeSite>(
            value: state.typeSites.first,
            hint: "Selecciona un tipo de sitio",
            items: state.typeSites
                .map(
                  (typeSite) => DropdownMenuItem<TypeSite>(
                    value: typeSite,
                    child: Text(typeSite.description),
                  ),
                )
                .toList(),
            onChanged: (value) {
              onChanged(value?.id);
            },
          );
        }
        return Center(child: Text("Error al cargar los tipos de sitios"));
      },
    );
  }
}

class _FinishRoute extends StatelessWidget {
  const _FinishRoute();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          _TitleModal(title: "Calificar la ruta"),
          _RoutePhoto(),
          _SetCalification(),
          Spacer(),
          PrimaryButton(text: "Finalizar", onPressed: () {}),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RoutePhoto extends StatelessWidget {
  const _RoutePhoto();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetRouteMapCubit, SetRouteMapState>(
      builder: (context, state) { 
        if (state is SetPositionCurrent && state.photoRoute != null) {
          return Container(
                 width: double.infinity,
                 height: 200,
                 decoration: BoxDecoration(
                              image: DecorationImage(
                                     fit: BoxFit.cover,
                                     image: FileImage(state.photoRoute!),
                              ),
                 ),
          );
        }
        return  SizedBox.shrink();
      },
    );
  }
}

class _SetCalification extends StatefulWidget {
  const _SetCalification();

  @override
  State<_SetCalification> createState() => _SetCalificationState();
}

class _SetCalificationState extends State<_SetCalification> {
  int initialCalification = 1;

  final Map<int, String> calificationLabels = {
    1: "Muy fácil",
    2: "Fácil",
    3: "Intermedio",
    4: "Difícil",
    5: "Muy difícil",
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(LucideIcons.flame, size: 40),
                  color: index + 1 <= initialCalification
                      ? PaleteColors.red
                      : PaleteColors.gray100,
                  onPressed: () => setState(() {
                    initialCalification = index + 1;
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            calificationLabels[initialCalification] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ImageMarker extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;
  final double borderWidth;

  const _ImageMarker({
    required this.imageUrl,
    this.size = 80,
    this.borderColor = Colors.white,
    this.borderWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
            image: DecorationImage(
              image: FileImage(File(imageUrl)),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -8,
          child: CustomPaint(
            size: Size(20, 10),
            painter: _TrianglePainter(color: borderColor),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
