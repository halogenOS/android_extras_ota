
#!/bin/bash

case $1 in
  set-maintainer)
    m_device="$2"
    shift 2
    echo -n "$@" > ${m_device}-maintainer.txt
  ;;
  *)

version="$XOS_VERSION"
device=$(echo $version | cut -d _ -f 2)
android=$(echo $version | cut -d _ -f 3)
product=${version%_*}
product=${product%_*}
date=$(echo $version | cut -d _ -f 3 | cut -d . -f 1)

function write_xml() {
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  echo "<ROM>"
  echo "  <RomName>$product</RomName>"
  echo "  <VersionName><![CDATA[ $version ]]></VersionName>"
  echo "  <VersionNumber type=\"integer\">"$(date +%Y%m%d)"</VersionNumber>"
  echo "  <DirectUrl>https://sourceforge.net/projects/halogenos-builds/files/release_builds/$device/${version}.zip/download</DirectUrl>"
  echo "  <HttpUrl>https://halogenos.org/upload/ROM/7/?dir=$device</HttpUrl>"
  echo "  <Android>$android</Android>"
  echo "  <CheckMD5>"$(md5sum $OUT/$version.zip | awk '{print $1}')"</CheckMD5>"
  echo "  <FileSize type=\"integer\">"$(stat --printf="%s" $OUT/${version}.zip)"</FileSize>"
  echo "  <Developer>$MAINTAINER</Developer>"
  echo "  <WebsiteURL nil=\"true\">halogenOS.org</WebsiteURL>"
  echo "  <DonateURL nil=\"true\">halogenOS.org/donate</DonateURL>"
  echo "  <Changelog>$CHANGELOG</Changelog>"
  echo "</ROM>"
}

mkdir -p changelogs
touch changelogs/${version}.txt
changelog_path="$changelog_path"
if [ -z "$changelog_path" ]; then
  changelog_path=changelogs/${version}.txt
  if [ "$DO_NOT_NANO" != "true" ]; then
    nano changelogs/${version}.txt
  fi
fi

CHANGELOG="$(cat $changelog_path)"

if [ -z "$MISTER_MAINTAINER" ]; then
  echo "Tell me your name, mister maintainer: "
  read MISTER_MAINTAINER
fi

echo "Hi, ${MISTER_MAINTAINER}!"

MAINTAINER="$MISTER_MAINTAINER"

write_xml > $product.xml
git add -A
git commit -m "$version"
;;
esac
