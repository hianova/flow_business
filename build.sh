#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# FLOW Business — Pure .lean Forensic Sidecar, Ownership & Dashboard Pipeline
# ==============================================================================
# Usage:
#   ./build.sh            # Build all targets, shared library, and run full test suite
#   ./build.sh build      # Compile src/flow_business.lean -> C/Rust/Py/JS/CUDA + .so
#   ./build.sh test       # Run flowy + 1PB zero-copy + Ownership Dashboard self-test
#   ./build.sh dashboard  # Launch interactive CFO Control Plane & Ownership Web UI
#   ./build.sh clean      # Clean build/ artifacts
# ==============================================================================

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLOW_DIR="${FLOW_HOME:-$(cd "$ROOT_DIR/../FLOW" && pwd)}"
export PATH="$FLOW_DIR/build:$PATH"
export FLOWC="$FLOW_DIR/build/flowc"
FLOWY="$FLOW_DIR/build/flowy"
BUILD_DIR="$ROOT_DIR/build"
LEAN_SRC="$ROOT_DIR/src/flow_business.lean"
CC="${CC:-clang}"
cd "$ROOT_DIR"

ensure_flow_toolchain() {
    if [[ ! -x "$FLOWC" || ! -x "$FLOWY" ]]; then
        echo "▶ Building FLOW toolchain in $FLOW_DIR..."
        make -C "$FLOW_DIR" -j4 all
    fi
}

cmd_build() {
    ensure_flow_toolchain
    mkdir -p "$BUILD_DIR"

    echo "================================================================================"
    echo " [1/2] FLOW Pure .lean Synthesis: $LEAN_SRC"
    echo "================================================================================"
    "$FLOWC" "$LEAN_SRC" \
        -o "$BUILD_DIR/flow_business.c" \
        --target-c-header "$BUILD_DIR/flow_business.h" \
        --target-rust "$BUILD_DIR/flow_business.rs" \
        --target-python "$BUILD_DIR/flow_business.py" \
        --target-js "$BUILD_DIR/flow_business.js" \
        --target-cuda "$BUILD_DIR/flow_business.cuh" \
        --target-ui "$BUILD_DIR/flow_business_ui.html" \
        --target-lean "$BUILD_DIR/flow_business_cert.lean"

    echo ""
    echo "================================================================================"
    echo " [2/2] Compiling Native QSBR Shared Library & Standalone Binary"
    echo "================================================================================"
    "$CC" -std=c17 -O2 -shared -fPIC -DFLOW_SHARED_LIB -pthread \
        "$BUILD_DIR/flow_business.c" -o "$BUILD_DIR/libflow_business.so" -lm
    "$CC" -std=c17 -O2 -pthread \
        "$BUILD_DIR/flow_business.c" -o "$BUILD_DIR/flow_business_bin" -lm

    echo "  ✓ Native Shared Library : $BUILD_DIR/libflow_business.so"
    echo "  ✓ Standalone Binary     : $BUILD_DIR/flow_business_bin"
    echo "  ✓ C/C++ Header (64B ABI): $BUILD_DIR/flow_business.h"
    echo "  ✓ Rust Zero-Copy Module : $BUILD_DIR/flow_business.rs"
    echo "  ✓ Python Zero-Copy Mod  : $BUILD_DIR/flow_business.py"
    echo "  ✓ JS/Bun FFI Module     : $BUILD_DIR/flow_business.js"
    echo "  ✓ CUDA Host-Stream Hdr  : $BUILD_DIR/flow_business.cuh"
    echo "  ✓ Schema-Driven Web UI  : $BUILD_DIR/flow_business_ui.html"
    echo "  ✓ Lean 4 Certificate    : $BUILD_DIR/flow_business_cert.lean"
}

cmd_test() {
    if [[ ! -f "$BUILD_DIR/libflow_business.so" ]]; then
        cmd_build
    fi

    echo ""
    echo "================================================================================"
    echo " [Test 1/3] Direct Pure .lean Execution via flowy"
    echo "================================================================================"
    "$FLOWY" run "$LEAN_SRC"

    echo ""
    echo "================================================================================"
    echo " [Test 2/3] 1PB Zero-Copy FlowExtentDescriptor & Theorem-Anchored Kernel Test"
    echo "================================================================================"
    python3 -B -c "
import sys
sys.path.insert(0, '$BUILD_DIR')
import flow_business

with flow_business.LinearArray('$BUILD_DIR/libflow_business.so') as eng:
    in_ext = flow_business.FlowExtentDescriptor(base_offset=0, byte_length=(1 << 50), qsbr_epoch=0, stride_bytes=64, align_bytes=8, schema_version=1, flags=0)
    out_ext = eng.process_descriptor(in_ext)
    assert out_ext.base_offset == (1 << 50) and out_ext.stride_bytes == 64 and out_ext.qsbr_epoch >= 1

    bad_ext = flow_business.FlowExtentDescriptor(base_offset=0, byte_length=64, qsbr_epoch=0, stride_bytes=32, align_bytes=8, schema_version=1, flags=0)
    rejected = False
    try:
        eng.process_descriptor(bad_ext)
    except RuntimeError:
        rejected = True
    assert rejected, 'Expected theorem-anchored flowBusinessStepKernel to reject stride_bytes=32 < 64'

print('  ✓ 1PB Zero-Copy Extent & QSBR Epoch Lease Verified (stride=64B -> PASS, stride=32B -> REJECTED)')
"

    echo ""
    python3 -B "$ROOT_DIR/dashboard/server.py" --selftest

    echo ""
    echo "================================================================================"
    echo "  ALL FLOW BUSINESS PURE .LEAN, OWNERSHIP & DASHBOARD VERIFICATIONS PASSED!"
    echo "================================================================================"
}

cmd_dashboard() {
    if [[ ! -f "$BUILD_DIR/libflow_business.so" ]]; then
        cmd_build
    fi
    python3 -B "$ROOT_DIR/dashboard/server.py" "${2:-8090}"
}

cmd_clean() {
    rm -rf "$BUILD_DIR"
    echo "Cleaned $BUILD_DIR"
}

ACTION="${1:-all}"
case "$ACTION" in
    all)
        cmd_build
        cmd_test
        ;;
    build)
        cmd_build
        ;;
    test)
        cmd_test
        ;;
    dashboard)
        cmd_dashboard "$@"
        ;;
    clean)
        cmd_clean
        ;;
    *)
        echo "Usage: $0 {all|build|test|dashboard|clean}" >&2
        exit 1
        ;;
esac
