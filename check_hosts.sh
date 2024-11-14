#!/bin/bash
dns_server="8.8.8.8"
cat /etc/hosts | while read a b; do
        if [ "$a" != "#" ]; then
        flag=0
        if [ "$b" == 'localhost' ]; then
                continue
        fi
        nslookup "$b" 8.8.8.8 | while read x y; do
                if [ "$flag" -eq 1 ]; then
                        actual_ip="$y"
                        if [ "$actual_ip" != "$a" ]; then
                                echo "Bogus IP for $b in /etc/hosts!"
                        fi
                        break
                fi
                if [ "$y" == "$b" ]; then
                        flag=1
                        continue
                fi
        done
        fi

done
