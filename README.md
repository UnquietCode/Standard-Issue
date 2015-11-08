# Standard Issue
Creates, updates, and optionally removes labels from your
GitHub repository's issue tracker to match a predefined
configuration file. This makes it easy to set up a new
repository, or match an existing repository, with your
preferred issue labels.

## Set Up

### Install Dependencies
```bash
gem install json
gem install octokit
```

or with bundler
```bash
bundle install
```

### Configure Labels File
You must create a JSON file mapping label names to their
colors. The name of the file should be `labels.json` or else
you can change the expected file name in the script configuration
section.

Names are case sensitive in the labels file by default. This means that if you capitalize a name in your JSON file, but the name is
lowercase on GitHub, the label will be updated to match.


### Configure Script
The top of the script contains a configuration section listing
the various configuration options. By default, the script operates
in "dry run" mode which makes no API requests, and this can be
disabled by setting the configuration flag.

### Run Script
```bash
ruby run.rb
```
