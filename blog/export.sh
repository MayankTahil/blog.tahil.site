hexo server -p 80 > output.log 2>&1 &

rm -rf public
wget --recursive \
		--no-clobber \
		--page-requisites \
		--html-extension \
		--convert-links \
		--restrict-file-names=windows \
		--random-wait \
		--domains localhost \
		--no-parent localhost
mv localhost public