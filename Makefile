DISTDIR = dist
NAME   	= cookbooks.tar.gz

all: package publish

package:
	berks package ${DISTDIR}/${NAME}

publish:
	git add dist/cookbooks.tar.gz
	git commit -m "[make] packaging cookbooks"
	git push origin master
