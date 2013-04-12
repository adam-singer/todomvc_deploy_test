import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
/*
dart tool/hop_runner.dart --log-level all clean
dart tool/hop_runner.dart --log-level all build dart2js
dart tool/hop_runner.dart --log-level all dart2js
dart tool/hop_runner.dart --log-level all dart2js_dart
dart tool/hop_runner.dart --log-level all deploy
dart tool/hop_runner.dart --log-level all deploy_assets
dart tool/hop_runner.dart --log-level all compress
dart tool/hop_runner.dart --log-level all clean
 */
void main() {
  _assertKnownPath();
  
  final buildTask = createProcessTask('dart', args: ['x_build.dart'], description: "execute the project's build.dart file");
  addTask('build', buildTask);
  final paths = ['web/out/index.html_bootstrap.dart'];
  addTask('dart2js', createDart2JsTask(paths, minify: true, liveTypeAnalysis: true, rejectDeprecatedFeatures: true));
  // TODO: add dart output-type to createDart2JsTask
  addAsyncTask('dart2js_dart', (ctx) => startProcess(ctx, 'dart2js', ['--output-type=dart', '--minify','-oweb/out/index.html_bootstrap.dart','web/out/index.html_bootstrap.dart']));
  addAsyncTask('deploy', (ctx) => startProcess(ctx, 'rsync', ['-RLr', 'web/out/', 'deploy/']));
  addAsyncTask('deploy_assets', (ctx) => startProcess(ctx, 'cp', ['web/bg.png', 'web/base.css', 'deploy/web/out/']));
  addAsyncTask('compress', (ctx) => startProcess(ctx, 'tar', ['-zcvf', 'deploy.tar.gz', '-C', 'deploy/web/out/', '.']));
  addAsyncTask('clean', (ctx) => startProcess(ctx, 'rm', ['-rf', 'deploy', 'web/out']));
  
  runHop();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}