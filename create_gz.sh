#!%SYSTEMROOT%\Windows\System32\bash.exe
outputSize=0
#function defs
create_GZIPs () {
    cd $1
    #create gzips
    for FILE in *;
    do
    if [[ $(file --mime-type -b "$FILE") == text/plain ]]
    then
    gzip -c $FILE > $FILE.gz;
    size="$(stat -c%s $FILE.gz)"
    echo "Created: " $FILE.gz "Size: " $size
    let "outputSize+=$size"
    fi
    done;
    #move the gzip files
    mv *.gz ../gzip_files
    cd ..
}

#go into dist folder
cd dist
mkdir gzip_files
rm gzip_files/*
#gzip index.html and  call it index.gz
gzip -c index.html > index.gz
size="$(stat -c%s index.gz)"
let "outputSize+=$size"
echo "Created: index.gz Size: " $size 
#move file into gzip_files
mv index.gz gzip_files/
#move into js folder
create_GZIPs "js"
create_GZIPs "css"
echo ".gz files created\n Total Size: " $outputSize "bytes"
