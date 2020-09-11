# monri-ios

The Monri iOS SDK makes it easy to build an excellent payment experience in your iOS app. It provides powerful, customizable, UI elements to use out-of-the-box to collect your users' payment details.

We also expose the low-level APIs that power those elements to make it easy to build fully custom forms. This guide will take you all the way from integrating our SDK to accepting payments from your users via credit cards.

## Install and configure the SDK

Check our wiki installation guide at [Installation Guide](https://github.com/MonriPayments/monri-ios/wiki/Installation-Guide)

# Payment API Integration

At some point in the flow of your app you'll obtain payment details from the user. After that you could:
- use obtained payment details and proceed with charge (confirmPayment)
- or tokenize obtained payment details for server side usage

In [Payment API Integration](https://github.com/MonriPayments/monri-ios/wiki/Payment-API-Integration) it's explained how to:
- create payment
- collect payment details
- confirm payment
- get results back on your app and on your backend

If you want to tokenize obtained payment details then continue to the "Tokens API Integration"

# Tokens API Integration

After you've obtained payment details it's easy to securely transfer collected data via Tokens API.

In [Tokens API Integration](https://github.com/MonriPayments/monri-ios/wiki/Tokens-API-Integration) it's explained how to:
- create token request
- create token
- how to use created token for transaction authorization on your backend

# Questions

If you have any questions about documentation/APIs/flow do not hesitate to contact us at support@monri.com
