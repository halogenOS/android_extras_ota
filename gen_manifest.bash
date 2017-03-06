#!/bin/bash

function write_xml(){
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  echo "<ROM>"
  echo "<RomName>$product</RomName>"
  echo " <VersionName><![CDATA[ $version ]]></VersionName>"
  echo "<VersionNumber type=\"integer\">"$(date +%Y%m%d)"</VersionNumber>"
  echo "<DirectUrl>http://halogenos.org/upload/ROM/7/$device/"$version".zip</DirectUrl>"
  echo "<HttpUrl>http://halogenos.org/upload/ROM/7/?dir=$device</HttpUrl>"
  echo "<Android>$android</Android>"
  echo "<CheckMD5>"$(md5sum $OUT/$version.zip | awk '{print $1}')"</CheckMD5>"
  echo "<FileSize type=\"integer\">"$(stat --printf="%s" $OUT/$version.zip)"</FileSize>"
  echo "<Developer>$MAINTAINER</Developer>"
  echo "<WebsiteURL nil=\"true\">halogenOS.org</WebsiteURL>"
  echo "<DonateURL nil=\"true\">halogenOS.org/donate</DonateURL>"
  echo "  <Changelog>$CHANGELOG</Changelog>"
  echo "</ROM>"
}
version="$XOS_VERSION"
device=$(echo $version | cut -d _ -f 2)
android=$(echo $version | cut -d _ -f 3)
product=${version%_*}
product=${product%_*}
date=$(echo $version | cut -d _ -f 3 | cut -d . -f 1)
write_xml > $product.xml
git add -A
git commit -m "$version"
git push gerrit HEAD:refs/for/XOS-7.1/ota-updates
