import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:crypto/crypto.dart';

class EsewaPaymentScreen extends StatefulWidget {
  final String amount;
  final String transactionUuid;
  final String productCode;
  final String? signature;
  final String successUrl;
  final String failureUrl;

  const EsewaPaymentScreen({
    super.key,
    required this.amount,
    required this.transactionUuid,
    this.productCode = 'EPAYTEST',
    this.signature,
    this.successUrl = 'https://esewa.com.np',
    this.failureUrl = 'https://esewa.com.np',
  });

  @override
  State<EsewaPaymentScreen> createState() => _EsewaPaymentScreenState();
}

class _EsewaPaymentScreenState extends State<EsewaPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.successUrl)) {
              _handleSuccess(request.url);
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(widget.failureUrl)) {
              Navigator.pop(context, null);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _loadPaymentForm();
  }

  void _loadPaymentForm() {
    final String signature = widget.signature ?? _generateTestSignature();
    
    // eSewa ePay v2 UAT Endpoint
    const String esewaEndpoint = 'https://rc-epay.esewa.com.np/api/epay/main/v2/form';

    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <title>eSewa Payment</title>
        </head>
        <body onload="document.forms[0].submit()">
          <form action="$esewaEndpoint" method="POST">
            <input type="hidden" name="amount" value="${widget.amount}">
            <input type="hidden" name="tax_amount" value="0">
            <input type="hidden" name="total_amount" value="${widget.amount}">
            <input type="hidden" name="transaction_uuid" value="${widget.transactionUuid}">
            <input type="hidden" name="product_code" value="${widget.productCode}">
            <input type="hidden" name="product_service_charge" value="0">
            <input type="hidden" name="product_delivery_charge" value="0">
            <input type="hidden" name="success_url" value="${widget.successUrl}">
            <input type="hidden" name="failure_url" value="${widget.failureUrl}">
            <input type="hidden" name="signed_field_names" value="total_amount,transaction_uuid,product_code">
            <input type="hidden" name="signature" value="$signature">
          </form>
          <p>Redirecting to eSewa...</p>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(htmlContent);
  }

  String _generateTestSignature() {
    // TODO: Move signature generation to a backend server before production for security.
    // UAT Secret Key
    const String secretKey = '8gBm/:&EnhH.1/q';
    final String data = 'total_amount=${widget.amount},transaction_uuid=${widget.transactionUuid},product_code=${widget.productCode}';
    
    final List<int> keyBytes = utf8.encode(secretKey);
    final List<int> dataBytes = utf8.encode(data);
    
    final Hmac hmac = Hmac(sha256, keyBytes);
    final Digest digest = hmac.convert(dataBytes);
    
    return base64.encode(digest.bytes);
  }

  void _handleSuccess(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String? data = uri.queryParameters['data'];
      if (data != null) {
        final String decodedString = utf8.decode(base64.decode(data));
        final Map<String, dynamic> response = json.decode(decodedString);
        Navigator.pop(context, response);
      } else {
        Navigator.pop(context, null);
      }
    } catch (e) {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('eSewa Payment'),
          backgroundColor: const Color(0xFF60BB46), // eSewa Green
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF60BB46),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
