MODULE_NAME := robocivix

.PHONY: build test clean

clean:
	rm -rf build
	rm -rf dist
	rm -rf $(MODULE_NAME).egg-info
	find . -name .DS_Store -delete
	find . -name "*.pyc" -delete
	
lint:
	python3 -m black .	

sca:
	mypy $(MODULE_NAME)
	bandit -r .

update:
	pipreqs . --force

bumpversion:
	python3 ./ci/bump_version.py

build:
	python3 -m build

uninstall:
	pip3  --disable-pip-version-check uninstall -y $(MODULE_NAME)

devinstall:
	pip3  --disable-pip-version-check install -r requirements.txt
	export SCM_REV=$(shell git rev-parse --short HEAD); \
	pip3  --disable-pip-version-check install -e .

dev: clean uninstall devinstall

SHELL := /bin/bash
test:
	python3 -m unittest discover -v --failfast ./tests

testinstall:
	docker run --rm python /bin/bash -c "pip3  --disable-pip-version-check install $(MODULE_NAME) && hcs profile"

publish:
	twine upload --repository hcs-cli dist/*

install:
	pip3 install $(MODULE_NAME) --no-cache-dir --disable-pip-version-check
wait:
	sleep 30

release: lint sca clean bumpversion build publish 


