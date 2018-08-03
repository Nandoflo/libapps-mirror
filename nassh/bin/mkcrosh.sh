#!/bin/bash
# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Pass this an existing Secure Shell zip from (made from ../nassh/bin/mkzip.sh)
# and it'll turn it into a crosh_builtin.zip file.

LIBDOT_DIR="$(dirname -- "$0")/../../libdot"
source "${LIBDOT_DIR}/bin/common.sh"

# Fail on error.
set -e

cd "${BIN_DIR}/.."

mkdir -p ./dist/zip/tmp

"${BIN_DIR}"/mkdeps.sh

# Remove things we don't need for crosh.
export MORE_FILE_PATTERNS_EXCLUDE='
  .*/manifest\.json$
  .*/css/nassh_\(box\|connect_dialog\)\.css$
  .*/html/nassh\(_\(connect_dialog\|google_relay\|popup\)\)?\.html$
  .*/js/nassh_\(agent\|google_relay\|sftp\|stream\).*\.js$
  .*/plugin/.*$
  .*/third_party/google-smart-card/.*$
  .*_tests?\.\(js\|html\)$
  .*/images/.*/icon-fullsize\.png$
  .*/images/\(promo\|screenshot\)-.*\.\(jpg\|png\)$
'

# Create a stub manifest for crosh.
cat <<EOF >./dist/zip/tmp/crosh.json
{
  "name": "crosh",
  "version": "0"
}
EOF
rm -f ./dist/zip/crosh-0.zip
mkzip.sh \
  --nopromote_version --nopromote_channel \
  -s "." -w ./dist/zip/ -m "./dist/zip/tmp/crosh.json"
rm ./dist/zip/tmp/crosh.json

echo
echo "HEY!"
echo "You should update the builtin manifest.json as needed:"
echo "src/chrome/browser/resources/chromeos/crosh_builtin/manifest.json"
