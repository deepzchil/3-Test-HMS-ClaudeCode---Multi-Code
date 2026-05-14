#!/bin/bash
set -e

ENV=$1
ZIP=$2
BUCKET="doctorsproject-hms"

echo "Uploading $ZIP to $ENV..."

gsutil cp $ZIP gs://$BUCKET/$ENV/

echo "Applying retention policy..."

FILES=$(gsutil ls -l gs://$BUCKET/$ENV/*.zip | sort -k2 | awk '{print $3}')

COUNT=$(echo "$FILES" | wc -l)

if [ "$COUNT" -gt 5 ]; then
  DELETE_COUNT=$((COUNT-5))
  echo "$FILES" | head -n $DELETE_COUNT | xargs -I {} gsutil rm {}
fi