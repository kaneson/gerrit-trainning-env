init:
	if ! docker network inspect gerrit-test.uk >/dev/null 2>&1; then \
		docker network create --attachable gerrit-test.uk; \
	fi;
	make -C common/gerrit build
	make -C git-ssh build
	make -C git-daemon build
	make -C ddb-kinesis up
	make -C review-uk up
	while ! curl -s http://nokia-training-8.gerritforgeaws.com:8080/ > /dev/null; do sleep 1; done
	make -C review-uk down
	make -C ddb-kinesis down
	docker network rm gerrit-test.uk
	cp -Rf review-uk/gerrit-{git,data,index,cache,db} review-kr/.

up:
	if ! docker network inspect gerrit-test.uk >/dev/null 2>&1; then \
		docker network create --attachable gerrit-test.uk; \
	fi;
	for component in ddb-kinesis review-uk review-kr monitoring; do make -C $$component up; done

down:
	for component in ddb-kinesis review-uk review-kr monitoring; do make -C $$component down; done
	if docker network inspect gerrit-test.uk >/dev/null 2>&1; then \
		docker network rm gerrit-test.uk; \
	fi;

clean: down
	rm -Rf monitoring/{prometheus,grafana}-data {review-uk,review-kr}/gerrit-{git,data,index,cache,db,etc,logs}/*
