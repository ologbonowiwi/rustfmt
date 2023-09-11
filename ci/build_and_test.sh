#!/bin/bash

set -euo pipefail

export RUSTFLAGS="-D warnings"
export RUSTFMT_CI=1

# Print version information
rustc -Vv
cargo -V

# Build and test main crate
if [ "$CFG_RELEASE_CHANNEL" == "nightly" ]; then
    cargo build --locked --all-features
else
    cargo build --locked
fi
cargo test

# Build and test other crates
cd config_proc_macro
cargo build --locked
cargo test

cd ../markdown
# Build markdown crate and generate tests
cargo build --locked -F gen-tests
cargo test
