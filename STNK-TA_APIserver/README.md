# STNK-TA_APIserver

This program is part of Final Project Capstone Design mandated as graduation requirement of Bachelor of Engineering program at Institut Teknologi Bandung. The whole project consists of this repository as the backend and a Flutter aplication as the frontend. This API server provides drivers to MongoDB Collections and provides Henon's Map and Arnold's Map generation for image encryption that are used to safely upload and store image from the Android application.

## Path:
* `/api/verify`
* `/api/perpanjangan`
* `/api/map`

## Installation
1. Install Node.js and Python 3.9.
2. Make sure Python 3.9 can be called by using `python3` alias.
3. Make a `connectionString.txt` file on project's root folder. Put your MongoDB connection string inside it.
4. Install all Node.js dependencies by using npm.
```
npm install
```
4. Install all Python dependencies by using pip.
```
python3 -m pip install --upgrade pip
python3 -m pip install -r ./requirement.txt
```
5. Edit the `index.js` file. Look for `const isHTTPS` in line 26.
* Set the value to `false` if you want the server to **only** listen to port 80 (HTTP), or
* Set the value to  `true` to make the server listen to **both** port 80 (HTTP) and port 443 (HTTPS). Do note that you need to put your TLS certificate in lines 71-73 in `index.js` to use HTTPS, for example by using Let's Encrypt:
```
const privateKey = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/privkey.pem', 'utf8');
const certificate = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/cert.pem', 'utf8');
const ca = fs.readFileSync('/etc/letsencrypt/live/stnk-api-ta.tech/chain.pem', 'utf8');
```
7. Run the server. Linux need root access to open well-known ports.<br>```sudo node index```<br>Simply use `node index` on Windows.<br><br>
This should showed up on your terminal.<br>
![Run](/README/run.png)

8. Test the server by accessing `/api/test`. For example, if you are using it on localhost, try to open `localhost/api/test` on your browser. You could also use the local ip, shown previously, to access it from your local network.<br><br>
This should showed up:<br>
![Access](/README/api_test.png)

## Documentation
WIP
