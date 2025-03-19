# get the parent directory of the current script
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
SCRIPT_DIR="$PROJECT_ROOT/scripts"
LIB_DIR="$PROJECT_ROOT/lib"
ASSET_DIR="$PROJECT_ROOT/assets"