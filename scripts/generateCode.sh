#!/bin/bash

SOURCE="$0"
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"

WORKDIR=$DIR/../
model=$1
uploadFile=$model
if [ -z "$model" ]; then
  echo "缺少模型参数modelName: generateCode.sh modelName"
  exit 1
fi

rm -rf "$WORKDIR/build"
mkdir -p "$WORKDIR/build"
if [ -d "$model" ]; then
 zip -r "$WORKDIR/build/tmp.zip" "$model"
 uploadFile="$WORKDIR/build/tmp.zip"
fi

cd "$WORKDIR/build"
curl --location --request POST 'https://springboot-teaql-gen-code-xxlfpicwgi.cn-chengdu.fcapp.run/generate' --form file=@"$uploadFile" --output domain.zip
unzip domain.zip
gradle build --refresh-dependencies
gradle publish