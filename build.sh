#!/bin/bash
if [ -z "$BEAT_TARGET" ]; then
	export BEAT_TARGET=$(uname)
fi

export BEAT_TARGET=${BEAT_TARGET,,}
export BEAT_TARGET=${BEAT_TARGET/darwin/mac}

# Create destination
export BUILD_DIR=./build/$BEAT_TARGET
mkdir -p $BUILD_DIR
export NAME="beat"
# Determine godot output profile
if [ "$BEAT_TARGET" == "mac" ]; then
	export GODOT_PROFILE="Mac"
	export EXTENSION="app"
elif [ "$BEAT_TARGET" == "windows" ]; then
	export GODOT_PROFILE="Windows"
	export EXTENSION="exe"
elif [ "$BEAT_TARGET" == "web" ]; then
	export GODOT_PROFILE="HTML5"
	export EXTENSION="html"
	export NAME="index"
else
	export GODOT_PROFILE="Linux"
	export EXTENSION="run"
fi
make
# Run godot build
./godot --headless --export-release "$GODOT_PROFILE" $BUILD_DIR/$NAME.$EXTENSION
# Copy licensing
cp LICENSE ATTRIBUTION $BUILD_DIR
echo "DONE!"