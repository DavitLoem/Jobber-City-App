import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/district_model.dart';
import 'package:jobber_city/models/role/seeker/location_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

class EditProfileScreenView extends GetView<EditProfileScreenViewController> {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _Section(
                        index: 0,
                        icon: Icons.badge_outlined,
                        label: 'Personal Information',
                        child: _buildPersonalInfo(),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 1,
                        icon: Icons.contact_mail_outlined,
                        label: 'Contact',
                        child: _buildContact(),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 2,
                        icon: Icons.work_outline_rounded,
                        label: 'Current Position',
                        child: _buildCurrentPosition(),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 3,
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        child: _buildAddress(),
                      ),
                      const SizedBox(height: 28),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Header: gradient banner + back button + avatar ──
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight.withOpacity(0.55), Colors.white],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 18),
          _buildAvatarHeader(),
        ],
      ),
    );
  }

  // ── Avatar header — reads from firstName/lastName obs (live) ──
  // Scales+fades in on first paint, gives a tactile press-scale on tap,
  // and cross-fades between the picked photo and a person-icon placeholder
  // when no image has been set yet.
  Widget _buildAvatarHeader() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.7 + (0.3 * value.clamp(0.0, 1.0)),
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: Column(
          children: [
            _AvatarTapScale(
              onTap: controller.pickProfileImage,
              child: Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                            child: controller.profileImagePath.value.isNotEmpty
                                ? Image.file(
                                    File(controller.profileImagePath.value),
                                    key: ValueKey(
                                      controller.profileImagePath.value,
                                    ),
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                  )
                                : controller.profileImageUrl.value.isNotEmpty
                                ? Image.network(
                                    controller.profileImageUrl.value,
                                    key: ValueKey(
                                      controller.profileImageUrl.value,
                                    ),
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 82,
                                        height: 82,
                                        color: AppColors.primaryLight,
                                        child: const Icon(
                                          Icons.person_rounded,
                                          size: 42,
                                          color: AppColors.primary,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    key: const ValueKey('avatar_placeholder'),
                                    width: 82,
                                    height: 82,
                                    color: AppColors.primaryLight,
                                    child: const Icon(
                                      Icons.person_rounded,
                                      size: 42,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // Camera edit badge
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Text(
                '${controller.firstName.value} ${controller.lastName.value}'
                    .trim(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textHint,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // ── Personal Info ──
  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('First Name'),
                  const SizedBox(height: 6),
                  CustomTextfield(
                    hintText: 'First Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.firstNameController,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Last Name'),
                  const SizedBox(height: 6),
                  CustomTextfield(
                    hintText: 'Last Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.lastNameController,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Date of Birth
        _buildFieldLabel('Date of Birth'),
        const SizedBox(height: 6),
        CustomTextfield(
          hintText: 'DD/MM/YYYY',
          prefixIcon: Icons.date_range_outlined,
          controller: controller.dateOfBirthCtrl,
          readOnly: true,
          onTap: controller.selectDate,
        ),
        const SizedBox(height: 20),

        // Gender
        _buildFieldLabel('Gender'),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildGenderChip('Male', Icons.male_rounded),
            const SizedBox(width: 10),
            _buildGenderChip('Female', Icons.female_rounded),
            const SizedBox(width: 10),
            _buildGenderChip('Other', Icons.person_outline_rounded),
          ],
        ),
        const SizedBox(height: 20),

        // Marital Status
        _buildFieldLabel('Marital Status'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildMaritalChip('Single'),
            _buildMaritalChip('Married'),
            _buildMaritalChip('Divorced'),
            _buildMaritalChip('Widowed'),
          ],
        ),
        const SizedBox(height: 20),

        // Nationality
        _buildFieldLabel('Nationality'),
        const SizedBox(height: 6),
        CitySelectField<String>(
          controller: controller.nationalityCtrl,
          fetchOptions: controller.fetchNationalityOptions,
          labelOf: (n) => n,
          hintText: 'Select Nationality',
          sheetTitle: 'Select Nationality',
          searchHint: 'Search nationality...',
          prefixIcon: Icons.flag_outlined,
          showSeparators: false,
          onSelected: (n) => controller.nationalityCtrl.text = n,
        ),
      ],
    );
  }

  // ── Contact ──
  Widget _buildContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Email'),
        const SizedBox(height: 6),
        CustomTextfield(
          prefixIcon: Icons.email_outlined,
          hintText: 'Email',
          controller: controller.emailController,
        ),
        const SizedBox(height: 20),
        _buildFieldLabel('Phone'),
        const SizedBox(height: 6),
        CustomTextfield(
          prefixIcon: Icons.phone_outlined,
          hintText: 'Phone Number',
          controller: controller.phoneCtrl,
        ),
      ],
    );
  }

  // ── Current Position ──
  Widget _buildCurrentPosition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Current Position'),
        const SizedBox(height: 6),
        CustomTextfield(
          prefixIcon: Icons.work_outline,
          hintText: 'Enter your current position',
          controller: controller.currentPositionCtrl,
        ),
      ],
    );
  }

  // ── Address ──
  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Province'),
        const SizedBox(height: 6),
        CitySelectField<LocationModel>(
          controller: controller.provinceController,
          fetchOptions: controller.fetchProvinceOptions,
          labelOf: (loc) => loc.nameEn,
          hintText: 'Select Province',
          sheetTitle: 'Select Province',
          onSelected: (loc) {
            controller.selectedProvinceId.value = loc.id.toString();
            controller.provinceCtrl.text = loc.nameEn;
            controller.fetchDistricts(loc.id.toString());
          },
        ),
        const SizedBox(height: 20),

        _buildFieldLabel('District / Khan'),
        const SizedBox(height: 6),
        Obx(
          () => CitySelectField<DistrictModel>(
            controller: controller.districtCtrl,
            fetchOptions: controller.fetchDistrictOptions,
            labelOf: (d) => d.nameEn,
            hintText: controller.selectedProvinceId.value.isEmpty
                ? 'Select province first'
                : 'Select District',
            sheetTitle: 'Select District',
            enabled: controller.selectedProvinceId.value.isNotEmpty,
            onSelected: (d) {
              controller.selectedDistrictId.value = d.id.toString();
            },
          ),
        ),
        const SizedBox(height: 20),

        _buildFieldLabel('Commune / Sangkat'),
        const SizedBox(height: 6),
        CustomTextfield(
          prefixIcon: Icons.location_on_outlined,
          hintText: 'Enter commune',
          controller: controller.communeCtrl,
        ),
        const SizedBox(height: 20),

        _buildFieldLabel('Village'),
        const SizedBox(height: 6),
        CustomTextfield(
          prefixIcon: Icons.holiday_village_outlined,
          hintText: 'Enter village',
          controller: controller.villageCtrl,
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Street'),
                  const SizedBox(height: 6),
                  CustomTextfield(
                    prefixIcon: Icons.signpost_outlined,
                    hintText: 'Street name',
                    controller: controller.streetCtrl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('House / No.'),
                  const SizedBox(height: 6),
                  CustomTextfield(
                    prefixIcon: Icons.home_outlined,
                    hintText: 'e.g. 12A',
                    controller: controller.houseNoCtrl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Gender chip ──
  Widget _buildGenderChip(String name, IconData icon) {
    return Expanded(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller.genderCtrl,
        builder: (_, value, __) {
          final isSelected =
              value.text.trim().toLowerCase() == name.toLowerCase();
          return GestureDetector(
            onTap: () {
              controller.genderCtrl.text = name;
              controller.selectedGender.value = name;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary
                    : AppColors.inputBackground,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.inputIconText,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.inputIconText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Marital status chip ──
  Widget _buildMaritalChip(String name) {
    final chipWidth = (Get.width - 40 - 32 - 30) / 4;
    return SizedBox(
      width: chipWidth,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller.maritalStatusCtrl,
        builder: (_, value, __) {
          final isSelected =
              value.text.trim().toLowerCase() == name.toLowerCase();
          return GestureDetector(
            onTap: () {
              controller.maritalStatusCtrl.text = name;
              controller.selectedMaritalStatus.value = name;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.inputIconText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Save button ──
  // Gray + untappable until every required field is filled in.
  // Snaps to full color + becomes tappable the moment isFormValid flips true.
  Widget _buildSaveButton() {
    return Obx(() {
      final isSaving = controller.isSaving.value;
      final isFormValid = controller.isFormValid.value;
      final isEnabled = isFormValid && !isSaving;

      final button = SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: CustomButton(
            text: isSaving ? 'Saving...' : 'Save Profile',
            onPressed: controller.updateProfile,
          ),
        ),
      );

      // IgnorePointer fully blocks taps while disabled, so onPressed above
      // can never fire until the form is actually complete.
      return IgnorePointer(
        ignoring: !isEnabled,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEnabled ? 1.0 : 0.55,
          child: ColorFiltered(
            colorFilter: isEnabled
                ? const ColorFilter.mode(
                    Color.fromARGB(0, 204, 15, 15),
                    BlendMode.dst,
                  )
                : const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, //
                    0.2126, 0.7152, 0.0722, 0, 0, //
                    0.2126, 0.7152, 0.0722, 0, 0, //
                    0, 0, 0, 1, 0, //
                  ]),
            child: button,
          ),
        ),
      );
    });
  }
}

/// Section wrapper: icon + label header above a rounded card, with a
/// staggered fade + slide-up entrance so the screen doesn't just pop in.
class _Section extends StatelessWidget {
  const _Section({
    required this.index,
    required this.icon,
    required this.label,
    required this.child,
  });

  final int index;
  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + index * 90),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHint,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: this.child,
          ),
        ],
      ),
    );
  }
}

/// Small helper: scales its child down slightly on press for tactile
/// feedback, then springs back on release. Used to make the avatar
/// picker feel interactive/tappable.
class _AvatarTapScale extends StatefulWidget {
  const _AvatarTapScale({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_AvatarTapScale> createState() => _AvatarTapScaleState();
}

class _AvatarTapScaleState extends State<_AvatarTapScale> {
  double _scale = 1.0;

  void _setScale(double value) => setState(() => _scale = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setScale(0.92),
      onTapUp: (_) => _setScale(1.0),
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
