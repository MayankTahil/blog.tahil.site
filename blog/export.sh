hexo server -p 80 --silent 

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