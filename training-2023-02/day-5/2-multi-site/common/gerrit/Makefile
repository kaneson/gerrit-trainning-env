include ./setup.env

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
IMAGE_DIR := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

PLUGINS=javamelody healthcheck multi-site events-aws-kinesis websession-broker metrics-reporter-prometheus aws-dynamodb-refdb
PLUGINS_LIBS_LINKS=multi-site replication
MAVEN_LIBS=events-broker~${EVENTSBROKER_LIB_VER} global-refdb~${GLOBALREFDB_LIB_VER}

HEAD_SHA1=$(shell find $(IMAGE_DIR) -type f -exec cat {} \; | shasum | cut -c 1-20)
IMAGE_TAG=$(GERRIT_VERSION).$(GERRIT_PATCH)-$(HEAD_SHA1)

id_rsa:
	ssh-keygen -m PEM -f id_rsa -t rsa -b 2048 -N ''

build: gerrit-get-plugins id_rsa
	cat Dockerfile | \
		GERRIT_VERSION=${GERRIT_VERSION} GERRIT_PATCH=${GERRIT_PATCH} envsubst | \
		docker build -f - -t nokia/gerrit:$(IMAGE_TAG) .

gerrit-get-plugins:
	mkdir -p $(@D)/{plugins,lib}

	@echo "Ensure no plugins or libraries are left from previous deployments"
	rm -f $(@D)/{plugins,lib}/*.jar

	for plugin in $(PLUGINS); \
	do \
		export pluginname=`echo $$plugin | cut -d '~' -f 1`; \
		export pluginjar=`echo $$plugin | tr '~' '-'`; \
		echo "Downloading $$plugin plugin $(GERRIT_BRANCH)"; \
		wget $(GERRIT_CI)/plugin-$$pluginname-bazel-$(GERRIT_BRANCH)/$(LAST_BUILD)/$$pluginname/$$pluginjar.jar \
		-O ./plugins/$$pluginname.jar || \
		wget $(GERRIT_CI)/plugin-$$pluginname-bazel-master-$(GERRIT_BRANCH)/$(LAST_BUILD)/$$pluginname/$$pluginjar.jar \
		-O ./plugins/$$pluginname.jar || \
		{ echo >&2 "Cannot download $$plugin plugin: Check internet connection. Aborting"; exit 1; }; \
	done

	for pluginlib in $(PLUGINS_LIBS_LINKS); \
	do \
		echo "Symlink $$pluginlib plugin into lib"; \
		ln -sf ../plugins/$$pluginlib.jar ./lib/$$pluginlib.jar; \
	done

	for mavenlib in $(MAVEN_LIBS); \
	do \
		echo "Downloading $$mavenlib library"; \
		export libname=`echo $$mavenlib | cut -d '~' -f 1`; \
		export libver=`echo $$mavenlib | cut -d '~' -f 2`; \
		export libjar=`echo $$mavenlib | tr '~' '-'`; \
		wget $(MAVEN_ARCHIVE)/$$libname/$$libver/$$libjar.jar \
			-O ./lib/$$libname.jar \
		|| { echo >&2 "Cannot download $$mavenlib: Check internet connection. Aborting"; exit 1; } \
	done
