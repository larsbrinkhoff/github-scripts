since=0

while :; do
    curl -D HDR "https://api.github.com/organizations?since=$since" > TMP
    since=`awk 'BEGIN { FS="[=>]" }  /^Link/ { print $2 }' < HDR`
    echo $since
    grep login TMP
    cat TMP >> github-orgs
    
    # Limited to 60 requests per hour
    sleep 60
done
