> Copyright 2014(c) The Ontario Institute for Cancer Research. All rights reserved.
>
> This program and the accompanying materials are made available under the terms of the GNU Public
> License v3.0. You should have received a copy of the GNU General Public License along with this
> program. If not, see <http://www.gnu.org/licenses/>.
>
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
> IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
> FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
> CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
> WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Service implementation for submissions
--------------------------------------

    log4js = require('log4js')
    logger = log4js.getLogger('submissionService')

    app = require('./application')
    config = app.locals.config
    base = config["cellebellum"]["submissionUriBase"]

    temp =            require('temp')
    fs =              require("fs")
    bluebird =        require("bluebird")

    MongoClient = require("mongodb").MongoClient

    ## Submission service implementation.
    submission = require("./submissionImplementation")

    router = require('express').Router()

Add middleware to open a database connection, and clean up afterwards

    router.use (req, res, next) =>
      # Allow bypass on content negotiation when the mimeType query parameter is set
      if req.query.mimeType?
        req.headers.accept = req.query.mimeType
        delete req.query.mimeType

      originalEnd = res.end
      res.end = (chunk, encoding) ->
        res.end = originalEnd
        res.end(chunk, encoding)
        if res.locals.db?
          res.locals.db.close()


      res.locals.config = config["cellebellum"]
      res.locals.uriBase = base

      MongoClient.connect config.data.knowledge.store.url, promiseLibrary: bluebird
        .then (db) ->
          db.collection = bluebird.promisify db.collection
          res.locals.db = db
          next()
        .catch next

A log message to show that the submission service has been started.

    logger.info("Initializing submission service")

    # Run a submission
    router.get '/submit', submission.queryMongo

Finally, return the router for embedding in the application.

    module.exports = router
