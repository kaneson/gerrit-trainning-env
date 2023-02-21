://aws-gerrit-cf-templates.s3.amazonaws.com/1cbca8e0-86ec-4675-af51-cc555e71bc63/resize.sh

chmod +x resize.sh

./resize.sh

wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
wget https://aws-gerrit-cf-templates.s3.amazonaws.com/1cbca8e0-86ec-4675-af51-cc555e71bc63/training-2023-02.tar.gz
tar xzvf training-2023-02.tar.gz
rm -rf training-2023-02.tar.gz
cd training-2023-02
grep -rL "endpoint-url" * | xargs sed -i "s/localhost/nokia-training-8.gerritforgeaws.com/g"

