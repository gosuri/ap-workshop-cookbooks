DISTDIR = dist
NAME   	= cookbooks.tar.gz

all: package

package: check-berkshelf
	berks package ${DISTDIR}/${NAME}
