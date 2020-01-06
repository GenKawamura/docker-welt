#!/bin/bash

cd $(dirname $0)

echo "Making ELK document ..."
name=tier2_ELK
cd $name
pandoc -s -o $name.tex chapter*.md
pandoc -s -o ../$name.pdf chapter*.md

