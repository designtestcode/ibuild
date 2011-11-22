#! /bin/bash

PROJECT_NAME=SqLiteDriver
#VERSION=0.0.1
VERSION=`awk '{ if(index($1,"#") == 0) print $1 }' gradle.properties | awk -F "DEFAULT_APP_VERSION=" '{ print $2 }'  | awk '{if(length($1))  print $1}'`
#CONFIGURATION=Debug	# Debug or Release
#CONFIGURATION=`awk -F "CONFIGURATION=" '{ print $2 }' gradle.properties  | awk '{if(length($1))  print $1}'`
CONFIGURATION=`awk '{ if(index($1,"#") == 0) print $1 }' gradle.properties | awk -F "CONFIGURATION=" '{ print $2 }'  | awk '{if(length($1))  print $1}'`

LIB_NAME=lib$PROJECT_NAME

gradle --daemon  -q clean
gradle --daemon  -Dorg.gradle.project.SDK_TARGET_NAME='iphonesimulator' -q packageLib
gradle --daemon  -Dorg.gradle.project.SDK_TARGET_NAME='iphoneos' -q packageLib

mkdir -p build/Debug-universal/$PROJECT_NAME/Headers
lipo build/Debug-iphoneos/$LIB_NAME.a -arch i386 build/Debug-iphonesimulator/$LIB_NAME.a -create -output build/Debug-universal/$PROJECT_NAME/$LIB_NAME.a
cp -R build/Debug-iphoneos/$PROJECT_NAME/Headers/* build/Debug-universal/$PROJECT_NAME/Headers
cd build/Debug-universal
zip -yrq $PROJECT_NAME-$VERSION-$CONFIGURATION.zip $PROJECT_NAME
cd ../..
rm dist/*
cp build/Debug-universal/$PROJECT_NAME-$VERSION-$CONFIGURATION.zip ./dist/


