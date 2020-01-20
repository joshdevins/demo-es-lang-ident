# Demo: Elasticsearch Language Identification

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A demo of the Elasticsearch language identification for search use-cases.

# Setup

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

# Running the Demo

The demo contains two scripts: `bin/index` for indexing and `bin/search` for searching. Use the `--help` option to see instructions and available options for each script.

# TODO

Either just as examples in console scripts or in the actual demo:

- Set the top languages above a threshold into a field (for UI faceting/filtering)
- Combine multiple fields into a single field in order to choose the language, and optionally then use it to search over (an `all` field) or just do "language per-field" again
- Map script-common languages into a single field, e.g. mapping Chinese, Japanese, and Korean to `cjk` field and analyzer
- Choose predominant language only if the top class is above a threshold (e.g. 60% or 50%)

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
