# Fonts/Free download helper

This directory contains a script to download all .ttf and .otf fonts from AungMyoKyaw/Myanmar-Unicode-Fonts into this directory as plain files (no subfolders). Files will be saved with their basename only, as requested.

Run the script below from the repository root to fetch the font files:

```bash
chmod +x Fonts/Free/download_fonts.sh
./Fonts/Free/download_fonts.sh
```

The script uses the GitHub API and raw.githubusercontent.com to fetch files. If you prefer to have the font files committed directly instead of downloading them, tell me and I can copy them in a future commit.
