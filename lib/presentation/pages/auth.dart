import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:security_wave/presentation/pages/home.dart';
import '../../core/app_colors.dart';
import '../../core/app_icons.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../widgets/w_textField.dart';

class Authentication_Page extends ConsumerStatefulWidget {
  const Authentication_Page({super.key, required this.isTablet});

  final bool isTablet;

  @override
  ConsumerState<Authentication_Page> createState() =>
      _AuthenticationMobileState();
}

class _AuthenticationMobileState extends ConsumerState<Authentication_Page>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  late final TabController _tabController;
  bool _isLogin = true;
  bool _isForgetPassword = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await ref.read(authRepositoryProvider).signIn(email, password);
      _showSnackBar("Login successful!");
      clearAll();
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _register() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showSnackBar("Passwords do not match");
      return;
    }

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (user != null) {
        _showSnackBar("Registration successful!");
        setState(() => _isLogin = true);
        clearAll();
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void clearAll() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _adminEmailController.clear();
    _adminPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isTablet = widget.isTablet;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: authState.when(
        data: (data) {
          if (data == null) {
            return _authenticationPage(isTablet);
          } else {
            return Home_Page();
          }
        },
        error:
            (error, stackTrace) =>
                Scaffold(body: Center(child: Text("Error: $error"))),
        loading:
            () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
      ),
    );
  }

  Widget _authentication(isTablet) {
    return Column(
      children: [
        _formFields(isTablet),
        _isLogin ? _forgotPasswordButton(isTablet) : const SizedBox(height: 30),
        _isLogin ? SizedBox(height: 20) : Center(),
        _actionButton(isTablet),
        _orLine(isTablet),
        _signupOption(isTablet),
      ],
    );
  }

  Widget _forgetPassword(isTablet) {
    return Column(
      children: [
        W_TextFieldWidget(
          title: "Email Address",
          hint: "alex@email.com",
          icon: AppIcons.mail,
          inputType: TextInputType.emailAddress,
          controller: _adminEmailController,
          obscureText: false,
          isWeb: false,
          isTablet: isTablet,
        ),
        const SizedBox(height: 25),
        _buttonWidget("Send Reset Link", () {}, true, isTablet),
        _orLine(isTablet),
        _buttonWidget(
          "Login With Existing Account",
          () => setState(() => _isForgetPassword = !_isForgetPassword),
          false,
          isTablet,
        ),
      ],
    );
  }

  Widget _header(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Security Wave",
            style: AppTextStyles.dynamicStyle(
              fontSize: isTablet ? 10.sp : 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            _isForgetPassword
                ? "Reset Password"
                : _isLogin
                ? "Log into your account"
                : "Create New Account",
            style: AppTextStyles.dynamicStyle(
              fontSize: isTablet ? 4.5.sp : 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formFields(bool isTablet) {
    return Column(
      children: [
        W_TextFieldWidget(
          title: "Email Address",
          inputType: TextInputType.emailAddress,
          hint: "alex@email.com",
          icon: AppIcons.mail,
          controller: _emailController,
          obscureText: false,
          isWeb: false,
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        W_TextFieldWidget(
          title: "Password",
          inputType: TextInputType.visiblePassword,
          hint: "ABC123",
          icon: AppIcons.password,
          controller: _passwordController,
          obscureText: true,
          isWeb: false,
          isTablet: isTablet,
        ),
        if (!_isLogin) ...[
          const SizedBox(height: 10),
          W_TextFieldWidget(
            title: "Confirm Password",
            inputType: TextInputType.visiblePassword,
            hint: "ABC123",
            icon: AppIcons.password,
            controller: _confirmPasswordController,
            obscureText: true,
            isWeb: false,
            isTablet: isTablet,
          ),
        ],
      ],
    );
  }

  Widget _forgotPasswordButton(bool isTablet) {
    return GestureDetector(
      onTap: () => setState(() => _isForgetPassword = !_isForgetPassword),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 20, top: 12, bottom: 20),
        child: Text(
          "Forgot Password",
          textAlign: TextAlign.right,
          style: AppTextStyles.dynamicStyle(
            fontSize: isTablet ? 3.5.sp : 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(bool isTablet) {
    return _buttonWidget(
      _isLogin ? "Login Now" : "Sign Up Now",
      () => _isLogin ? _login() : _register(),
      true,
      isTablet,
    );
  }

  Widget _signupOption(bool isTablet) {
    return _buttonWidget(
      _isLogin ? "Sign Up Now" : "Login",
      () => setState(() => _isLogin = !_isLogin),
      false,
      isTablet,
    );
  }

  _buttonWidget(String text, VoidCallback onTap, isSingIn, isTablet) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSingIn ? Colors.white : AppColors.primary,
              width: 2,
            ),
            color: isSingIn ? AppColors.primary : Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.dynamicStyle(
              fontSize: isTablet ? 3.5.sp : 12.sp,
              fontWeight: FontWeight.w600,
              color: isSingIn ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      );

  _orLine(isTablet) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        _tabController.index == 0
            ? Flexible(
              flex: 4,
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(left: 20),
                color: Colors.grey.shade200,
              ),
            )
            : const Center(),
        _tabController.index == 0
            ? Text(
              "OR",
              style: AppTextStyles.dynamicStyle(
                fontSize: isTablet ? 3.sp : 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            )
            : const Center(),
        _tabController.index == 0
            ? Flexible(
              flex: 4,
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(right: 20),
                color: Colors.grey.shade200,
              ),
            )
            : const Center(),
      ],
    ),
  );

  _authenticationPage(isTablet) => Center(
    child: Container(
      height:
          _isForgetPassword
              ? isTablet
                  ? 430
                  : 370
              : isTablet
              ? 630
              : 560,
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(width: 5, color: AppColors.primary),
      ),
      child: Column(
        children: [
          _header(isTablet),
          _isForgetPassword
              ? _forgetPassword(isTablet)
              : _authentication(isTablet),
        ],
      ),
    ),
  );
}
