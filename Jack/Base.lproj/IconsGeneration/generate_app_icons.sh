#!/bin/sh

ITUNES_ARTWORK="$1"
TARGET="$2"

mkdir "$TARGET"

sips -z 57 57 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon57x57.png"
sips -z 114 114 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon57x57@2x.png"

sips -z 60 60 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon60x60.png"

# Spotlight & Settings

sips -z 29 29 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon29x29.png"
sips -z 58 58 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon29x29@2x.png"
sips -z 87 87 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon29x29@3x.png"

sips -z 20 20 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon20x20.png"
sips -z 40 40 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon20x20@2x.png"
sips -z 60 60 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon20x20@3x.png"

sips -z 40 40 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon40x40.png"
sips -z 80 80 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon40x40@2x.png"
sips -z 120 120 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon40x40@3x.png"



#iPhone 6s, iPhone 6, iPhone SE
sips -z 60 60 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon60x60.png"
sips -z 120 120 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon60x60@2x.png"
#iPhone 6s Plus, iPhone 6 Plus
sips -z 180 180 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon60x60@3x.png"

#iPad, iPad mini
sips -z 76 76 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon76x76.png"
sips -z 152 152 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon76x76@2x.png"

#iPad Pro
sips -z 167 167 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon167x167.png"

#iTunes
sips -z 1024 1024 "$ITUNES_ARTWORK" --out "$TARGET/iTunesArtwork.png"
sips -z 2048 2048 "$ITUNES_ARTWORK" --out "$TARGET/iTunesArtwork@2x.png"

sips -z 50 50 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon50x50.png"
sips -z 100 100 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon50x50@2x.png"
sips -z 72 72 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon72x72.png"
sips -z 144 144 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon72x72@2x.png"
sips -z 160 160 "$ITUNES_ARTWORK" --out "$TARGET/AppIcon80x80@2x.png"
