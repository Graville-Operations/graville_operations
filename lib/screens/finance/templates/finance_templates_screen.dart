import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/screens/finance/templates/external_works/external_drop_screen.dart';
import 'package:graville_operations/screens/finance/templates/external_works/external_pick_screen.dart';
import 'package:graville_operations/screens/finance/templates/internal_works/drop_materials_screen.dart';
import 'package:graville_operations/screens/finance/templates/internal_works/pick_materials_screen.dart';
import 'package:graville_operations/screens/finance/works/works_list_screen.dart';
import 'package:graville_operations/screens/invoice/invoice_screen.dart';

class FinanceTemplatesScreen extends StatelessWidget {
  const FinanceTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Finance Templates'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a template',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                // ─── Internal Pick
                _TemplateCard(
                  title: 'Internal Pick',
                  subtitle: 'Pick from supplier',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.upload_rounded,
                  patternIcon: Icons.local_shipping_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PickMaterialsScreen(),
                    ),
                  ),
                ),

                _TemplateCard(
                  title: 'Internal Drop',
                  subtitle: 'Drop at site',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.download_rounded,
                  patternIcon: Icons.warehouse_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DropMaterialsScreen(),
                    ),
                  ),
                ),

                // ─── External Pick
                _TemplateCard(
                  title: 'External Pick',
                  subtitle: 'Hired vehicle pick',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92400E), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.upload_rounded,
                  patternIcon: Icons.engineering_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExternalPickScreen(),
                    ),
                  ),
                ),

                _TemplateCard(
                  title: 'External Drop',
                  subtitle: 'Hired vehicle drop',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF78350F), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.download_rounded,
                  patternIcon: Icons.construction_rounded,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExternalDropScreen(),
                    ),
                  ),
                ),

                // ─── Invoice
                _TemplateCard(
                  title: 'Invoice',
                  subtitle: 'Supplier invoice',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF065F46), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.receipt_long_rounded,
                  patternIcon: Icons.attach_money_rounded,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InvoiceScreen(),
                    ),
                  ),
                ),

                _TemplateCard(
                  title: 'Works Records',
                  subtitle: 'View all pick & drop',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F2937), Color(0xFF4B5563)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.history_rounded,
                  patternIcon: Icons.list_alt_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorksListScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;
  final IconData patternIcon;
  final VoidCallback onTap;
  final bool enabled;

  const _TemplateCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.patternIcon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // ─── Gradient background
                Container(
                  decoration: BoxDecoration(gradient: gradient),
                ),

                // ─── Ghost pattern icons
                Positioned(
                  top: -18,
                  right: -18,
                  child: Icon(
                    patternIcon,
                    size: 110,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: -20,
                  child: Icon(
                    patternIcon,
                    size: 70,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 10,
                  child: Icon(
                    patternIcon,
                    size: 45,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!enabled)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Soon',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 68,
                  child: Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                // ─── Ripple
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: enabled ? onTap : null,
                      splashColor: Colors.white.withOpacity(0.1),
                      highlightColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}