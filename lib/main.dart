import 'package:flutter/material.dart';

void main() => runApp(const CounselAiApp());

class CounselAiApp extends StatelessWidget {
  const CounselAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counsel AI',
      debugShowCheckedModeBanner: false,
      theme: counselTheme(Brightness.light),
      darkTheme: counselTheme(Brightness.dark),
      home: const CounselShell(),
    );
  }
}

const navy = Color(0xFF1B4965);
const navyHover = Color(0xFF153B52);
const ink = Color(0xFF1A1A1A);
const secondary = Color(0xFF6B7280);
const border = Color(0xFFE5E7EB);
const surface = Color(0xFFF7F7F8);
const success = Color(0xFF15803D);
const warning = Color(0xFFB45309);
const danger = Color(0xFFB91C1C);
const privacyGreen = Color(0xFF047857);

ThemeData counselTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: dark ? const Color(0xFF111315) : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      brightness: brightness,
      primary: dark ? const Color(0xFF6F9DB7) : navy,
      surface: dark ? const Color(0xFF17191C) : Colors.white,
    ),
    fontFamily: 'Inter',
    textTheme: TextTheme(
      headlineLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 1.2),
      headlineMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.25),
      titleLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: const TextStyle(fontSize: 14, height: 1.6),
      bodyMedium: const TextStyle(fontSize: 14, height: 1.5),
      labelSmall: const TextStyle(fontSize: 11, letterSpacing: .55, fontWeight: FontWeight.w500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF1B1E21) : surface,
      border: OutlineInputBorder(borderSide: const BorderSide(color: border), borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: dark ? const Color(0xFF30353A) : border), borderRadius: BorderRadius.circular(8)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: navy, width: 2), borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}

enum AppScreen { chat, research, documents, settings }
enum AiMode { local, api, research, tools }

class CounselShell extends StatefulWidget {
  const CounselShell({super.key});
  @override
  State<CounselShell> createState() => _CounselShellState();
}

class _CounselShellState extends State<CounselShell> {
  AppScreen screen = AppScreen.chat;
  AiMode mode = AiMode.local;
  bool sidebar = true;
  bool dark = false;
  bool onboarding = false;

