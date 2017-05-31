const express = require('express'),
      path = require('path'),
      fetch = require('isomorphic-fetch'),
      app = express(),
      port = 3000;

// express: Standard server library for Node
// path: Built in Node module for working with filepaths
// isomorphic-fetch: Adds the 'fetch' browser API to Node (for ajax requests)
// app: Sets up an express server for 'app'
// port: What port the server will be open on (Usually its 3000 for local development, 8000 for production servers you will send to other people, and 8080 for cloud platforms)

///////   Api Route: When '/getQuote' is requested, makes a fetch ajax request to the url, then sends the resulting quote, or logs the error to the console (Note: Not the browser console)
app.get('/getQuote', (request, response) => {
  fetch('https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json') // Ajax request
    .then(rawData => rawData.json()) // Convert raw returned string into usable JSON
    .then(quote => response.send(quote)) // Send the Quote
    .catch(error => console.log(error)); // Log the error
});
////////////////////////////////////////////////////////////////////////


///////   Server route: When '/' is requested (the default route when you enter a URL), sends the HTML for the page
app.use('/dist', express.static('dist')); // Serves the dist folder so the HTML file that is sent can use it

app.get('/', (request, response) => {
  response.sendFile(path.join(__dirname, './index.html')); // Send HTML file from computer, __dirname is a variable mapped to whatever the path of the caller is
});
////////////////////////////////////////////////////////////////////////


///////   Initializes server to listen on designated port, then run a callback if necessary
app.listen(port, error => {
  if (error)
    throw error; // Throw an error if the server fails to startup
  console.log('Server open on port ' + port); // Log that the server has been started successfully
});
