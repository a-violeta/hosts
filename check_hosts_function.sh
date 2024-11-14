#!/bin/bash

dns_server="8.8.8.8"

check_ip() {
    local host="$1"
    local ip="$2"
    local dns="$3"
    local flag=0

    nslookup "$host" "$dns" | while read x y; do
        if [ "$flag" -eq 1 ]; then
            local actual_ip="$y"
            if [ "$actual_ip" != "$ip" ]; then
                echo "Bogus IP for $host in /etc/hosts!"
            fi
            break
        fi
        if [ "$y" == "$host" ]; then
            flag=1
            continue
        fi
    done
}

cat /etc/hosts | while read a b; do
    if [ "$a" != "#" ]; then
        if [ "$b" == 'localhost' ]; then
            continue
        fi

        check_ip "$b" "$a" "$dns_server"
    fi
done