  @override
  Widget build(BuildContext context) {
    final page = switch (screen) {
      AppScreen.chat => ChatView(mode: mode, onModeChanged: (m) => setState(() => mode = m)),
      AppScreen.research => const ResearchView(),
      AppScreen.documents => const DocumentView(),
      AppScreen.settings => SettingsView(dark: dark, onDark: (v) => setState(() => dark = v)),
    };
    return Theme(
      data: counselTheme(dark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (sidebar) Sidebar(
                screen: screen,
                onNavigate: (s) => setState(() => screen = s),
                onCollapse: () => setState(() => sidebar = false),
              ),
              Expanded(
                child: Column(
                  children: [
                    TopBar(
                      screen: screen,
                      mode: mode,
                      onModeChanged: (m) => setState(() => mode = m),
                      onExpand: () => setState(() => sidebar = true),
                      dark: dark,
                      onDark: (v) => setState(() => dark = v),
                    ),
                    Expanded(child: page),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final AppScreen screen;
  final ValueChanged<AppScreen> onNavigate;
  final VoidCallback onCollapse;
  const Sidebar({super.key, required this.screen, required this.onNavigate, required this.onCollapse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 252,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: const Border(right: BorderSide(color: border))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(7)), child: const Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            const SizedBox(width: 10),
            const Expanded(child: Text('Counsel AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            IconButton(tooltip: 'Collapse sidebar', onPressed: onCollapse, icon: const Icon(Icons.chevron_left_rounded, size: 19)),
          ]),
          const SizedBox(height: 18),
          SizedBox(height: 38, child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('New conversation'))),
          const SizedBox(height: 18),
          const SectionLabel('WORKSPACE'),
          _nav(Icons.chat_bubble_outline, 'Chat', AppScreen.chat),
          _nav(Icons.find_in_page_outlined, 'Research', AppScreen.research),
          _nav(Icons.description_outlined, 'Documents', AppScreen.documents),
          const SizedBox(height: 17),
          const SectionLabel('RECENT'),
          const HistoryItem(title: 'Breach of contract remedies', time: 'Today'),
          const HistoryItem(title: 'Employment termination memo', time: 'Yesterday'),
          const HistoryItem(title: 'NDA for external counsel', time: 'Mon'),
          const Spacer(),
          const Divider(color: border),
          _nav(Icons.settings_outlined, 'Settings', AppScreen.settings),
          Row(children: [
            const Icon(Icons.lock_outline, size: 16, color: privacyGreen),
            const SizedBox(width: 7),
            const Expanded(child: Text('Private · Local mode', style: TextStyle(fontSize: 11, color: privacyGreen))),
            Tooltip(message: 'Your prompts stay on this device in local mode', child: Icon(Icons.info_outline, size: 15, color: secondary)),
          ]),
        ]),
      ),
    );
  }

  Widget _nav(IconData icon, String label, AppScreen target) {
    final active = screen == target;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        selected: active,
        selectedTileColor: const Color(0xFFEAF0F4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        leading: Icon(icon, size: 18, color: active ? navy : secondary),
        title: Text(label, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
        onTap: () => onNavigate(target),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final AppScreen screen;
  final AiMode mode;
  final ValueChanged<AiMode> onModeChanged;
  final VoidCallback onExpand;
  final bool dark;
  final ValueChanged<bool> onDark;
  const TopBar({super.key, required this.screen, required this.mode, required this.onModeChanged, required this.onExpand, required this.dark, required this.onDark});

  @override
  Widget build(BuildContext context) {
    final title = switch (screen) { AppScreen.chat => 'Assistant', AppScreen.research => 'Deep legal research', AppScreen.documents => 'Documents', AppScreen.settings => 'Settings' };
    return Container(
      height: 62,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: border))),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(children: [
        IconButton(tooltip: 'Open sidebar', onPressed: onExpand, icon: const Icon(Icons.menu_rounded, size: 20)),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        const Spacer(),
        ModeSegmentedControl(mode: mode, onChanged: onModeChanged),
        const SizedBox(width: 12),
        IconButton(tooltip: 'Toggle dark mode', onPressed: () => onDark(!dark), icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 19)),
        const SizedBox(width: 4),
        const CircleAvatar(radius: 15, backgroundColor: surface, child: Icon(Icons.person_outline, size: 18, color: secondary)),
      ]),
    );
  }
}

class ModeSegmentedControl extends StatelessWidget {
  final AiMode mode;
  final ValueChanged<AiMode> onChanged;
  const ModeSegmentedControl({super.key, required this.mode, required this.onChanged});
  String _label(AiMode m) => switch (m) { AiMode.local => 'Local', AiMode.api => 'API', AiMode.research => 'Research', AiMode.tools => 'Tools' };
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.surface),
      child: Row(children: AiMode.values.map((m) => InkWell(
        onTap: () => onChanged(m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(color: mode == m ? surface : null, borderRadius: BorderRadius.circular(7)),
          child: Row(children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: m == AiMode.api ? const Color(0xFFD97706) : privacyGreen, shape: BoxShape.circle)),
            const SizedBox(width: 6), Text(_label(m), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ),
      )).toList()),
    );
  }
}

