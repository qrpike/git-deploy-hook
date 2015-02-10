# Git Deploy Hook
Deploy your app on GitHub POST url hook.

This is a HTTP service that listens on a port and then runs a specified script when the URL is called.

#### To use the service, clone the repo somewhere.

Then install the npm scripts


	npm install


It's best to use something like Forever to run the script.

	forever start -c coffee server.coffee

Be default it will run on port `2202`

	curl http://localhost:2202

#### Using the service:

GET, PUT or POST to the root directory will run the `gitscript.sh`

Edit the `gitscript.sh` to do whatever it is you like.
