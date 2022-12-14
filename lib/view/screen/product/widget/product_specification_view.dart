import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/title_row.dart';
import '../specification_screen.dart';

class ProductSpecification extends StatelessWidget {
  final String productSpecification;
  ProductSpecification({@required this.productSpecification});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return Column(
      children: [
        TitleRow(title: getTranslated('specification', context), isDetailsPage: true,

        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        productSpecification.isNotEmpty ? Expanded(child: Html(data: productSpecification)) :
        Center(child: Text('No specification')),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        InkWell(
              onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SpecificationScreen(specification: productSpecification)));
          },
            child: Text(getTranslated('view_full_detail', context), style: titleRegular.copyWith(color: Theme.of(context).primaryColor),))

      ],
    );
  }
}