class ChatView extends StatefulWidget {
  final AiMode mode;
  final ValueChanged<AiMode> onModeChanged;
  const ChatView({super.key, required this.mode, required this.onModeChanged});
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = TextEditingController();
  bool sources = true;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final compact = c.maxWidth < 900;
      return Column(children: [
        Expanded(child: SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: compact ? 24 : 72, vertical: 26), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 860), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [const Text('Today', style: TextStyle(fontSize: 11, color: secondary, letterSpacing: .6, fontWeight: FontWeight.w600)), const Spacer(), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.history, size: 15), label: const Text('Load earlier messages', style: TextStyle(fontSize: 12)))]),
          const SizedBox(height: 18),
          const UserBubble('What remedies are available for a material breach of contract under English law?'),
          const SizedBox(height: 16),
          AssistantResponse(sources: sources, onSources: () => setState(() => sources = !sources)),
          const SizedBox(height: 26),
          EmptyHintCard(),
        ])))) ,
        Container(padding: EdgeInsets.fromLTRB(compact ? 18 : 72, 10, compact ? 18 : 72, 18), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 860), child: Column(children: [
          Row(children: [
            const Icon(Icons.lock_outline, size: 14, color: privacyGreen), const SizedBox(width: 6),
            Text(widget.mode == AiMode.api ? 'External API · Review before sending confidential material' : 'Local mode · Data stays on this device', style: TextStyle(fontSize: 11, color: widget.mode == AiMode.api ? warning : privacyGreen)),
          ]),
          const SizedBox(height: 8),
          Container(decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.surface), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            IconButton(tooltip: 'Attach file', onPressed: () {}, icon: const Icon(Icons.attach_file_rounded, size: 19)),
            Expanded(child: TextField(controller: controller, minLines: 1, maxLines: 5, decoration: const InputDecoration(hintText: 'Ask a legal question, research a topic, or draft a document', border: InputBorder.none, filled: false))),
            const SizedBox(width: 6), IconButton.filled(tooltip: 'Send', onPressed: () {}, icon: const Icon(Icons.arrow_upward_rounded, size: 18)), const SizedBox(width: 6),
          ])),
          const SizedBox(height: 6),
          const Row(children: [Text('Ctrl+K', style: TextStyle(fontSize: 10, color: secondary, fontFamily: 'monospace')), SizedBox(width: 5), Text('command palette', style: TextStyle(fontSize: 10, color: secondary)), Spacer(), Text('Confidentiality controls are always visible', style: TextStyle(fontSize: 10, color: secondary))]),
        ]))),
      ]);
    });
  }
}

class UserBubble extends StatelessWidget { final String text; const UserBubble(this.text, {super.key}); @override Widget build(BuildContext context) => Align(alignment: Alignment.centerRight, child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), constraints: const BoxConstraints(maxWidth: 620), decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(10)), child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6)))); }

class AssistantResponse extends StatelessWidget {
  final bool sources; final VoidCallback onSources;
  const AssistantResponse({super.key, required this.sources, required this.onSources});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Container(width: 28, height: 28, alignment: Alignment.center, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(6)), child: const Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))), const SizedBox(width: 10), const Text('Counsel AI', style: TextStyle(fontWeight: FontWeight.w600)), const Spacer(), const Text('Local', style: TextStyle(fontSize: 11, color: privacyGreen, fontWeight: FontWeight.w600))]),
    const SizedBox(height: 14),
    const Text('Under English law, a material breach may give the innocent party a right to terminate the contract and/or claim damages, depending on the contractual terms and the nature of the breach. Courts generally assess whether the breach goes to the root of the contract or substantially deprives the innocent party of the benefit for which it contracted.'),
    const SizedBox(height: 12),
    const Text('Potential remedies', style: TextStyle(fontWeight: FontWeight.w600)),
    const SizedBox(height: 7),
    const Text('1. Damages — compensation for loss caused by the breach, subject to causation, remoteness and mitigation.\n2. Termination — potentially available where the breach is repudiatory or the contract provides a termination right.\n3. Specific relief — available in limited circumstances where damages are not an adequate remedy.'),
    const SizedBox(height: 14),
    OutlinedButton.icon(onPressed: onSources, icon: const Icon(Icons.source_outlined, size: 16), label: const Text('Sources (3)')), 
    if (sources) const Padding(padding: EdgeInsets.only(top: 12), child: Column(children: [CitationTile(name: 'Legislation.gov.uk', url: 'https://www.legislation.gov.uk/', relevance: 'High'), CitationTile(name: 'UK Supreme Court', url: 'https://www.supremecourt.uk/', relevance: 'High'), CitationTile(name: 'BAILII', url: 'https://www.bailii.org/', relevance: 'Medium')])),
  ]));
}

