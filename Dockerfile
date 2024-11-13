## Neo4J dependency: dockerfile/java
## get java from trusted build
from openjdk:11
maintainer Tiago Pires, tiago-a-pires@ptinovacao.pt

## install neo4j according to http://www.neo4j.org/download/linux
# Import neo4j signing key
# Create an apt sources.list file
# Find out about the files in neo4j repo ; install neo4j community edition

run mkdir -p /etc/apt/keyrings
run wget -O - https://debian.neo4j.com/neotechnology.gpg.key | gpg --dearmor -o /etc/apt/keyrings/neotechnology.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/neotechnology.gpg] https://debian.neo4j.com stable legacy' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update ; apt-get install neo4j=3.1.3 -y

## add launcher and set execute property
## clean sources
## turn on indexing: http://chrislarson.me/blog/install-neo4j-graph-database-ubuntu
## enable neo4j indexing, and set indexable keys to name,age
# enable shell server on all network interfaces

add launch.sh /
run chmod +x /launch.sh && \
    apt-get clean && \
    sed -i "s|#dbms.allow_format_migration|dbms.allow_format_migration|g" /etc/neo4j/neo4j.conf

# expose REST and shell server ports
expose 7474

workdir /

## entrypoint
cmd ["/bin/bash", "-c", "/launch.sh"]
