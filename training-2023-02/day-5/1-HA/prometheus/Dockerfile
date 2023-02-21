FROM prom/prometheus:v2.39.1
ADD prometheus.yml /etc/prometheus/
COPY --chown=root entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/env"]
CMD ["sh","/entrypoint.sh"]
