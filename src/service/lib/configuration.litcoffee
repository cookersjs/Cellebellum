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


Cellebellum configuration
------------------------

Imports for the application configuration system.

    log4js = require('log4js')
    logger = log4js.getLogger('configuration')

    nconf =  require('nconf')
    fs =     require('fs')


Cellebellum looks for a configuration file, either passed as a command-line option, or called `config.json` and in
the current working directory. This is a JSON file, and is parsed to provide a wide range of settings throughout
the application. Default values are set here, and in many cases, the default values are sensible.

The module exports a function `getConfiguration` which returns the generated configuration. Although this could be
called repeatedly, that would involve parsing the file repeatedly. It is better to use this once to get the
configuration and store it, say in `app.locals`, where it can be accessed everywhere it is needed.

    ## Fetch config file
    getConfigFile = () ->
      pathList = [
        process.cwd() + "/config/back-end/" + process.env.NODE_ENV + ".json",
        process.cwd() + "/" + process.env.NODE_ENV + ".json"
      ]
      # Look for each of the configuration files in pathList and return the first one found
      for p in pathList
        if fs.existsSync(p)
          return p

    ## Configure ourselves
    module.exports.getConfiguration = () ->
      options = require('minimist')(process.argv.slice(2))
      getConfigFile(process.env.NODE_ENV)
      configFile = options.config || getConfigFile() || ""

      nconf
        .use('memory')
        .argv()

      if configFile != ""
        nconf.add('file', { file: configFile })
        logger.info "Reading configuration file: #{configFile}"

      nconf.defaults
        'cors:allowedUrl': 'http://localhost:8080',
        'data:session:secret': "keyboard cat",
        'data:session:store:url': "mongodb://localhost:27017/session",
        'data:cellebellum:store:url': "mongodb://localhost:27017/cellebellum",
        'data:knowledge:store:url': "mongodb://localhost:27017/cellebellum",
        'cellebellum:submissionUriBase': '/api/submissions',
        'server:port': 3001,
        'server:address': "0.0.0.0",



      nconf.get()
