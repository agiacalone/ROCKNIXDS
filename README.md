# TechDweeb theme on both screens

This installs [our ROCKNIXDS fork](https://github.com/agiacalone/ROCKNIXDS), which has the dual-screen theme fix
and our other fixes, then [TechDweeb's theme](https://github.com/anthonycaccese/techdweeb-es), and switches to it.

1. On an RG DS or RG DS Plus running ROCKNIX, connect over ssh as `root` (password `rocknix`).
2. Run:

   ```sh
   curl -fsSL https://raw.githubusercontent.com/agiacalone/ROCKNIXDS/techdweeb-preview/install-preview.sh | sh
   ```

Updates from the menu (*Updates & downloads > ROCKNIXDS*) then come from the fork.
