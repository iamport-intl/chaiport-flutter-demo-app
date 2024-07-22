import 'package:chai_flutter_demo_app/checkout/sdk_elements_checkout.dart';
import 'package:chai_flutter_demo_app/checkout/sdk_whole_checkout.dart';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:flutter/widgets.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/screens/checkout/checkout_screen.dart';

import 'checkout/app_elements_checkout.dart';

Requests requests = Requests();
final Map<String, WidgetBuilder> routes = {
  Checkout.routeName: (context) =>
      Checkout(checkoutRequest: requests.getGlobalCheckoutRequest()),
  CheckoutElements.routeName: (context) =>
      CheckoutElements(checkoutRequest: requests.getGlobalCheckoutRequest()),
  SdkWholeCheckout.routeName: (context) =>
      SdkWholeCheckout(checkoutRequest: requests.getGlobalCheckoutRequest()),
};
