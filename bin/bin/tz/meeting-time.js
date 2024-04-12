const {utcToZonedTime} = require('date-fns-tz');
const parse =  require('date-fns/parse');
const format = require('date-fns/format');

function formatInTZ(date, timeZone) {
    const zonedDate = utcToZonedTime(date, timeZone);
    const pattern = 'h:mm a';
    const output = format(zonedDate, pattern, { timeZone });
    return output;
}

let parsedDate;

if (process.argv.length >= 3 && process.argv[2] && process.argv[2].length > 0) {
    const timeInput = (process.argv[2] + ' ' + (process.argv[3] ? process.argv[3] : '')).trim();
    // const timeInput = (process.argv[2]).trim();
    parsedDate = parse(`${timeInput}`, 'hh:mm a', new Date());
} else {
    parsedDate = new Date();
    const minutes = (Math.round(parsedDate.getMinutes()/15) * 15) % 60;
    parsedDate.setMinutes(minutes);
}

let output = '';
output += `${formatInTZ(parsedDate, 'America/Boise')} SLC`;
output += ` | ${formatInTZ(parsedDate, Intl.DateTimeFormat().resolvedOptions().timeZone)} Dallas`;
output += ` | ${formatInTZ(parsedDate, 'Asia/Jerusalem')} IL`;
output += ` | ${formatInTZ(parsedDate, 'Asia/Kolkata')} Pune`;

console.log(output);


