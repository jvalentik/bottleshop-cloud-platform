import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/feature_section/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class FeatureSection extends StatelessWidget {
  FeatureSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(context.l10n.customerSatisfaction.toUpperCase(),
                style: publicSansTextTheme.bodyText1),
          ),
          Text(
            context.l10n.bringTopQuality,
            style: libreBodoniTextTheme.headline3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 302, right: 302),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeatureCard(
                    imgPath: kExclusiveIcon,
                    headline: context.l10n.premiumBrands,
                    txt: context.l10n.highestQualityBrands),
                FeatureCard(
                    imgPath: kGiftsIcon,
                    headline: context.l10n.giftsForDemandingPeople,
                    txt: context.l10n.surpriseLovedOnes),
                FeatureCard(
                  imgPath: kCareIcon,
                  headline: context.l10n.extraordinaryAccess,
                  txt: context.l10n.tenYearAccess,
                ),
                FeatureCard(
                    imgPath: kMobilePhoneIcon,
                    headline: context.l10n.mobileApplication,
                    txt: context.l10n.downloadFreeMobileApp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
