touch .edit; MISSING=$(find . -type f -name \*.go|grep -v -f .edit); [ -z "${MISSING}" ] || echo "${MISSING}" >> .edit

execute(){
	rm -f golib
	go mod tidy
	go test -v
}
tagversion(){
	# Always increase VERSION
	NEWVERS=$(cat VERSION|awk -F. '{print $1"."$2"."$3+1}')
	echo $NEWVERS>VERSION

	# Always commit
	git add .;
	git commit -m "Changes "$(date +%Y/%m/%d-%H:%M:%S)
	git push

	# Tag
	git tag $(cat VERSION)
	git push origin $(cat VERSION)
}


case "$1" in
 t)	tagversion;
	;;
 e) 	vi -p $(grep -v '^#' .edit) .edit
	execute;
	;;
"")	execute
	;;
esac
