echo "============= MAKE ICONS ==============="
echo "Script Directory : "
pwd

./generate_app_icons.sh JackAppIcon.png AppIcons

cp Contents.json AppIcons/

rm -R "../Jack/Assets.xcassets/AppIcon.appiconset"

cp -R AppIcons "../Jack/Assets.xcassets/AppIcon.appiconset"

mv "../Jack/Assets.xcassets/AppIcons" "../Jack/Assets.xcassets/AppIcon.appiconset"
