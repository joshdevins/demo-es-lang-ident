all: clean init data

WILI_DIR = data/WiLI-2018
WILI_ZIP_FILE = wili-2018.zip
WILI_DATA_FILE = x_train.txt

venv/bin/activate:
	rm -rf venv/
	python3 -m venv venv

$(WILI_DIR)/$(WILI_ZIP_FILE):
	mkdir -p $(WILI_DIR)
	wget -O $(WILI_DIR)/$(WILI_ZIP_FILE) https://zenodo.org/record/841984/files/$(WILI_ZIP_FILE)?download=1

$(WILI_DIR)/$(WILI_DATA_FILE): $(WILI_DIR)/$(WILI_ZIP_FILE)
	unzip -d $(WILI_DIR) $<

data: $(WILI_DIR)/$(WILI_DATA_FILE)

.PHONY: clean
clean:
	rm -rf data/ venv/

.PHONY: init
init: venv/bin/activate
	. venv/bin/activate ; \
	pip install -r requirements.txt
