const express = require('express');
const mongoose = require('mongoose');

// set up express app
const app = express();
const fs = require('fs');
const http = require('http');
const https = require('https');

// Please put MongoDB connection string on ./connectionString.txt
const connectionString = fs.readFileSync('./connectionString.txt', 'utf8')

// get local ip
var os = require('os');
var interfaces = os.networkInterfaces();
var addresses = [];
for (var k in interfaces) {
    for (var k2 in interfaces[k]) {
        var address = interfaces[k][k2];
        if (address.family === 'IPv4' && !address.internal) {
            addresses.push(address.address);
        }
    }
}

// HTTPS?
const isHTTPS = false

// connect to mongodb
mongoose.connect(connectionString, { useNewUrlParser: true, useUnifiedTopology: true});
mongoose.Promise = global.Promise;

//app.use(function(req, res, next) {
//      if ((req.get('X-Forwarded-Proto') !== 'https')) {
//        res.redirect('https://' + req.get('Host') + req.url);
//      } else
//        next();
//    });

// use body-parser middleware
app.use(express.json({ limit: '100MB'}));

// initialize routes
if (isHTTPS) {
        app.use (function (req, res, next) {
                if (req.secure) {
                        // request was via https, so do no special handling
                        next();
                } else {
                        // request was via http, so redirect to https
                        res.redirect('https://' + req.headers.host + req.url);
                }
        });
}

app.use('/api', require('./routes/api'));

// def
app.get('/', (req, res) => {
	  res.redirect('/api/test');
});

// error handling
app.use(function(err, req, res, next){
  console.log(err);
  res.status(422).send({error: err.message});
});

// Start server
if (isHTTPS) {
	// Certificate for HTTPS
	const privateKey = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/privkey.pem', 'utf8');
	const certificate = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/cert.pem', 'utf8');
	const ca = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/chain.pem', 'utf8');
	const credentials = {
		                key: privateKey,
		                cert: certificate,
		                ca: ca
		        };
        const httpServer = http.createServer(app);
        const httpsServer = https.createServer(credentials, app);

	// listen for request: https and http
        httpServer.listen(80, () => {
                console.log('HTTP Server running on port 80');
        });

        httpsServer.listen(443, () => {
                console.log('HTTPS Server running on port 443\n');
        });
} else {
        // listen for requests
        app.listen(process.env.port || 80, function(){
                console.log('HTTP server running on port 80\n');
        });

}
console.log("\nLocal IP:")
console.log(addresses);
