import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fzolumdfoftgcbwrdbru.supabase.co',           // ← Replace this
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6b2x1bWRmb2Z0Z2Nid3JkYnJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1ODgyNDUsImV4cCI6MjEwNTE2NDI0NX0.2YYDYtMegx51wB1wqD3yxbRC157VpKPsi66ttrG9VPk',  // ← Still works for now
  );

  runApp(
    const ProviderScope(
      child: PitayaProApp(),
    ),
  );
}