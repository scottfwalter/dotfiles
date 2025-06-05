#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Parse front matter from markdown content
 * @param {string} content - The markdown file content
 * @returns {Object} - Object with frontMatter and body
 */
function parseFrontMatter(content) {
    const frontMatterRegex = /^---\s*\n([\s\S]*?)\n---\s*\n([\s\S]*)$/;
    const match = content.match(frontMatterRegex);
    
    if (!match) {
        return {
            frontMatter: {},
            body: content,
            hasFrontMatter: false
        };
    }
    
    const yamlContent = match[1];
    const body = match[2];
    const frontMatter = parseYaml(yamlContent);
    
    return {
        frontMatter,
        body,
        hasFrontMatter: true
    };
}

/**
 * Simple YAML parser for front matter
 * @param {string} yaml - YAML content
 * @returns {Object} - Parsed object
 */
function parseYaml(yaml) {
    const result = {};
    const lines = yaml.split('\n');
    
    for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('#')) continue;
        
        const colonIndex = trimmed.indexOf(':');
        if (colonIndex === -1) continue;
        
        const key = trimmed.substring(0, colonIndex).trim();
        let value = trimmed.substring(colonIndex + 1).trim();
        
        // Handle quoted strings
        if ((value.startsWith('"') && value.endsWith('"')) || 
            (value.startsWith("'") && value.endsWith("'"))) {
            value = value.slice(1, -1);
        }
        // Handle arrays (simple format)
        else if (value.startsWith('[') && value.endsWith(']')) {
            value = value.slice(1, -1).split(',').map(item => item.trim());
        }
        // Handle booleans
        else if (value === 'true') {
            value = true;
        } else if (value === 'false') {
            value = false;
        }
        // Handle numbers
        else if (!isNaN(value) && !isNaN(parseFloat(value))) {
            value = parseFloat(value);
        }
        
        result[key] = value;
    }
    
    return result;
}

/**
 * Convert object to YAML string
 * @param {Object} obj - Object to convert
 * @returns {string} - YAML string
 */
function objectToYaml(obj) {
    const lines = [];
    
    for (const [key, value] of Object.entries(obj)) {
        if (Array.isArray(value)) {
            lines.push(`${key}: [${value.map(item => `"${item}"`).join(', ')}]`);
        } else if (typeof value === 'string') {
            lines.push(`${key}: "${value}"`);
        } else {
            lines.push(`${key}: ${value}`);
        }
    }
    
    return lines.join('\n');
}

/**
 * Perform the specified action on front matter
 * @param {Object} frontMatter - Current front matter object
 * @param {string} action - Action to perform
 * @param {string} property - Property to operate on
 * @param {string} value - Value for add/update operations
 * @returns {Object} - Updated front matter object
 */
function performAction(frontMatter, action, property, value) {
    const updated = { ...frontMatter };
    
    switch (action.toLowerCase()) {
        case 'add':
            if (!value) {
                throw new Error('Value is required for "add" action');
            }
            updated[property] = value;
            break;
            
        case 'update':
            if (!value) {
                throw new Error('Value is required for "update" action');
            }
            if (!(property in updated)) {
                console.warn(`Warning: Property "${property}" does not exist. Adding it instead.`);
            }
            updated[property] = value;
            break;
            
        case 'delete':
            if (!(property in updated)) {
                console.warn(`Warning: Property "${property}" does not exist.`);
            } else {
                delete updated[property];
            }
            break;
            
        default:
            throw new Error(`Invalid action: ${action}. Valid actions are: add, update, delete`);
    }
    
    return updated;
}

/**
 * Main function
 */
function main() {
    const args = process.argv.slice(2);
    
    // Validate arguments
    if (args.length < 4) {
        console.error('Usage: node frontmatter-editor.js <input-file> <output-file> <action> <property> [value]');
        console.error('');
        console.error('Arguments:');
        console.error('  input-file   - Path to input markdown file');
        console.error('  output-file  - Path to output markdown file');
        console.error('  action       - Action to perform: add, update, delete');
        console.error('  property     - Property name to operate on');
        console.error('  value        - Property value (required for add/update)');
        console.error('');
        console.error('Examples:');
        console.error('  node frontmatter-editor.js input.md output.md add title "My New Title"');
        console.error('  node frontmatter-editor.js input.md output.md update author "John Doe"');
        console.error('  node frontmatter-editor.js input.md output.md delete draft');
        process.exit(1);
    }
    
    const [inputFile, outputFile, action, property, value] = args;
    
    // Validate action
    const validActions = ['add', 'update', 'delete'];
    if (!validActions.includes(action.toLowerCase())) {
        console.error(`Error: Invalid action "${action}". Valid actions are: ${validActions.join(', ')}`);
        process.exit(1);
    }
    
    // Validate value requirement
    if ((action.toLowerCase() === 'add' || action.toLowerCase() === 'update') && !value) {
        console.error(`Error: Value is required for "${action}" action`);
        process.exit(1);
    }
    
    try {
        // Read input file
        if (!fs.existsSync(inputFile)) {
            throw new Error(`Input file does not exist: ${inputFile}`);
        }
        
        const content = fs.readFileSync(inputFile, 'utf8');
        
        // Parse front matter
        const { frontMatter, body, hasFrontMatter } = parseFrontMatter(content);
        
        // Perform action
        const updatedFrontMatter = performAction(frontMatter, action, property, value);
        
        // Reconstruct the file
        let newContent;
        if (Object.keys(updatedFrontMatter).length > 0) {
            const yamlContent = objectToYaml(updatedFrontMatter);
            newContent = `---\n${yamlContent}\n---\n${body}`;
        } else if (hasFrontMatter) {
            // If front matter is now empty but existed before, remove the delimiters
            newContent = body;
        } else {
            // If no front matter existed and we're adding empty front matter
            newContent = content;
        }
        
        // Write output file
        const outputDir = path.dirname(outputFile);
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }
        
        fs.writeFileSync(outputFile, newContent, 'utf8');
        
        console.log(`Successfully ${action}ed property "${property}" in ${inputFile}`);
        console.log(`Output written to: ${outputFile}`);
        
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    main();
}

module.exports = {
    parseFrontMatter,
    performAction,
    objectToYaml,
    parseYaml
};