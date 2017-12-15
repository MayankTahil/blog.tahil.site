rm -rf public
wget --recursive \
		--no-clobber \
		--page-requisites \
		--html-extension \
		--convert-links \
		--restrict-file-names=windows \
		--random-wait \
		--domains $1 \
		--no-parent $1
mv $1 public