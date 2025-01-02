#!/bin/bash

echo -e "Installing npm packages..."

while read p; do
	npm install -g $p
done <./npm-packages.lst
