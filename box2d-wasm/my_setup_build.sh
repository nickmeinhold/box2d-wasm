# env vars 
TARGET_TYPE=Debug
FLAVOUR='standard'
EMSCRIPTEN_TOOLS="$(realpath "$(dirname "$(realpath "$(which emcc)")")/../libexec/tools")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FLAVOUR_DIR="build/flavour/$FLAVOUR"

if ! [[ "$PWD" -ef "$DIR" ]]; then
  >&2 echo -e "${Red}This script is meant to be run from <repository_root>/box2d-wasm${NC}"
  exit 1
fi

mkdir -p "build/common"
pushd "build/common"

# use Box2D.idl to create ./box2d_glue.{js,cpp} for invoking functionality from libbox2d
python3 "$EMSCRIPTEN_TOOLS/webidl_binder.py" "$DIR/Box2D.idl" box2d_glue

popd

mkdir -p "$FLAVOUR_DIR"
pushd "$FLAVOUR_DIR"

# Generate 'standard' flavour Makefile
emcmake cmake -DCMAKE_BUILD_TYPE="$TARGET_TYPE" "$DIR/../box2d" -DBOX2D_BUILD_UNIT_TESTS=OFF -DBOX2D_BUILD_DOCS=OFF -DBOX2D_BUILD_TESTBED=OFF

# Compile C++ to LLVM IR (creates ./build/bin/libbox2d.a archive)
emmake make

popd