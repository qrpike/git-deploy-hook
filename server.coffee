



# Global Variables:
# -----------------------------------------
GDH_PORT = ( process.env.GDH_PORT || 2202 )
GDH_SCRIPT = ( process.env.GDH_SCRIPT || ( __dirname+'/gitscript.sh' ) )


# Required Modules:
# -----------------------------------------
EventEmitter = require('events').EventEmitter
restify = require('restify')
async = require('async')
lodash = require('lodash')


# Setup RESTful Server:
# -----------------------------------------
server = restify.createServer
	name: 'GitDeployHook'
server.pre( restify.CORS() )
server.use( restify.acceptParser(server.acceptable) )
server.use( restify.authorizationParser() )
server.use( restify.dateParser() )
server.use( restify.queryParser() )
server.use( restify.jsonp() )
server.use( restify.bodyParser() )
server.use( restify.gzipResponse() )
server.use( restify.throttle
	burst: 100
	rate: 50
	ip: true
	overrides:
		'127.0.0.1':
			rate: 0
			burst: 0
)


# API Error Handling
# -----------------------------------------
server.on 'uncaughtException', (req, res, route, error)=>
	# console.error( 'ERRRRRRRR', error.stack )
	res.send( error )


# Function to make CORS work properly:
# -----------------------------------------
unknownMethodHandler = ( req, res, next )=>
	console.log 'Unknow', req.method
	if req.method.toLowerCase() is 'options'
		allowHeaders = ['Accept', 'Accept-Version', 'Content-Type', 'Api-Version', 'Cache-Control', 'X-Requested-With'];
		if res.methods.indexOf('OPTIONS') is -1 then res.methods.push('OPTIONS')
		res.header 'Access-Control-Allow-Credentials', true
		res.header 'Access-Control-Allow-Headers', allowHeaders.join(', ')
		res.header 'Access-Control-Allow-Origin', req.headers.origin
		res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
		return res.send( 204 )
	else
		return res.send( new restify.MethodNotAllowedError() )
server.on( 'MethodNotAllowed', unknownMethodHandler )


# Run the script on req:
# -----------------------------------------
RunScript = ( req, res )=>
	console.log 'Running:', GDH_SCRIPT
	res.send(200)


# Listen for reqs:
# -----------------------------------------
server.get '/', RunScript
server.post '/', RunScript
server.put '/', RunScript


# Listen for Connections:
# -----------------------------------------
server.listen( GDH_PORT )
console.log 'Serving on:', GDH_PORT