class CitationTile extends StatelessWidget { final String name, url, relevance; const CitationTile({super.key, required this.name, required this.url, required this.relevance}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 7), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border), borderRadius: BorderRadius.circular(7)), child: Row(children: [const Icon(Icons.link, size: 14, color: navy), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), Text(url, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: secondary, fontFamily: 'monospace'))])), Text(relevance, style: TextStyle(fontSize: 11, color: relevance == 'High' ? success : warning, fontWeight: FontWeight.w600))]))); }

class ResearchView extends StatelessWidget { const ResearchView({super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(34), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
  Row(children: [const Text('Deep legal research', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)), const Spacer(), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.close, size: 16), label: const Text('Cancel'))]), const SizedBox(height: 8),
  const Text('Searching only legitimate sources and preserving a citation trail for every material claim.', style: TextStyle(color: secondary)), const SizedBox(height: 18),
  Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)), child: const Row(children: [Icon(Icons.verified_outlined, color: privacyGreen, size: 18), SizedBox(width: 9), Expanded(child: Text('Searching only: .gov, .edu, court sites, bar associations, legal publishers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)))])),
  const SizedBox(height: 22),
  _ResearchStep(number: '01', title: 'Planning your query…', status: 'Complete', progress: 1.0),
  _ResearchStep(number: '02', title: 'Searching legitimate legal sources…', status: 'In progress', progress: .66, detail: 'Whitelist: legislation.gov.uk · supremecourt.uk · bailii.org'),
  _ResearchStep(number: '03', title: 'Reading and analyzing…', status: 'Queued', progress: .25, detail: '3 sources discovered'),
  _ResearchStep(number: '04', title: 'Writing report…', status: 'Queued', progress: .08),
  const Spacer(),
  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(8)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Research result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), SizedBox(height: 10), Text('The final report will appear here as source-backed text streams in. A Sources section will remain attached to the report.')]))
])))); }
}

class _ResearchStep extends StatelessWidget { final String number, title, status; final double progress; final String? detail; const _ResearchStep({required this.number, required this.title, required this.status, required this.progress, this.detail}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(8)), child: Column(children: [Row(children: [Text(number, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: secondary)), const SizedBox(width: 14), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))), Text(status, style: TextStyle(fontSize: 11, color: status == 'Complete' ? success : status == 'In progress' ? warning : secondary, fontWeight: FontWeight.w600))]), const SizedBox(height: 9), LinearProgressIndicator(value: progress, minHeight: 5, color: navy, backgroundColor: const Color(0xFFE5E7EB)), if (detail != null) Padding(padding: const EdgeInsets.only(top: 7), child: Align(alignment: Alignment.centerLeft, child: Text(detail!, style: const TextStyle(fontSize: 11, color: secondary, fontFamily: 'monospace'))))]))); }

class DocumentView extends StatefulWidget { const DocumentView({super.key}); @override State<DocumentView> createState() => _DocumentViewState(); }
class _DocumentViewState extends State<DocumentView> { int tab = 2; String template = 'Legal Memo'; @override Widget build(BuildContext context) => Column(children: [
  Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: border))), child: Row(children: [const Text('Template', style: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w600, letterSpacing: .5)), const SizedBox(width: 9), ...['Non-Disclosure Agreement','Employment Contract','Legal Memo','Motion','Letter'].map((t) => Padding(padding: const EdgeInsets.only(right: 6), child: ChoiceChip(label: Text(t, style: const TextStyle(fontSize: 11)), selected: template == t, onSelected: (_) => setState(() => template = t)))) , const Spacer(), ToggleButtons(isSelected: [tab == 0, tab == 1, tab == 2], onPressed: (i) => setState(() => tab = i), children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 11), child: Text('Edit')), Padding(padding: EdgeInsets.symmetric(horizontal: 11), child: Text('Preview')), Padding(padding: EdgeInsets.symmetric(horizontal: 11), child: Text('Split'))])]),
  Expanded(child: Row(children: [if (tab != 1) Expanded(child: _MdxPane()), if (tab == 2) const VerticalDivider(width: 1), if (tab != 0) Expanded(child: _PreviewPane())])),
  Container(height: 50, padding: const EdgeInsets.symmetric(horizontal: 14), decoration: const BoxDecoration(border: Border(top: BorderSide(color: border))), child: Row(children: [const Text('Drafted under: England & Wales law', style: TextStyle(fontSize: 11, color: secondary)), const Spacer(), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.file_copy_outlined, size: 16), label: const Text('Duplicate')), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.copy_outlined, size: 16), label: const Text('Copy')), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf_outlined, size: 16), label: const Text('Export PDF')), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.description_outlined, size: 16), label: const Text('Export DOCX'))])
]); }

