#!/bin/sh
# ROCKNIXDS with the dual-screen theme opt-in (JorreFog/ROCKNIXDS#84, #85), then TechDweeb's theme.
# Every download is pinned to a commit. The next ROCKNIXDS update from the menu returns to stock.
set -e

RGDS=5155dd1495677fce117bb9fa584a852840f3c51a        # fork main: v1.6.3 + the opt-in + theme menu (RG DS)
RGDS_PLUS=7fdc6602b7d21720f038e65c5189f8235773764c   # fork plus-beta: v1.6.4-plus + the same (RG DS Plus)
THEME=b4b3c0592f7373195d5a771f9b447f2e16fe7905       # anthonycaccese/techdweeb-es master with the RG DS layout
THEMES=/storage/roms/themes

# The RG DS Plus has 1024x768 panels, the RG DS 640x480 (the same test ROCKNIXDS's installer uses)
w=$(cat /sys/class/drm/card*-DSI-*/modes 2>/dev/null | head -n1 | cut -dx -f1)
REF=$RGDS; [ "${w:-0}" -gt 640 ] && REF=$RGDS_PLUS

cd /storage
rm -rf "ROCKNIXDS-$REF"
curl -fsSL "https://codeload.github.com/agiacalone/ROCKNIXDS/tar.gz/$REF" | tar xz
RGDS_SRC="/storage/ROCKNIXDS-$REF" sh "/storage/ROCKNIXDS-$REF/install.sh"

mkdir -p $THEMES
rm -rf "$THEMES/techdweeb-es" "$THEMES/techdweeb-es-$THEME"
curl -fsSL "https://codeload.github.com/anthonycaccese/techdweeb-es/tar.gz/$THEME" | tar xz -C $THEMES
mv "$THEMES/techdweeb-es-$THEME" "$THEMES/techdweeb-es"
rm -rf "/storage/ROCKNIXDS-$REF"

# Select it (ES saves its settings on exit, so edit them while it is stopped). The launcher adds it to the theme menu.
S=/storage/.config/emulationstation/es_settings.cfg
systemctl stop essway.service
if grep -q '<string name="ThemeSet"' $S; then
    sed -i 's|<string name="ThemeSet" value="[^"]*" />|<string name="ThemeSet" value="techdweeb-es" />|' $S
else
    sed -i 's|</config>|\t<string name="ThemeSet" value="techdweeb-es" />\n</config>|' $S
fi
systemctl start essway.service
echo "Done: TechDweeb's theme is on both screens."
