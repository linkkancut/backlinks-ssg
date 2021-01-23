# ----------------------------------------------------------------------
# VARIABLES

# abs path of where the notes are
MARKDOWN_FILES_LOCATION=/home/arjun/.nb/notes

# relative path of the temp folder where the .backlinks files will go
# can also as a generic temp folder since it gets cleaned after every
# build (e.g. for index.html file generation)
TEMP_FOLDER=temp

# relative path of the folder where the html files will go
HTML_FOLDER=html

# ----------------------------------------------------------------------

all: \
	clean \
	install \
	generate-backlinks \
	generate-index \
	pandoc-conversion \
	copy-css-and-js \
	server

clean:
	rm -rfv "$(TEMP_FOLDER)"
	rm -rfv "$(HTML_FOLDER)"

install:
	@bin/install.sh

generate-backlinks:
	@venv/bin/python bin/py/generate_backlinks_files.py \
		"$(MARKDOWN_FILES_LOCATION)" \
		"$(TEMP_FOLDER)"

generate-index:
	@venv/bin/python bin/py/generate_index_file.py \
		"$(TEMP_FOLDER)" \
		"$(MARKDOWN_FILES_LOCATION)"

pandoc-conversion:
	@bin/pandocify.sh \
		"$(MARKDOWN_FILES_LOCATION)" \
		"$(TEMP_FOLDER)" \
		"$(HTML_FOLDER)"

copy-css-and-js:
	@mkdir -p "$(HTML_FOLDER)/css"
	@cp -vu bin/css/*.css "$(HTML_FOLDER)/css"
	@mkdir -p "$(HTML_FOLDER)/js"
	@cp -vu bin/js/*.js "$(HTML_FOLDER)/js"

server:
	python3 -m http.server --directory "$(HTML_FOLDER)"
