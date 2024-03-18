#!/usr/bin/env sh
set -e

PUID="${PUID:-101}"
PGID="${PGID:-101}"
export TZ="${TZ:-UTC}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Starting nvchecker with UID $PUID and GID $PGID..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""


# Copy default config files
if [ ! -f "/config/nvchecker.toml" ]; then
    echo "    [+] Configuration not present"
    echo "    [+] Creating default configuration at /config/nvchecker.toml"
    cp /defaults/nvchecker.toml /config/nvchecker.toml
fi
if [ ! -f "/config/new_ver.json" ]; then
    echo "    [+] Creating empty new_ver file at /config/new_ver.json"
    cp /defaults/new_ver.json /config/new_ver.json
fi
if [ ! -f "/config/old_ver.json" ]; then
    echo "    [+] Creating empty old_ver file at /config/old_ver.json"
    cp /defaults/old_ver.json /config/old_ver.json
fi

# Set UID/GID of nvchecker user
sed -i "s/^nvchecker\:x\:101\:101/nvchecker\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^nvchecker\:x\:101/nvchecker\:x\:$PGID/" /etc/group

# Set permissions
chown -R $PUID:$PGID /config

echo ""
exec "$@"
