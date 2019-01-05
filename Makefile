.PHONY: website

website:
	-cp $(CHANGELOG) content/changelog.adoc
	hugo
