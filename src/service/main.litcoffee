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


The Cellebellum main script
--------------------------

    log4js = require('log4js')
    log4js.configure
        appenders: { cellebellum: { type: 'stdout' } },
        categories: { default: { appenders: ['cellebellum'], level: 'all' } }
    logger = log4js.getLogger('main')

    http  = require 'http'
    https = require 'https'


The application is exported by this module. Circular dependencies are used for the application
(although they are not especially clear to follow, so that is about the only place they are used).

    app = require('./lib/application')

    config = app.locals.config

    logger.info "Express server listening on port " + config['server']['port']


Start HTTP and HTTPS servers

    http.createServer(app)
      .listen config['server']['port'], config['server']['address']


#TODO: We need credentials & have to use a separate port for the HTTPS server.

    ###
    credentials =
      key: ...
      cert: ...

    https.createServer(credentials, app)
      .listen config['server']['port'], config['server']['address']
    ###
