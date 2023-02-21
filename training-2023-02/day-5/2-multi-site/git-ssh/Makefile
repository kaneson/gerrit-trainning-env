include ../common/docker-compose.mk

id_rsa.pub:
	cp ../common/gerrit/id_rsa.pub $@

build: id_rsa.pub
	docker build -t nokia/git-ssh:$(DESCRIBE_HEAD) .
