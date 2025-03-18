import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador del WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Actualiza la barra de carga según el progreso
          },
          onPageStarted: (String url) {
            // Acción al iniciar la carga de una página
          },
          onPageFinished: (String url) {
            // Acción al finalizar la carga de una página
          },
          onHttpError: (HttpResponseError error) {
            // Maneja errores HTTP
          },
          onWebResourceError: (WebResourceError error) {
            // Maneja errores de recursos web
          },
          onNavigationRequest: (NavigationRequest request) {
            // Decide si se permite la navegación
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://mock-webview-733652063485.herokuapp.com/model'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
