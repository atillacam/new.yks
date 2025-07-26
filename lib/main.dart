import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  addAdminUser();
  runApp(const MyApp());
}

// Kullanıcı Modeli
class User {
  String ad;
  String soyad;
  String email;
  String tel;
  String cinsiyet;
  String dogum;
  String password;

  User({
    required this.ad,
    required this.soyad,
    required this.email,
    required this.tel,
    required this.cinsiyet,
    required this.dogum,
    required this.password,
  });
}

User? currentUser;
List<User> allUsers = [];
List<User> loggedInUsers = [];

bool containsTurkishChars(String value) {
  return RegExp(r'[çğıöşüÇĞİÖŞÜ]').hasMatch(value);
}

void addAdminUser() {
  allUsers.add(
    User(
      ad: 'Admin',
      soyad: 'Yönetici',
      email: 'admin@mail.com',
      tel: '05555555555',
      cinsiyet: 'Diğer',
      dogum: '01/01/1990',
      password: 'admin123',
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giriş Ekranı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: _themeMode,
      home: LoginPage(onThemeChanged: _changeTheme, themeMode: _themeMode),
    );
  }
}

// Giriş Ekranı
class LoginPage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final ThemeMode themeMode;
  const LoginPage({
    super.key,
    required this.onThemeChanged,
    required this.themeMode,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool _obscurePassword = true;

  void _login() {
    final email = _usernameController.text;
    final password = _passwordController.text;

    if (containsTurkishChars(email)) {
      setState(() {
        _message = 'E-posta adresinde Türkçe karakter kullanılamaz!';
      });
      return;
    }
    if (containsTurkishChars(password)) {
      setState(() {
        _message = 'Şifrede Türkçe karakter kullanılamaz!';
      });
      return;
    }

    User? user;
    try {
      user = allUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      user = null;
    }

    if (user != null) {
      currentUser = user;
      loggedInUsers.add(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExamSelectPage(user: user!)),
      );
    } else {
      setState(() {
        _message = 'Kullanıcı adı veya şifre yanlış!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Kullanıcı Girişi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Eğer assets klasöründe resim yoksa, bu satırı yorum satırı yapabilirsiniz.
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/bg_login.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.deepPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _message,
                      style: TextStyle(
                        fontSize: 18,
                        color: _message == 'Giriş başarılı!'
                            ? Colors.green
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Şifremi Unuttum?',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Hesap Oluştur',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kayıt Ekranı
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dogumController = TextEditingController();
  String _cinsiyet = 'Erkek';
  bool _kvkkOnay = false;
  bool _acikRizaOnay = false;
  String _error = '';
  bool _obscurePassword = true;

  void _register() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_formKey.currentState!.validate() && _kvkkOnay && _acikRizaOnay) {
      if (!email.contains('@')) {
        setState(() {
          _error = 'E-posta adresi "@" içermeli!';
        });
        return;
      }
      if (containsTurkishChars(email)) {
        setState(() {
          _error = 'E-posta adresinde Türkçe karakter kullanılamaz!';
        });
        return;
      }
      if (containsTurkishChars(password)) {
        setState(() {
          _error = 'Şifrede Türkçe karakter kullanılamaz!';
        });
        return;
      }
      if (allUsers.any((u) => u.email == email)) {
        setState(() {
          _error = 'Bu e-posta ile daha önce kayıt olunmuş!';
        });
        return;
      }
      currentUser = User(
        ad: _adController.text,
        soyad: _soyadController.text,
        email: email,
        tel: _telController.text,
        cinsiyet: _cinsiyet,
        dogum: _dogumController.text,
        password: password,
      );
      allUsers.add(currentUser!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(user: currentUser!),
        ),
      );
    } else {
      setState(() {
        _error = !_kvkkOnay || !_acikRizaOnay
            ? 'KVKK ve Açık Rıza metinlerini onaylamalısınız!'
            : 'Lütfen tüm alanları doğru doldurun!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Oluştur'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _adController,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (v) => v!.isEmpty ? 'Ad gerekli' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _soyadController,
                decoration: const InputDecoration(labelText: 'Soyad'),
                validator: (v) => v!.isEmpty ? 'Soyad gerekli' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v!.contains('@') ? null : 'Geçerli e-posta girin',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v!.length < 10 ? 'Geçerli telefon girin' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _cinsiyet,
                items: const [
                  DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
                  DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
                  DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
                ],
                onChanged: (v) => setState(() => _cinsiyet = v!),
                decoration: const InputDecoration(labelText: 'Cinsiyet'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dogumController,
                decoration: const InputDecoration(
                  labelText: 'Doğum Tarihi (GG/AA/YYYY)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    var text = newValue.text;
                    if (text.length > 2 && text[2] != '/') {
                      text = '${text.substring(0, 2)}/${text.substring(2)}';
                    }
                    if (text.length > 5 && text[5] != '/') {
                      text = '${text.substring(0, 5)}/${text.substring(5)}';
                    }
                    return TextEditingValue(
                      text: text,
                      selection: TextSelection.collapsed(offset: text.length),
                    );
                  }),
                ],
                validator: (v) => v!.isEmpty ? 'Doğum tarihi gerekli' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (v) =>
                    v!.length < 6 ? 'Şifre en az 6 karakter olmalı' : null,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _kvkkOnay,
                onChanged: (v) => setState(() => _kvkkOnay = v!),
                title: const Text('KVKK metnini okudum ve onaylıyorum.'),
                subtitle: const Text(
                  'Kişisel verileriniz 6698 sayılı KVKK kapsamında işlenmektedir.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              CheckboxListTile(
                value: _acikRizaOnay,
                onChanged: (v) => setState(() => _acikRizaOnay = v!),
                title: const Text('Açık rıza metnini okudum ve onaylıyorum.'),
                subtitle: const Text(
                  'Hukuksal bilgilendirme: Açık rıza metni ile verilerinizin işlenmesini kabul etmiş olursunuz.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _register,
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profil Ekranı
class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text('Ad: ${user.ad}', style: const TextStyle(fontSize: 18)),
            Text('Soyad: ${user.soyad}', style: const TextStyle(fontSize: 18)),
            Text(
              'E-posta: ${user.email}',
              style: const TextStyle(fontSize: 18),
            ),
            Text('Telefon: ${user.tel}', style: const TextStyle(fontSize: 18)),
            Text(
              'Cinsiyet: ${user.cinsiyet}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Doğum Tarihi: ${user.dogum}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'KVKK ve Açık Rıza Onaylandı',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Giriş yapan kullanıcılar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...loggedInUsers.map((u) => Text(u.email)),
          ],
        ),
      ),
    );
  }
}

// Şifremi Unuttum Ekranı
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _infoMessage;

  void _resetPassword() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _infoMessage = "E-posta adresinizi giriniz!";
      } else {
        _infoMessage =
            "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifremi Unuttum"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "E-posta",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _resetPassword,
              child: const Text(
                "Şifre Sıfırlama Bağlantısı Gönder",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_infoMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _infoMessage!,
                  style: TextStyle(
                    color: _infoMessage!.contains("gönderildi")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Geri Dön"),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamSelectPage extends StatelessWidget {
  final User user;
  const ExamSelectPage({super.key, required this.user});

  Widget _buildExamButton({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Seç'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(user: user),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profilim',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Eğer assets klasöründe resim yoksa, bu satırı yorum satırı yapabilirsiniz.
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/bg_exam.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildExamButton(
                  label: 'YKS',
                  icon: Icons.school,
                  gradientColors: [Colors.deepPurple, Colors.purpleAccent],
                  onPressed: () {
                    // YKS sayfasına yönlendirme ekleyebilirsiniz
                  },
                ),
                _buildExamButton(
                  label: 'KPSS',
                  icon: Icons.workspace_premium,
                  gradientColors: [Colors.indigo, Colors.blueAccent],
                  onPressed: () {
                    // KPSS sayfasına yönlendirme ekleyebilirsiniz
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final User user;
  const SettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final myAppState = context.findAncestorStateOfType<_MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlarım'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.light_mode, color: Colors.white),
              label: const Text(
                'Aydınlık Mod',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                myAppState?._changeTheme(ThemeMode.light);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.dark_mode, color: Colors.white),
              label: const Text(
                'Karanlık Mod',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                myAppState?._changeTheme(ThemeMode.dark);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      onThemeChanged: myAppState!._changeTheme,
                      themeMode: myAppState._themeMode,
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
