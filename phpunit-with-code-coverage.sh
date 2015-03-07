#!/bin/bash
# Run WordPress Core PHPUnit tests for the Customizer with Code Coverage HTML Report
# By Weston Ruter, XWP

set -e

cd "$(dirname $0)"
if [ ! -e ../.git ] || [ ! -e ../wp-tests-config.php ]; then
	echo "Error: Clone the wp-customize-tests directory as a subdirectory of wordpress-develop root."
	exit 1
fi

gh_pages_push=0
while [[ $# > 0 ]]; do
	key="$1"

	case "$key" in
		--push)
		gh_pages_push=1
		;;

		*)
		# unknown option
		;;
	esac
	shift
done

ssh_remote=git@github.com:xwp/wp-customize-tests.git
self_dir="$(pwd)"
gh_pages_dir="$self_dir/coverage-html"

if [ -e ../phpunit.customize.xml ]; then
	rm ../phpunit.customize.xml
fi

echo "Copying phpunit.customize.xml to wordpress-develop root"
cp phpunit.customize.xml ../phpunit.customize.xml

# Go to wordpress-develop root
cd ..

if [ ! -e "$gh_pages_dir/.git" ] && [ "$gh_pages_push" == 1 ]; then
	if [ "$gh_pages_dir" ]; then
		rm -r "$gh_pages_dir"
	fi
	git clone -b gh-pages --single-branch --depth 1 "$ssh_remote" "$gh_pages_dir"
fi

phpunit -c phpunit.customize.xml --coverage-html="$gh_pages_dir"

if [ "$gh_pages_push" == 1 ]; then
	# Commit and push
	cd "$gh_pages_dir"
	git remote set-url origin "$ssh_remote" # SSH so we can use it in Vagrant
	git config user.name = "PHPUnit"
	git config user.email = "phpunit@xwp.co"
	git commit --all --amend -m "Code coverage report"
	if git push -f origin HEAD:gh-pages; then
		echo "Code Coverage report now avalable at http://xwp.github.io/wp-customize-tests/"
	else
		echo "Oops. You do not have the ability to push to $ssh_remote."
	fi
fi
echo "Code coverage report can be seen in: $gh_pages_dir"