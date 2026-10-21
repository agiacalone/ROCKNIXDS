#!/bin/sh
# Our ROCKNIXDS fork (upstream plus our fixes, including the dual-screen theme opt-in), then TechDweeb's theme,
# selected.
# Updates from the menu then come from the fork too.
set -e

THEME=cf4a821b8dd5ffefb2fbf0bdb45dce693fabbfbc       # agiacalone/techdweeb-es rgds-showpiece (anthonycaccese/techdweeb-es #6, not merged yet)
THEMES=/storage/roms/themes

# ROCKNIXDS from this fork: its installer picks the release for this handheld (RG DS or RG DS Plus)
curl -fsSL https://raw.githubusercontent.com/agiacalone/ROCKNIXDS/main/install.sh | sh

mkdir -p $THEMES
rm -rf "$THEMES/techdweeb-es" "$THEMES/techdweeb-es-$THEME"
curl -fsSL "https://codeload.github.com/agiacalone/techdweeb-es/tar.gz/$THEME" | tar xz -C $THEMES
mv "$THEMES/techdweeb-es-$THEME" "$THEMES/techdweeb-es"

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
