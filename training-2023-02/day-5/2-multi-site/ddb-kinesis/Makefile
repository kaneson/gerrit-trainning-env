DESCRIBE_HEAD=$(shell git describe --always HEAD)

up:
	docker-compose -p kinesis up -d;

down:
	docker-compose -p kinesis down;

ps:
	DESCRIBE_HEAD=${DESCRIBE_HEAD} docker-compose kinesis ps

# Call as `make NODE=2 logs` to see the logs for that node
logs:
	DESCRIBE_HEAD=${DESCRIBE_HEAD} docker-compose kinesis logs -f
