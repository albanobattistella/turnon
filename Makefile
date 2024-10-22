APPID = de.swsnr.turnon
BLUEPRINTS = $(wildcard ui/*.blp)
UIDEFS = $(addsuffix .ui,$(basename $(BLUEPRINTS)))
CATALOGS = $(wildcard po/*.po)
LOCALEDIR = /app/share/locale/

XGETTEXT_METADATA = \
	--package-name=$(APPID) \
	--copyright-holder "Sebastian Wiesner <sebastian@swsnr.de>"

.PHONY: pot
pot:
	find -name '*.rs' -or -name '*.desktop.in' -or -name '*.metainfo.xml.in' -or -name '*.blp' | sort > po/POTFILES.in
	xgettext $(XGETTEXT_METADATA) --files-from=po/POTFILES.in \
		--add-comments --keyword=_ --keyword=C_:1c,2 \
		--sort-by-file --from-code=UTF-8 --output=po/$(APPID).pot

po/%.mo: po/%.po
	msgfmt --output-file $@ --check $<

.PHONY: msgfmt
msgfmt: $(addsuffix .mo,$(basename $(CATALOGS)))

$(LOCALEDIR)/%/LC_MESSAGES/$(APPID).mo: po/%.mo
	install -Dpm0644 $< $@

.PHONY: install-locale
install-locale: $(addprefix $(LOCALEDIR)/,$(addsuffix /LC_MESSAGES/$(APPID).mo,$(notdir $(basename $(CATALOGS)))))

.PHONY: clean
clean:
	rm -f po/*.mo
