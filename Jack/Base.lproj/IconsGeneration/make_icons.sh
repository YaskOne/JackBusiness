echo "============= MAKE IMAGES ==============="
echo "Script Directory : "
pwd

SOURCE="images"
TARGET="assets"
DIR_PER_RES="1"
REMOVE_PREVIOUS_ASSETS="1"
MAX_RES="3"

./generate_images.sh -f $SOURCE -t $TARGET -r $MAX_RES -d $DIR_PER_RES -x $REMOVE_PREVIOUS_ASSETS

echo "============= IMAGES GENERATED ==============="
echo "WILL COPY TO '$SRCROOT/$PROJECT_NAME/Assets'"

mkdir "$SRCROOT/$PROJECT_NAME/Assets"

cp -R $TARGET "$SRCROOT/$PROJECT_NAME/Assets"
