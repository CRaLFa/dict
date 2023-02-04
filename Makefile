SRC_DIR := /usr/local/src/dict
BIN_DIR := /usr/local/bin

.PHONY: all install clean

all: clean dictionary.sh gene.txt

gene.txt:
	@ echo 'Downloading dictionary data...'
	@ curl -sS http://www.namazu.org/~tsuchiya/sdic/data/gene95.tar.gz \
		| tar xzOf - gene.txt \
		| iconv -c -f SHIFT_JIS -t UTF-8 > ./gene.txt
	@ echo 'Downloaded: ./gene.txt'

install:
	@ mkdir -p $(SRC_DIR)
	@ install -t $(SRC_DIR) ./dictionary.sh ./gene.txt
	@ ln -sf $(SRC_DIR)/dictionary.sh $(BIN_DIR)/dict
	@ echo 'Installation completed.'

clean:
	$(RM) ./gene.txt
