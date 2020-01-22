# Demo: Elasticsearch Language Identification

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A demo of the Elasticsearch language identification for search use-cases, using the [WiLI-2018 corpus](https://arxiv.org/abs/1801.07779) (or a corpus of your choosing).

# Setup

## Prerequisites

To run the demo, aside from Elasticsearch, you'll need:

1. [Python 3.x](https://www.python.org/downloads/)
1. Linux/macOS tools: `make` and `wget`

## Elasticsearch

See commands below for details.

1. Download and install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch), v7.6 or higher, with the Basic license (default)
1. Install analysis plugins: [ICU](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-icu.html) `icu`, [Japanese](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-kuromoji.html) `kuromoji`, [Korean](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-nori.html) `nori`, [Chinese](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-smartcn.html) `smartcN`  
1. Install a [German decompounder dictionary](https://github.com/uschindler/german-decompounder)

### Installation Commands

Run the following commands from the base of your Elasticsearch installation.

Analysis plugins:

```bash
bin/elasticsearch-plugin install analysis-icu
bin/elasticsearch-plugin install analysis-kuromoji
bin/elasticsearch-plugin install analysis-nori
bin/elasticsearch-plugin install analysis-smartcn
```

German decompounder dictionaries:

```bash
mkdir -p config/analysis/de
cd config/analysis/de
wget https://raw.githubusercontent.com/uschindler/german-decompounder/master/de_DR.xml
wget https://raw.githubusercontent.com/uschindler/german-decompounder/master/dictionary-de.txt
```

## Environment

Set up the demo environment using `make all`. This will create a Python virtual environment with the required dependencies and download datasets for the demo.

For more details, have a look at the targets in the `Makefile`.

# Demo

The demo contains two scripts: `bin/index` for indexing and `bin/search` for searching. Use the `--help` option to see instructions and available options for each script.

## Indexing

To index documents for the demo, run `bin/index` either with all documents (default) or you can choose to index a subset of the documents. For the purposes of the following examples, we index just the first 10k documents: `bin/index --max 10000`

## Search Examples

### German Decompounding

Due to the way the German language compounds words into larger words, special analysis is required to break them up into constituent parts for searching. Try searching for the term "jahr" (meaning "year") and you will see the results of per-language analysis.

```
# only matching exactly on the term "jahr"
bin/search --strategy default jahr

# matches: "jahr", "jahre", "jahren", "jahrhunderts", etc.
bin/search --strategy per-field jahr
```

### Common Term

Some domains use English or Latin terminology. Trying search for the term "computer".

```
# only matching exactly on the term "computer", but multiple languages are in the results
bin/search --strategy default computer

# matches compound German words as well: "Computersicherheit" (computer security)
bin/search --strategy per-field computer
```

### Non-Latin Scripts

Of course it's easy to see how Latin scripts can work even when just using the default or ICU analyzers. However for non-Latin scripts such as CJK (Chinese/Japanese/Korean), we really don't get any good results. Let's try searching for some common Japanese terms and see how our per-language analysis helps.

```
# standard analyzer gets poor precision and returns irrelevant/non-matching results with "network"/"internet": "网络"
bin/search --strategy default 网络

# ICU and language-specific analysis gets things right, but note the different scores
bin/search --strategy icu 网络
bin/search --strategy per-field 网络
```

### Per-Field or Per-Index

Let's compare the scores of per-field and per-index strategies. Note how sometimes the order is different even if the scores are almost exactly the same. In some cases, this can impact search relevance metrics such as nDCG and precision@k. Choose your strategy accordingly!

```
# English tokens: order unchanged
bin/search --strategy per-field networking
bin/search --strategy per-index networking

# Mixed-use tokens: order differs (last item)
bin/search --strategy per-field university
bin/search --strategy per-index university
```

# License

```
Copyright 2020 Josh Devins, Elastic NV

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
