#!/bin/bash

# Required packages: curl git jq ruby

if [ -z "$RELEASE_RUBYGEMS_API_KEY" ]; then
  echo No API key specified for publishing to rubygems.org. Stopping release.
  exit 1
fi

export RELEASE_BRANCH=${GITHUB_REF_NAME:-master}
if [ -z "$RELEASE_USER" ]; then
  export RELEASE_USER=${GITHUB_ACTOR:-diguage}
fi
RELEASE_GIT_NAME=$(curl -s https://api.github.com/users/$RELEASE_USER | jq -r .name)
RELEASE_GIT_EMAIL=leejun119@gmail.com
GEMSPEC=$(ls -1 *.gemspec | head -1)
RELEASE_GEM_NAME=$(ruby -e "print (Gem::Specification.load '$GEMSPEC').name")

# RELEASE_VERSION must be an exact version number; if not set, default to the next patch release.
if [ -z "$RELEASE_VERSION" ]; then
  RELEASE_VERSION=$(ruby -e "print (Gem::Specification.load '$GEMSPEC').version.to_s")
fi
export RELEASE_VERSION
export RELEASE_GEM_VERSION=${RELEASE_VERSION/-/.}

# Configure git so the release commit and tag can be created.
git config --local user.name "$RELEASE_GIT_NAME"
git config --local user.email "$RELEASE_GIT_EMAIL"

# Configure the gem command for publishing to RubyGems.
mkdir -p "$HOME/.gem"
echo -e "---\n:rubygems_api_key: $RELEASE_RUBYGEMS_API_KEY" > "$HOME/.gem/credentials"
chmod 600 "$HOME/.gem/credentials"

set -e

ruby tasks/version.rb
git commit -a -m "release $RELEASE_VERSION [no ci]"
git tag -m "version $RELEASE_VERSION" "v$RELEASE_VERSION"
mkdir -p pkg
gem build "$GEMSPEC" -o "pkg/$RELEASE_GEM_NAME-$RELEASE_GEM_VERSION.gem"
git push origin "v$RELEASE_VERSION"
gem push "pkg/$RELEASE_GEM_NAME-$RELEASE_GEM_VERSION.gem"
git push origin "$RELEASE_BRANCH"

rm -rf "$HOME/.gem"
git status -s -b
