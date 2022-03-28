# env vars 
TARGET_TYPE=Debug
EMSCRIPTEN_TOOLS="$(realpath "$(dirname "$(realpath "$(which emcc)")")/../libexec/tools")"
FLAVOUR='standard'
FLAVOUR_DIR="build/flavour/$FLAVOUR"
OUT_DIR="/Users/nick/git/orgs/enspyrco/dart_box2d_wasm"
EMCC_OPTS=(
  -fno-rtti
  -s MODULARIZE=1
  -s EXPORT_NAME=Box2D
  -s ALLOW_TABLE_GROWTH=1
  --memory-init-file 0
  -s FILESYSTEM=0
  -s SUPPORT_LONGJMP=0
  -s EXPORTED_FUNCTIONS=_malloc,_free
  -s ALLOW_MEMORY_GROWTH=1
  -g3
  -gsource-map
	-s ASSERTIONS=2
  -s DEMANGLE_SUPPORT=1
)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! [[ "$PWD" -ef "$DIR" ]]; then
  >&2 echo -e "${Red}This script is meant to be run from <repository_root>/box2d-wasm${NC}"
  exit 1
fi

pushd "$FLAVOUR_DIR"

# Build wasm - try adding ${EMCC_OPTS[@]}
emcc "$DIR/glue_stub.cpp" bin/libbox2d.a -I "$DIR/../box2d/include" --no-entry -o "$OUT_DIR/box2d.wasm"

popd