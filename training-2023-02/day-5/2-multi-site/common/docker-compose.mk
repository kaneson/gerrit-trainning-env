DESCRIBE_HEAD=$(shell git describe --always HEAD)

up:
	IMAGE_TAG=${IMAGE_TAG} DESCRIBE_HEAD=${DESCRIBE_HEAD} docker-compose --env-file setup.env up -d

ps down:
	IMAGE_TAG=${IMAGE_TAG} DESCRIBE_HEAD=${DESCRIBE_HEAD} docker-compose --env-file setup.env $@

logs:
	IMAGE_TAG=${IMAGE_TAG} DESCRIBE_HEAD=${DESCRIBE_HEAD} docker-compose --env-file setup.env logs -f