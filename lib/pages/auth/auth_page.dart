import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/auth_page_status.dart';
import 'package:varenya_mobile/pages/auth/login_page.dart';
import 'package:varenya_mobile/pages/auth/register_page.dart';
import 'package:varenya_mobile/services/auth_service.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/auth/auth_button_bar_widget.dart';
import 'package:varenya_mobile/widgets/common/custom_field_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = "/auth";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailAddressController =
      new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  late AuthService _authService;

  AuthPageStatus _authPageStatus = AuthPageStatus.REGISTER;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    this._emailAddressController.dispose();
  }

  void _handleAuthPageStatus(AuthPageStatus authPageStatus) {
    setState(() {
      this._authPageStatus = authPageStatus;
    });
  }

  Future<void> _handleFormSubmit() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    String emailAddress = this._emailAddressController.text;

    if (this._authPageStatus == AuthPageStatus.REGISTER) {
      bool isAvailable =
          await this._authService.checkAccountAvailability(emailAddress);

      if (isAvailable) {
        Navigator.of(context).pushReplacementNamed(
          RegisterPage.routeName,
          arguments: emailAddress,
        );
      } else {
        displaySnackbar("This email address is not available.", context);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(
        LoginPage.routeName,
        arguments: emailAddress,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: this._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.asset(
                    'assets/logo/app_logo.png',
                    scale: 0.5,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: CustomFieldWidget(
                    textFieldController: this._emailAddressController,
                    label: 'Email Address',
                    validators: [
                      RequiredValidator(
                          errorText: 'Email address is required.'),
                      EmailValidator(
                          errorText: 'Please enter a valid email address.')
                    ],
                    textInputType: TextInputType.emailAddress,
                    suffixIcon: GestureDetector(
                      onTap: this._handleFormSubmit,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
                Text(
                  'Dicta dolores sequi reprehenderit corporis. Ipsam adipisci iure culpa.',
                  textAlign: TextAlign.center,
                ),
                AuthButtonBarWidget(
                  onSelect: this._handleAuthPageStatus,
                  authPageStatus: this._authPageStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
