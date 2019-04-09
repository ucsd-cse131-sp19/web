build:
	stack build web
	stack exec web -- clean
	stack exec web -- build

deploy: build
	rm -rf docs/*
	cp -a _site/. docs/
	git add lectures
	got add docs
	git commit -a -m "update page"
	git push origin master
