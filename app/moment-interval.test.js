const moment = require('moment');

// Given value
const givenValue = moment("2024-04-22 12:19:15").subtract(1, 'day');

// Current time
const currentTime = moment();

// Array to store all dates
const allDates = [];

// Loop through each hour from the given value to current time
while (givenValue.isBefore(currentTime)) {
  allDates.push(givenValue.startOf('hour').format('YYYY-MM-DD HH:mm:ss'));
  givenValue.add(1, 'hour');
}

console.log(allDates);