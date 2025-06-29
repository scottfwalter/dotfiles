#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Extracts the first image reference in ![[filename]] format from markdown content
 * @param {string} content - The markdown content
 * @returns {string|null} - The extracted filename or null if not found
 */
function extractFirstImageReference(content) {
    const imageRegex = /!\[\[([^\]]+)\]\]/;
    const match = content.match(imageRegex);
    return match ? match[1] : null;
}

/**
 * Parses front matter from markdown content
 * @param {string} content - The markdown content
 * @returns {object} - Object containing frontMatter, content, and hasFrontMatter flag
 */
function parseFrontMatter(content) {
    const frontMatterRegex = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/;
    const match = content.match(frontMatterRegex);
    
    if (match) {
        return {
            frontMatter: match[1],
            content: match[2],
            hasFrontMatter: true
        };
    }
    
    return {
        frontMatter: '',
        content: content,
        hasFrontMatter: false
    };
}

/**
 * Updates or adds coverFilename property to front matter
 * @param {string} frontMatter - The front matter content
 * @param {string} coverFilename - The cover filename to set
 * @returns {string} - Updated front matter
 */
function updateFrontMatter(frontMatter, coverFilename) {
    const lines = frontMatter.split('\n');
    let coverLineIndex = -1;
    
    // Look for existing coverFilename property
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].trim().startsWith('coverFilename:')) {
            coverLineIndex = i;
            break;
        }
    }
    
    const newCoverLine = `coverFilename: "[[${coverFilename}]]"`;
    
    if (coverLineIndex >= 0) {
        // Update existing property
        lines[coverLineIndex] = newCoverLine;
    } else {
        // Add new property
        lines.push(newCoverLine);
    }
    
    return lines.join('\n');
}

/**
 * Processes a single markdown file
 * @param {string} filePath - Path to the markdown file
 */
function processMarkdownFile(filePath) {
    try {
        const relativePath = path.relative(process.cwd(), filePath);
        console.log(`Processing: ${relativePath}`);
        
        const content = fs.readFileSync(filePath, 'utf8');
        const imageFilename = extractFirstImageReference(content);
        
        if (!imageFilename) {
            console.log(`  No image reference found in ${relativePath}`);
            return;
        }
        
        console.log(`  Found image reference: ${imageFilename}`);
        
        const parsed = parseFrontMatter(content);
        let updatedFrontMatter;
        
        if (parsed.hasFrontMatter) {
            updatedFrontMatter = updateFrontMatter(parsed.frontMatter, imageFilename);
        } else {
            updatedFrontMatter = `coverFilename: "[[${imageFilename}]]"`;
        }
        
        const newContent = `---\n${updatedFrontMatter}\n---\n${parsed.content}`;
        
        fs.writeFileSync(filePath, newContent, 'utf8');
        console.log(`  Updated ${relativePath} with coverFilename: "[[${imageFilename}]]"`);
        
    } catch (error) {
        console.error(`Error processing ${filePath}:`, error.message);
    }
}

/**
 * Recursively finds all markdown files in a directory and its subdirectories
 * @param {string} dir - Directory to search
 * @param {string[]} fileList - Accumulator for found files
 * @returns {string[]} - Array of markdown file paths
 */
function findMarkdownFiles(dir, fileList = []) {
    try {
        const files = fs.readdirSync(dir);
        
        files.forEach(file => {
            const filePath = path.join(dir, file);
            const stat = fs.statSync(filePath);
            
            if (stat.isDirectory()) {
                // Recursively search subdirectories
                findMarkdownFiles(filePath, fileList);
            } else if (file.toLowerCase().endsWith('.md') || file.toLowerCase().endsWith('.markdown')) {
                fileList.push(filePath);
            }
        });
        
    } catch (error) {
        console.error(`Error reading directory ${dir}:`, error.message);
    }
    
    return fileList;
}

/**
 * Main function to process all markdown files in the current directory and subdirectories
 */
function main() {
    const currentDir = process.cwd();
    console.log(`Scanning for markdown files in: ${currentDir} (including subdirectories)`);
    
    try {
        const markdownFiles = findMarkdownFiles(currentDir);
        
        if (markdownFiles.length === 0) {
            console.log('No markdown files found in the current directory or subdirectories.');
            return;
        }
        
        console.log(`Found ${markdownFiles.length} markdown file(s):`);
        markdownFiles.forEach(file => {
            const relativePath = path.relative(currentDir, file);
            console.log(`  - ${relativePath}`);
        });
        console.log('');
        
        markdownFiles.forEach(file => {
            processMarkdownFile(file);
        });
        
        console.log('\nProcessing complete!');
        
    } catch (error) {
        console.error('Error scanning directories:', error.message);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    main();
}