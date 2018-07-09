#!/bin/bash

SOURCE="images"
TARGET="assets"
PREFIX=""
SUFFIX=""
MAXRES=3
DIRS=0
DELETE=0

while getopts ":f:s:r:t:p:d:x:" opt; do
  case $opt in
    f) SOURCE="$OPTARG"
    ;;
    r) MAXRES="$OPTARG"
    ;;
    t) TARGET="$OPTARG"
    ;;
    p) PREFIX="$OPTARG"
    ;;
    s) SUFFIX="$OPTARG"
    ;;
    d) DIRS=1
    ;;
    x) DELETE=1
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo "DIRS : $DIRS";
echo "DELETE : $DELETE";

MAXRES=$((10#$MAXRES))
DELETE=$((10#$DELETE))
DIRS=$((10#$DIRS))

echo "CONVERT .png IMAGES IN FOLDER $SOURCE - Source Res : @x$MAXRES" > generate_images_log.txt;


echo "CREATE TARGET FOLDER assets" >> generate_images_log.txt;

if [ $DELETE -gt 0 ]; then
echo "DELETE";
	rm -d -R "$TARGET" >> generate_images_log.txt;
fi
mkdir "$TARGET" >> generate_images_log.txt;


#NOT WORKING s $1"/*.(png|PNG|jpg|JPG|jpeg|JPEG)"

if [ $MAXRES -gt 5 ]; then
	MAXRES=5;
fi
# MXRES>=5 - xxxhdpi on android

if [ $MAXRES -gt 4 ]; then
	if [ $DIRS -gt 0 ]; then
		DIRFIVE="@5x/";
		mkdir "$TARGET/$DIRFIVE" >> generate_images_log.txt;
	fi
fi

if [ $MAXRES -gt 3 ]; then
	if [ $DIRS -gt 0 ]; then
		DIRFOUR="@4x/";
		mkdir "$TARGET/$DIRFOUR" >> generate_images_log.txt;
	fi
fi

if [ $MAXRES -gt 2 ]; then
	if [ $DIRS -gt 0 ]; then
		DIRTHREE="@3x/";
		mkdir "$TARGET/$DIRTHREE" >> generate_images_log.txt;
	fi
fi

if [ $MAXRES -gt 1 ]; then
	if [ $DIRS -gt 0 ]; then
		DIRTWO="@2x/";
		mkdir "$TARGET/$DIRTWO" >> generate_images_log.txt;
	fi
fi

if [ $DIRS -gt 0 ]; then
	DIRONE="@1x/";
	mkdir "$TARGET/$DIRONE" >> generate_images_log.txt;
fi

for f in $(ls $SOURCE)
do

filename=$(basename $f | sed 's/@2x././g')

name=$(echo $filename | cut -f 1 -d '.')


H=$(sips -g pixelHeight "$SOURCE/$f" | grep 'pixelHeight' | cut -d: -f2)
W=$(sips -g pixelWidth "$SOURCE/$f" | grep 'pixelWidth' | cut -d: -f2)

H20=$(($H / MAXRES))
W20=$(($W / MAXRES))

BASE=${f%.*}

echo "$name :"

## uncomment for x4 and x5 ( android )
##cp "$SOURCE/$f" "$TARGET/$filename@5x.png"
if [ $MAXRES -gt 4 ]; then
	echo "  x5 : $DIRFIVE$PREFIX$name$SUFFIX@5x.png";
	sips -z $(($H20 * 5)) $(($W20 * 4)) "$SOURCE/$f" --out "$TARGET/$DIRFIVE$PREFIX$name$SUFFIX@5x.png" >> generate_images_log.txt;
fi

if [ $MAXRES -gt 3 ]; then
	echo "  x4 : $DIRFOUR$PREFIX$name$SUFFIX@4x.png";
	sips -z $(($H20 * 4)) $(($W20 * 4)) "$SOURCE/$f" --out "$TARGET/$DIRFOUR$PREFIX$name$SUFFIX@4x.png" >> generate_images_log.txt;
fi

if [ $MAXRES -gt 2 ]; then
	echo "  x3 : $DIRTHREE$PREFIX$name$SUFFIX@3x.png";
	sips -z $(($H20 * 3)) $(($W20 * 3)) "$SOURCE/$f" --out "$TARGET/$DIRTHREE$PREFIX$name$SUFFIX@3x.png" >> generate_images_log.txt;
fi

if [ $MAXRES -gt 1 ]; then
	echo "  x2 : $DIRTWO$PREFIX$name$SUFFIX@2x.png";
	sips -z $(($H20 * 2)) $(($W20 * 2)) "$SOURCE/$f" --out "$TARGET/$DIRTWO$PREFIX$name$SUFFIX@2x.png" >> generate_images_log.txt;
fi

	echo "  x1 : $DIRONE$PREFIX$name$SUFFIX.png";
sips -z $H20 $W20 "$SOURCE/$f" --out "$TARGET/$DIRONE$PREFIX$name$SUFFIX.png" >> generate_images_log.txt;

done