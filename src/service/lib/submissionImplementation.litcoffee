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


Service implementation for the submission service
----------------------

    log4js = require('log4js')
    logger = log4js.getLogger('submissionImplementation')

    async = require('async')
    Busboy = require('connect-busboy')
    path = require('path')
    os = require('os')
    fs = require('fs')
    gunzipFile = require('gunzip-file')
    randomID = require("random-id")
    request = require('request')
    spawn = require('child-process-promise').spawn
    mkdirp = require('mkdirp');
    promisify = require('bluebird').promisify;
    makeDir = promisify(mkdirp);
    uuidv4 = require('uuid/v4');

    MongoClient = require("mongodb").MongoClient

    app = require './application'
    config = app.locals.config

    {
      promisifyRun
      promisifySet
      respondError
    } = require './util'

    promisifySet async, 'each'

Local Functions:

Configure a new client

    vepUrl = config.vep
    circosUrl = config.circos
    delegatorUrl = config.delegator
    mongoUrl = config.data.cellebellum.store.url

    sharedVolume = '/data/cellebellumData/'

Queries Mongo and gets the matching gene data back, if any.

    module.exports.queryMongo = (req, res) ->
      gene = req.body.gene
      MongoClient.connect mongoUrl, (err, db) ->
        db.collection 'cellebellum', (err, cellebellum) ->
          cellebellum.findOne {geneSymbol: gene}, (err, result) ->
            if err
              res.status(404).send
            else
              expressionData = {}
              cellTypes = []
              expressionValues = []
              data = result.data
              for item in result.data
                keys = Object.keys(item)
                key = keys[0];
                cellTypes.push(key)
                expressionValues.push(item[key])
              expressionData['cellTypes'] = cellTypes
              expressionData['data'] = expressionValues
              expressionData['gene'] = gene
              res.status(200).send data: expressionData
            db.close()
