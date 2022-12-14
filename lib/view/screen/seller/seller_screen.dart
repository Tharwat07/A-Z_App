import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/seller_model.dart';
import '../../../helper/product_type.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/guest_dialog.dart';
import '../../basewidget/rating_bar.dart';
import '../../basewidget/search_widget.dart';
import '../chat/chat_screen.dart';
import '../home/widget/products_view.dart';

class SellerScreen extends StatelessWidget {
  final SellerModel seller;
  SellerScreen({@required this.seller});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).removeFirstLoading();
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(seller.seller.id.toString(), 1, context);
    ScrollController _scrollController = ScrollController();
    String ratting = seller != null && seller.avgRating != null? seller.avgRating.toString() : "0";



    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),

      body: Column(
        children: [
          CustomAppBar(title: '${seller.seller.fName}'+' ''${seller.seller.lName}'),

          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              children: [

                // Banner
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder, height: 120, fit: BoxFit.cover,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/banner/${seller.seller.shop != null ? seller.seller.shop.banner : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                ),

                Container(
                  color: Theme.of(context).highlightColor,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(children: [

                    // Seller Info
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder, height: 80, width: 80, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${seller.seller.shop.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 80, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(seller.seller.shop.name, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), maxLines: 1, overflow: TextOverflow.ellipsis,),

                            Row(
                              children: [
                                RatingBar(rating: double.parse(ratting)),
                                Text('(${seller.totalReview.toString()})' , style: titilliumRegular.copyWith(), maxLines: 1, overflow: TextOverflow.ellipsis,),

                              ],
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            Row(
                              children: [
                                Text(seller.totalReview.toString() +' '+ '${getTranslated('reviews', context)}',
                                  style: titleRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: ColorResources.getReviewRattingColor(context)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                Text('|'),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                Text(seller.totalProduct.toString() +' '+
                                    '${getTranslated('products', context)}',
                                  style: titleRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: ColorResources.getReviewRattingColor(context)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],
                            ),


                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            showAnimatedDialog(context, GuestDialog(), isFlip: true);
                          }else if(seller != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(seller: seller)));
                          }
                        },
                        icon: Image.asset(Images.chat_image, color: ColorResources.SELLER_TXT, height: Dimensions.ICON_SIZE_DEFAULT),
                      ),
                    ]),

                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Padding(
                  padding:  EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                  child: SearchWidget(
                    hintText: 'Search product...',
                    onTextChanged: (String newText) => Provider.of<ProductProvider>(context, listen: false).filterData(newText),
                    onClearPressed: () {},
                    isSeller: true,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: ProductView(isHomePage: false, productType: ProductType.SELLER_PRODUCT, scrollController: _scrollController, sellerId: seller.seller.id.toString()),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
