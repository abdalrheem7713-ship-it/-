
import 'package:flutter/material.dart';

void main() {
  runApp(const NathrApp());
}

const bg = Color(0xFF0B1017);
const panel = Color(0xFF151E29);
const accent = Color(0xFF21D6A1);
const muted = Color(0xFF8D9AAA);

class NathrApp extends StatelessWidget {
  const NathrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نذر | NATHR',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          surface: panel,
        ),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selected = 0;

  final pages = const [
    'الرئيسية',
    'الأجهزة',
    'الاستطلاع',
    'الثغرات',
    'المهام',
    'السجلات',
    'الإعدادات',
  ];

  final icons = const [
    Icons.dashboard_rounded,
    Icons.devices_rounded,
    Icons.radar_rounded,
    Icons.security_rounded,
    Icons.task_alt_rounded,
    Icons.receipt_long_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Row(
          children: [
            Icon(Icons.shield_moon_rounded, color: accent, size: 30),
            SizedBox(width: 10),
            Text(
              'نَذْر',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'NATHR',
              style: TextStyle(
                color: accent,
                fontSize: 13,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('لا توجد تنبيهات جديدة')),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF153C3A),
                    Color(0xFF172532),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.radar, size: 42, color: accent),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مركز العمليات الأمنية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'مراقبة الأصول وتحليل المخاطر',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.circle, color: accent, size: 10),
                ],
              ),
            ),
            Expanded(
              child: selected == 0
                  ? dashboardContent()
                  : sectionContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected == 0 ? 0 : 1,
        onDestinationSelected: (value) {
          setState(() => selected = value == 0 ? 0 : selected);
          if (value != 0) {
            showSections();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_rounded),
            label: 'الأقسام',
          ),
        ],
      ),
    );
  }

  Widget dashboardContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Text(
          'نظرة عامة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: const [
            MetricCard(
              icon: Icons.devices_rounded,
              title: 'الأجهزة المسجلة',
              value: '0',
              note: 'بانتظار الربط',
            ),
            MetricCard(
              icon: Icons.radar_rounded,
              title: 'عمليات الفحص',
              value: '0',
              note: 'لا توجد عمليات',
            ),
            MetricCard(
              icon: Icons.bug_report_rounded,
              title: 'الثغرات المكتشفة',
              value: '0',
              note: 'لا توجد نتائج بعد',
            ),
            MetricCard(
              icon: Icons.check_circle_outline,
              title: 'المهام المكتملة',
              value: '0',
              note: 'الجلسة الحالية',
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Text(
          'الأقسام الرئيسية',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...List.generate(pages.length - 1, (i) {
          return Card(
            color: panel,
            margin: const EdgeInsets.only(bottom: 9),
            child: ListTile(
              leading: Icon(icons[i + 1], color: accent),
              title: Text(pages[i + 1]),
              subtitle: Text(sectionDescription(i + 1)),
              trailing: const Icon(Icons.chevron_right, color: muted),
              onTap: () {
                setState(() => selected = i + 1);
              },
            ),
          );
        }),
        const SizedBox(height: 18),
        const Text(
          'NATHR SECURITY PLATFORM · V1.0',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget sectionContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icons[selected], color: accent, size: 58),
            const SizedBox(height: 18),
            Text(
              pages[selected],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sectionDescription(selected),
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted, height: 1.8),
            ),
            const SizedBox(height: 24),
            const Text(
              'هذا القسم جاهز لتطوير وظائفه وربطه بالبيانات الفعلية.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.8),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => setState(() => selected = 0),
              icon: const Icon(Icons.arrow_back),
              label: const Text('العودة إلى الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  String sectionDescription(int i) {
    const descriptions = [
      '',
      'تسجيل الأجهزة ومتابعة حالتها',
      'فحص الخدمات والأصول المصرح بها',
      'قاعدة الثغرات وتقييم المخاطر',
      'إنشاء المهام ومتابعة النتائج',
      'سجل الأحداث والتدقيق',
      'تفضيلات التطبيق والاتصال',
    ];
    return descriptions[i];
  }

  void showSections() {
    showModalBottomSheet(
      context: context,
      backgroundColor: panel,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: List.generate(pages.length, (i) {
            return ListTile(
              leading: Icon(icons[i], color: accent),
              title: Text(pages[i]),
              onTap: () {
                setState(() => selected = i);
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String note;

  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF273544)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: accent, size: 25),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            note,
            style: const TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}