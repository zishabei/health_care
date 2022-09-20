mkdir -p lib/pigeons/
mkdir -p android/src/main/java/dev/flutter/pigeon/

flutter pub run pigeon \
  --input pigeons/steps.dart \
  --dart_out lib/pigeons/steps.dart \
  --objc_header_out ios/Classes/Steps.h \
  --objc_source_out ios/Classes/Steps.m \
  --java_out android/src/main/java/dev/flutter/pigeon/Pigeon.java \
  --java_package "dev.flutter.pigeon"