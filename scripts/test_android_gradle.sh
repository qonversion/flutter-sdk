#!/usr/bin/env bash
set -euo pipefail

# Compile the real plugin and its Maven dependencies without example-app signing
# credentials or unrelated plugins. The host supplies AGP/KGP just as a Flutter app does.
# Usage: GRADLE=/path/to/gradle FLUTTER_ROOT=/path/to/flutter \
#   bash scripts/test_android_gradle.sh <agp> <kgp> <built-in:true|false|default> <new-dsl:true|false>
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
agp="${1:?AGP version required}"
kgp="${2:?KGP version required}"
built_in="${3:?built-in mode required}"
new_dsl="${4:?new DSL mode required}"
legacy=true
if [[ "${agp%%.*}" -ge 9 && "$built_in" != false ]]; then
  legacy=false
fi
args=("-PtestAgp=$agp" "-PtestKgp=$kgp" "-PtestLegacyKotlin=$legacy" "-Pandroid.newDsl=$new_dsl")
if [[ "$built_in" != default ]]; then
  args+=("-Pandroid.builtInKotlin=$built_in")
fi
"${GRADLE:-gradle}" -p "$repo_dir/scripts/android-gradle-test" --no-daemon --console=plain \
  "${args[@]}" :plugin:clean :plugin:verifyKotlinMode :plugin:assembleDebug

# A configuration-only success could hide missing Kotlin compilation. Require
# the actual public plugin class in the built Android library.
python3 - "$repo_dir/android/build/outputs/aar/plugin-debug.aar" <<'PY'
import io
import struct
import sys
import zipfile

with zipfile.ZipFile(sys.argv[1]) as aar:
    with zipfile.ZipFile(io.BytesIO(aar.read('classes.jar'))) as classes:
        for name in ('QonversionPlugin', 'NoCodesPlugin'):
            bytecode = classes.read(f'com/qonversion/flutter/sdk/qonversion_flutter_sdk/{name}.class')
            assert struct.unpack('>H', bytecode[6:8])[0] == 52, f'{name} must keep Java 8 bytecode compatibility'
print('Verified QonversionPlugin/NoCodesPlugin classes and Java 8 bytecode in AAR')
PY