class _MdxPane extends StatelessWidget { @override Widget build(BuildContext context) => Container(color: const Color(0xFFFBFBFC), padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('MDX', style: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w600, letterSpacing: .5)), const SizedBox(height: 11), Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(7), color: Colors.white), child: const SingleChildScrollView(child: Text('01  # LEGAL MEMORANDUM\n02\n03  ## To\n04  Managing Partner\n05\n06  ## From\n07  Counsel AI\n08\n09  ## Re: Breach of Contract Remedies\n10\n11  ### Issue\n12  What remedies may be available following a material breach?\n13\n14  ### Summary\n15  The answer depends on the contractual terms and\n16  the legal classification of the breach.\n17\n18  ### Analysis\n19  A repudiatory breach may entitle the innocent party\n20  to accept the repudiation and terminate. Damages\n21  remain subject to ordinary principles of causation,\n22  remoteness and mitigation.\n23\n24  <!-- Select text to regenerate this section -->', style: TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.7)))))])); }
class _PreviewPane extends StatelessWidget { @override Widget build(BuildContext context) => Container(color: const Color(0xFFEFEFF0), padding: const EdgeInsets.all(22), child: Center(child: Container(constraints: const BoxConstraints(maxWidth: 610), color: Colors.white, padding: const EdgeInsets.fromLTRB(48, 42, 48, 54), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('LEGAL MEMORANDUM', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: .8, fontFamily: 'Georgia')), const SizedBox(height: 24), const Text('To: Managing Partner\nFrom: Counsel AI\nRe: Breach of Contract Remedies', style: TextStyle(fontFamily: 'Georgia', fontSize: 13, height: 1.7)), const SizedBox(height: 22), const Text('Issue', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 8), const Text('What remedies may be available following a material breach?', style: TextStyle(fontFamily: 'Georgia', fontSize: 13, height: 1.8)), const SizedBox(height: 20), const Text('Analysis', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 8), const Text('The contractual terms should be reviewed first. A repudiatory breach may permit termination, while damages remain subject to ordinary principles of causation, remoteness and mitigation. The report should be read with the cited authorities before client advice is issued.', style: TextStyle(fontFamily: 'Georgia', fontSize: 13, height: 1.85)), const SizedBox(height: 25), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.refresh, size: 15), label: const Text('Regenerate section'))])))); }

