> Copyright 2017(c) The Ontario Institute for Cancer Research. All rights reserved.
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

# Utilities to be used throughout the backend.


## Promises
See `bluebird` documentation.

    promisify = require('bluebird').promisify

    # Permanently promisify method(s) of an object.
    module.exports.promisifySet = promisifySet = (object, methods...) ->
      for method in methods
        object[method] = promisify object[method], context: object

    # One-time promisified run of a method given any params.
    module.exports.promisifyRun = (object, methodStr, params...) ->
      promisify(object[methodStr], context: object) params...


## Errors

Should use `respondError(res)()` as Promise catch callbacks.

`respondError(res)` returns a `function(error)`.
* `res` is an object with status and send methods.
* `error` is either an object with an integer `code` and string `msg` or somehting else.
* `function(error)` sends an appropriate error code and object using `res`.

    module.exports.respondError = (res) -> (error) ->
      if typeof error is 'object'
        if error.code?
          if error.code >= 100 and error.code < 600
            res.status error.code
          else
            res.status 500
        if error.msg? then res.send error.msg else res.send error
      else res.status(500).send error

    module.exports.NoSuchObjectException = (obj) ->
      code: 404, msg: "no such object: #{JSON.stringify obj}"


## Mongo Helpers

    async = require 'async'
    promisifySet async, 'eachOf'

    # Returns a promise given a db and a list of collection names.
    # Resolves to an object of Collections indexed by name.
    module.exports.getCollections = (db, names) ->
      collectionsObj = {}
      async.each names, (name, callback) ->
        db.collection name
          .then (collection) ->
            collectionsObj[name] = collection
            callback()
          .catch Promise.reject
      .then -> Promise.resolve collectionsObj
