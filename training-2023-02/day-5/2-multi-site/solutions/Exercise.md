# Gerrit multi-site

* Gerrit UK: `http://localhost:8080/`
* Gerrit KR: `http://localhost:8081/`

* Show all containers

```shell
➜  2-multi-site git:(master) ✗ docker ps
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                            PORTS                                                                     NAMES
c965c59608a0   grafana/grafana:8.2.2                   "/run.sh"                4 seconds ago   Up 3 seconds                      0.0.0.0:3000->3000/tcp                                                    grafana
9e512b974da0   prom/prometheus:v2.30.3                 "/bin/prometheus --c…"   4 seconds ago   Up 3 seconds                      0.0.0.0:9090->9090/tcp                                                    prometheus
67ffad26252a   nokia/gerrit:3.6.2-da39a3ee5e6b4b0d3255   "/bin/sh -c /usr/loc…"   5 seconds ago   Up 3 seconds                      0.0.0.0:8081->8080/tcp, 0.0.0.0:29419->29418/tcp                          review-kr
b3734c7ba411   nokia/git-daemon:13fa91b                  "/bin/sh -c 'git dae…"   5 seconds ago   Up 4 seconds                                                                                                git-daemon-kr
49294a1e6a27   nokia/git-ssh:13fa91b                     "/entry.sh /bin/sh -…"   5 seconds ago   Up 4 seconds                      22/tcp                                                                    ssh-kr
e0cc977f83c0   nokia/gerrit:3.6.2-da39a3ee5e6b4b0d3255   "/bin/sh -c /usr/loc…"   6 seconds ago   Up 4 seconds                      0.0.0.0:8080->8080/tcp, 0.0.0.0:29418->29418/tcp                          review-uk
f183e3cb21ce   nokia/git-daemon:13fa91b                  "/bin/sh -c 'git dae…"   6 seconds ago   Up 5 seconds                                                                                                git-daemon-uk
48abe61468f8   nokia/git-ssh:13fa91b                     "/entry.sh /bin/sh -…"   6 seconds ago   Up 4 seconds                      22/tcp                                                                    ssh-uk
dfca9402ed07   localstack/localstack:0.14.5            "docker-entrypoint.sh"   6 seconds ago   Up 5 seconds (health: starting)   0.0.0.0:4566->4566/tcp, 4510-4559/tcp, 5678/tcp, 0.0.0.0:4751->4751/tcp   kinesis-kinesis-1
```

* Show tables in DDB:

```shell
> export AWS_PAGER=;aws --endpoint-url=http://localhost:4566 dynamodb list-tables
{
    "TableNames": [
        "locks",
        "refsDb",
        "review-kr-gerrit_batch_index",
        "review-kr-gerrit_cache_eviction",
        "review-kr-gerrit_index",
        "review-kr-gerrit_list_project",
        "review-kr-gerrit_stream",
        "review-kr-gerrit_web_session",
        "review-uk-gerrit_batch_index",
        "review-uk-gerrit_cache_eviction",
        "review-uk-gerrit_index",
        "review-uk-gerrit_list_project",
        "review-uk-gerrit_stream",
        "review-uk-gerrit_web_session"
    ]
}
```

* Show Kinesis tables:

```shell
export AWS_PAGER=;aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name review-kr-gerrit_list_project
{
    "Items": [
        {
            "checkpoint": {
                "S": "TRIM_HORIZON"
            },
            "endingHashKey": {
                "S": "340282366920938463463374607431768211455"
            },
            "leaseCounter": {
                "N": "249"
            },
            "ownerSwitchesSinceCheckpoint": {
                "N": "0"
            },
            "checkpointSubSequenceNumber": {
                "N": "0"
            },
            "leaseKey": {
                "S": "shardId-000000000000"
            },
            "leaseOwner": {
                "S": "klc-worker-review-kr-gerrit_list_project"
            },
            "startingHashKey": {
                "S": "0"
            }
        }
    ],
    "Count": 1,
    "ScannedCount": 1,
    "ConsumedCapacity": null
}
```

* Show `websession_log` (then login)

```shell
tail -f review-*/gerrit-logs/websession_log

[2022-11-01 09:02:30,267] [kinesis-producer-callback-executor-0] INFO  : PUBLISH gerrit_web_session { "operation":"ADD", "key":"aSceprsuBm78kostP1NQESSZ-PeowRcNZG", "eventCreatedOn":1667293350 } { "accountId":1000000, "expiresAt":1667336550132 }

==> review-kr/gerrit-logs/websession_log <==
[2022-11-01 09:02:31,245] [ShardRecordProcessor-0001] INFO  : CONSUME gerrit_web_session { "operation":"ADD", "key":"aSceprsuBm78kostP1NQESSZ-PeowRcNZG", "eventCreatedOn":1667293350 } { "accountId":1000000, "expiresAt":1667336550132 }
```

* Show `message_log` (then create a repo)
```shell
tail -f review-*/gerrit-logs/message_log
```

* Show messaged cycle:

```shell
> grep "refs/changes/01/1/meta" review-*/gerrit-logs/message_log | grep -e '"type":".*",' -o
"type":"ref-replication-scheduled",
"type":"ref-updated",
"type":"ref-replicated",
"type":"ref-replication-done",
```

* Create repository in UK site
* Send traffic to UK site (`git-traffic`):

```shell
while true;
    do git checkout -f origin/master;
    for i in $(seq 1 $(( ( RANDOM % 5 )  + 5 )));
        do  base64 /dev/urandom | head -c $(( ( RANDOM % 10000000 )  + 100000 )) > $RANDOM-$i;
    done;
    git add . && git commit -m "Add file $(date)" && git push origin HEAD:refs/for/master;
    sleep 3;
done;
```

* Show `error_log`
```shell
tail -f review-*/gerrit-logs/error_log
```

* Compare indexes from UI
* Show `refTable` (and then show the equivalent git):

```shell
> export AWS_PAGER=;aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name refsDb
```

```shell
> export AWS_PAGER=;aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name refsDb  --filter-expression 'begins_with(refPath,:r)' --expression-attribute-values '{":r": {"S": "/testrepo/refs/changes/01/1/meta"}}'

{
    "Items": [
        {
            "refValue": {
                "S": "234dea09ba0255e8bebbdcc8b445f326e54216cb"
            },
            "refPath": {
                "S": "/testrepo/refs/changes/01/1/meta"
            }
        }
    ],
    "Count": 1,
    "ScannedCount": 15,
    "ConsumedCapacity": null
}
```

* Show Kinesis checkpoint advanced:

```shell
export AWS_PAGER=;aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name review-kr-gerrit_index

{
    "Items": [
        {
            "checkpoint": {
                "S": "49634767018753957872736668965588299119632534809555763202"
            },
            "endingHashKey": {
                "S": "340282366920938463463374607431768211455"
            },
            "leaseCounter": {
                "N": "1416"
            },
            "ownerSwitchesSinceCheckpoint": {
                "N": "0"
            },
            "checkpointSubSequenceNumber": {
                "N": "0"
            },
            "leaseKey": {
                "S": "shardId-000000000000"
            },
            "leaseOwner": {
                "S": "klc-worker-review-kr-gerrit_index"
            },
            "startingHashKey": {
                "S": "0"
            }
        }
    ],
    "Count": 1,
    "ScannedCount": 1,
    "ConsumedCapacity": null
}
```


