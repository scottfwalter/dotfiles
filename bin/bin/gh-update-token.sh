#!/usr/bin/env node
const { execSync } = require("child_process");
const readline = require("readline");

function getPosition(string, subString, index) {
  return string.split(subString, index).join(subString).length;
}

function updateToken(username, token, currentRemoteURL) {
    let part1;
    let part2;
    let fullURL;

    if (username) {
        const pos1 = getPosition(currentRemoteURL, '/', 2);
        part1 = currentRemoteURL.substring(0, pos1 + 1);
        part2 = currentRemoteURL.substring(pos1 + 1);

        fullURL = `${part1}${username}:${token}@${part2}`
    } else {
        const colonCount = (currentRemoteURL.match(/:/g) || []).length;
        const pos1 = colonCount === 1 ? currentRemoteURL.indexOf('@') -1 : getPosition(currentRemoteURL, ':', 2);
        part1 = currentRemoteURL.substring(0, colonCount === 1 ? pos1 + 1: pos1 + 1);

        const pos2 = colonCount === 1 ? pos1 + 1 : getPosition(currentRemoteURL, '@github.com', 1);
        part2 = currentRemoteURL.substring(pos2);

        fullURL = `${part1}${colonCount === 1 ? ':' : ''}${token}${part2}`
    }

    const gitCommand = `git remote set-url origin ${fullURL}`
    console.log(gitCommand);
    const gitCommandResults = execSync(gitCommand).toString();
    console.log(gitCommandResults);
}


const currentRemoteURL = execSync("git config --get remote.origin.url").toString();
const needUserName = currentRemoteURL.indexOf('@github') < 0;

console.log('NNED', currentRemoteURL, currentRemoteURL.indexOf('@github'));

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

if (needUserName) {
    rl.question("Username ? ", function(userName) {
        rl.question("New Token ? ", function(token) {
            rl.close();
            updateToken(userName, token, currentRemoteURL);
        });
    });
} else {
        rl.question("New Token ? ", function(token) {
            rl.close();
            updateToken(undefined, token, currentRemoteURL);
        });

}

//rl.on("close", function() {
// });


