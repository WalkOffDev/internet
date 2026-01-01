#!/bin/sh

#export GITHUB_TOKEN="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"

if [ -d /opt ] && [ -w /opt ]; then
  WORKDIR=/opt/tmp/nfqws-keenetic/strategy/zapret
else
  WORKDIR=/tmp/nfqws-keenetic/strategy/zapret
fi

cd ~
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || { echo "cant cd to $WORKDIR"; exit 1; }

RELEASE_URL="$(
  curl -fsSL \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/bol-van/zapret/releases/latest |
  grep -oE '"browser_download_url":\s*"[^"]+embedded\.tar\.gz"' |
  head -n1 | cut -d '"' -f 4
)"

echo "Downloading to $WORKDIR"
curl -fSL --retry 3 --retry-delay 2 -o zapret.tar.gz "$RELEASE_URL"
tar -xzf zapret.tar.gz

cd zapret-*/

./install_bin.sh
SECURE_DNS=1 FWTYPE=iptables SKIP_TPWS=1 ./blockcheck.sh
