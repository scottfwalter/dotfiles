#!/usr/bin/env node

// find . -name "*.md" -type f | sed 's/ /\\ /g' | xargs -I{} obsidian-convert-to-frontmatter.js {} add\;
// find . -name "*.md" -type f | sed 's/ /\\ /g' | xargs -I{} obsidian-convert-to-frontmatter.js {} add\;



const fs = require('fs');
const path = require('path');

// Function to process the file
function processFile(inputFile, outputFile) {
    try {
        // Read the file content
        const content = fs.readFileSync(inputFile, 'utf8');

        // Split the content into lines
        const lines = content.split('\n');

        // Initialize variables to track lines
        const linesWithColon = [];
        const finalLines = [];
        let dashLineCount = 0;
        let secondDashLineIndex = -1;

        // Process each line
        lines.forEach((line, index) => {
            if (line.includes('::')) {
		line = line.replace('::', ': ');
                linesWithColon.push(line);
            } else {
                finalLines.push(line);
                if (line.startsWith('---')) {
                    dashLineCount++;
                    if (dashLineCount === 2) {
                        secondDashLineIndex = finalLines.length - 1;
                    }
                }
            }
        });

        // Insert the lines with "::" before the second "---" line
        if (secondDashLineIndex !== -1) {
            finalLines.splice(secondDashLineIndex, 0, ...linesWithColon);
        } else {
            // If no second "---" line exists, append the lines with "::" at the end
            finalLines.push(...linesWithColon);
        }

        // Join the lines back into a single string
        const modifiedContent = finalLines.join('\n');

        // Write the modified content to the output file
        fs.writeFileSync(outputFile, modifiedContent, 'utf8');
        console.log(`File processed successfully: ${outputFile}`);
    } catch (err) {
        console.error('Error processing file:', err);
    }
}

if (!process.argv[2]) {
	console.error('no file was passed in');
	process.exit(1);
}

if (!process.argv[3]) {
	console.error('no action was passed in');
	process.exit(1);
}

if (!process.argv[4]) {
	console.error('no action details was passed in');
	process.exit(1);
}

console.log('Processing...', process.argv[2]);
console.log('Action...', process.argv[3]);

const inputFile = path.join(process.cwd(), process.argv[2]); // Replace with your input file path
const outputFile = path.join(process.cwd(), process.argv[2]); // Replace with your output file path

//processFile(inputFile, outputFile);
