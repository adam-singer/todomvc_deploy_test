pub install && 
dart tool/hop_runner.dart --log-level all clean &&
dart tool/hop_runner.dart --log-level all build dart2js &&
dart tool/hop_runner.dart --log-level all dart2js && 
dart tool/hop_runner.dart --log-level all dart2js_dart &&
dart tool/hop_runner.dart --log-level all deploy &&
dart tool/hop_runner.dart --log-level all deploy_assets &&
dart tool/hop_runner.dart --log-level all compress &&
dart tool/hop_runner.dart --log-level all clean
