#!/bin/sh
set -e

echo "Starting the Jekyll Action"

if [ -z "${JEKYLL_PAT}" ]; then
  echo "No token provided. Please set the JEKYLL_PAT environment variable."
  exit 1
fi 

# Checkout the existing static content
repo_url="https://${JEKYLL_PAT}@github.com/${GITHUB_REPOSITORY}.git"
git config --global user.name "${GITHUB_ACTOR}" && \
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git clone $repo_url build
cd build
git checkout gh-pages
cd ..

echo "::debug ::Starting bundle install"
bundle config path vendor/bundle
bundle install
echo "::debug ::Completed bundle install"

if [ -n "${INPUT_JEKYLL_SRC}" ]; then
  JEKYLL_SRC=${INPUT_JEKYLL_SRC}
  echo "::debug ::Using parameter value ${JEKYLL_SRC} as a source directory"
elif [ -n "${SRC}" ]; then
  JEKYLL_SRC=${SRC}
  echo "::debug ::Using SRC environment var value ${JEKYLL_SRC} as a source directory"
else
  JEKYLL_SRC=$(find . -path ./vendor/bundle -prune -o -name '_config.yml' -exec dirname {} \;)
  echo "::debug ::Resolved ${JEKYLL_SRC} as a source directory"
fi

JEKYLL_ENV=production bundle exec jekyll build -s ${JEKYLL_SRC} -d build
echo "Jekyll build done"

cd build

# No need to have GitHub Pages to run Jekyll
touch .nojekyll

# Is this a regular repo or an org.github.io type of repo
case "${GITHUB_REPOSITORY}" in
  *.github.io) remote_branch="master" ;;
  *)           remote_branch="gh-pages" ;;
esac

if [ "${GITHUB_REF}" = "refs/heads/${remote_branch}" ]; then
  echo "Cannot publish on branch ${remote_branch}"
  exit 1
fi

echo "Publishing to ${GITHUB_REPOSITORY} on branch ${remote_branch}"
echo "::debug ::Pushing to ${repo_url}"

git status && \
git add . && \
git commit -m "jekyll build from Action ${GITHUB_SHA}" && \
git push -u origin $remote_branch && \
rm -fr .git && \
cd .. 

exit $?
