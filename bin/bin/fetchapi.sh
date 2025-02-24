#!/usr/bin/env node

console.log('hello');

const token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImN4b25lLWF0cy0yMjAxMDEtdWgifQ.eyJyb2xlIjp7ImxlZ2FjeUlkIjoiQWRtaW5pc3RyYXRvciIsImlkIjoiMTFlN2YwYjMtMDFkZS1jYjgwLWE4NDItMDI0MmFjMTEwMDAyIiwibGFzdFVwZGF0ZVRpbWUiOjE3Mzk4NTk1NDgwMDAsInNlY29uZGFyeVJvbGVzIjpbXX0sInZpZXdzIjp7fSwiaWNTUElkIjoiMTAwMDIiLCJpY0FnZW50SWQiOiIxOTAzIiwic3ViIjoidXNlcjoxMWU5OTM2YS1mZmU4LTIwOTAtOGM0Yi0wMjQyYWMxMTAwMDUiLCJpc3MiOiJodHRwczovL2F1dGguZGV2Lm5pY2UtaW5jb250YWN0LmNvbSIsImdpdmVuX25hbWUiOiJBc2hhZGVlcGEiLCJhdWQiOiIwYjY5N2ViYi00ZWEyLTQwNTItYjEyYi1kM2NmMTJhNTNlY2FAY3hvbmUiLCJpY0JVSWQiOjQ0NTMsIm5hbWUiOiJwZXJtX2FzaGFfdGVzdEBtYWlsaW5hdG9yLmNvbSIsInRlbmFudElkIjoiMTFlN2YwYjItZmVlNi03MzEwLTgwNjgtMDI0MmFjMTEwMDA0IiwiZmFtaWx5X25hbWUiOiJEZWJuYXRoIFJlYWwiLCJ0ZW5hbnQiOiJwZXJtX3ByYW5hdl9kbzMyIiwiaWNDbHVzdGVySWQiOiJETzMyIiwic2VjdXJpdHlDb250ZXh0SWQiOiJiNDhhNzlhZmMxYTMxZjk4OTU5ODFiZjFlNWZkYjdjZTg3NmFhYTljMDczNjZiNmNjODMxMWNkZjczYWU5M2Q4IiwiaWF0IjoxNzQwNDM5MDUyLCJleHAiOjE3NDA0NDI2NTJ9.bTlb4i4u64yFRpE9aPPvVXHWnk4Xvtl2oJ7v86HLWRlwMRWA2r8CmuA27jkGG0PkvsJnFRK5s0QCMhbuH6PQbQQWjIwgbKc3lgJEGk-kmHU8mDESl91bYvAGZUx6NiETv6pBQoRp-LtYlMRfJ6bGYf0BP-ZrVoSeHShPTSpoNqk';

fetch('https://api-na1.dev.niceincontact.com/notifications/clientNotifications/v2/notifyAllClients', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify([
    {
      "notificationTemplate": "PUBLISH_CUSTOMER_SNOWFLAKE_ACCOUNT_SUCCESS",
      "recipientsUUIDs": [
        "11e9936a-ffe8-2090-8c4b-0242ac110005"
      ],
      "publisher": "11edab66-16cb-9cd0-9c83-0242ac110003",
      "parameters": {
        "URL_PARAMS": "test421",
        "#D#DATE": "2021-09-29T10:15:30+01:00"
      },
      "isRealTime": false,
      "notificationTargetType": "IN_APP",
      "notificationType": "IN_APP",
      "notificationURI": "DL_DATA_SHARE_CXONE_SNOWFLAKE_ACCOUNT"
    }
  ])
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error('Error:', error));

