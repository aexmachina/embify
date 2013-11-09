config = require './config'
express = require 'express'
# cors = require 'cors'

app = express()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: 'adsf0ijc2poijas'
app.use express.logger()
# app.use cors()

require('./routes').init(app)

module.exports = app