class SettingsView extends StatelessWidget { final bool dark; final ValueChanged<bool> onDark; const SettingsView({super.key, required this.dark, required this.onDark}); @override Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(30), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 980), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)), const SizedBox(height: 6), const Text('Plain-English controls. Nothing here requires technical knowledge.', style: TextStyle(color: secondary)), const SizedBox(height: 24), _settingsCard('Model', 'Choose how Counsel AI generates answers.', [SettingRow(label: 'Local model', helper: 'Runs on this computer. Private by default.', trailing: const Text('Llama 3.1 8B · GGUF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))), SettingRow(label: 'VRAM usage', helper: 'Current memory used by the local model.', trailing: const Text('4.2 GB / 8 GB', style: TextStyle(fontSize: 12, fontFamily: 'monospace'))), SettingRow(label: 'Context length', helper: 'How much text can be considered at once.', trailing: const Text('16k tokens', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))), SettingRow(label: 'Temperature', helper: 'Lower values produce more consistent drafting.', trailing: SizedBox(width: 220, child: Slider(value: .2, onChanged: (_) {})))]), _settingsCard('Privacy', 'Control what stays on this device and what may leave it.', [SettingRow(label: 'Data retention', helper: 'Keep conversation history locally for later review.', trailing: Switch(value: true, onChanged: (_) {})), SettingRow(label: 'Encryption', helper: 'Local app data is stored with encryption enabled.', trailing: const StatusPill(text: 'Enabled', color: privacyGreen)), SettingRow(label: 'Cloud AI warning', helper: 'Show a warning before confidential material is sent to an external API.', trailing: Switch(value: true, onChanged: (_) {})), Align(alignment: Alignment.centerLeft, child: OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: danger), onPressed: () {}, icon: const Icon(Icons.delete_outline, size: 17), label: const Text('Clear all local data')))]), _settingsCard('Search filters', 'Choose which sources may be used by Research mode.', [SettingRow(label: 'Default legitimate sources', helper: '.gov, .edu, court sites, bar associations, legal publishers', trailing: const StatusPill(text: 'Active', color: success)), SettingRow(label: 'Custom whitelist', helper: 'Add trusted domains that your firm uses.', trailing: TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16), label: const Text('Manage domains')))]), _settingsCard('Tools', 'Connect external services only when you approve them.', [SettingRow(label: 'Gmail', helper: 'Send email only after preview and confirmation.', trailing: OutlinedButton(onPressed: () {}, child: const Text('Connect'))), SettingRow(label: 'Outlook', helper: 'Use Microsoft 365 email and calendar.', trailing: OutlinedButton(onPressed: () {}, child: const Text('Connect'))), SettingRow(label: 'Calendar', helper: 'Create events only after you approve the details.', trailing: OutlinedButton(onPressed: () {}, child: const Text('Connect')))]), _settingsCard('Appearance', 'Keep the legal-office look you find easiest to read.', [SettingRow(label: 'Dark mode', helper: 'Optional. Light mode is the default.', trailing: Switch(value: dark, onChanged: onDark)), SettingRow(label: 'Text size', helper: 'Adjust interface text for comfortable reading.', trailing: const Text('100%', style: TextStyle(fontWeight: FontWeight.w600))), SettingRow(label: 'Keyboard shortcuts', helper: 'Ctrl+K command palette · Ctrl+N new chat · Ctrl+S save · Ctrl+/ help', trailing: TextButton(onPressed: () {}, child: const Text('View all')))])])))); }
}

Widget _settingsCard(String title, String help, List<Widget> children) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(9)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(help, style: const TextStyle(color: secondary, fontSize: 12)), const SizedBox(height: 13), ...children]));

class SettingRow extends StatelessWidget { final String label, helper; final Widget trailing; const SettingRow({super.key, required this.label, required this.helper, required this.trailing}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text(helper, style: const TextStyle(fontSize: 11, color: secondary))])), trailing])); }
class StatusPill extends StatelessWidget { final String text; final Color color; const StatusPill({super.key, required this.text, required this.color}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(999)), child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))); }
class SectionLabel extends StatelessWidget { final String text; const SectionLabel(this.text, {super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 7), child: Text(text, style: const TextStyle(fontSize: 10, color: secondary, letterSpacing: .65, fontWeight: FontWeight.w600))); }
class HistoryItem extends StatelessWidget { final String title, time; const HistoryItem({super.key, required this.title, required this.time}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 7), child: InkWell(borderRadius: BorderRadius.circular(6), onTap: () {}, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)), const SizedBox(height: 2), Text(time, style: const TextStyle(fontSize: 10, color: secondary))])))); }
class EmptyHintCard extends StatelessWidget { const EmptyHintCard({super.key}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Try one of these', style: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w600, letterSpacing: .4)), const SizedBox(height: 8), Wrap(spacing: 7, runSpacing: 7, children: ['Draft a client letter about late payment', 'Research limitation periods in England', 'Create an NDA for a contractor'].map((t) => ActionChip(label: Text(t, style: const TextStyle(fontSize: 11)), onPressed: () {})).toList())])); }
