# Copyright 2014(c) The Ontario Institute for Cancer Research. All rights reserved.
#
# This program and the accompanying materials are made available under the terms of the GNU Public
# License v3.0. You should have received a copy of the GNU General Public License along with this
# program. If not, see <http://www.gnu.org/licenses/>.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# The main application
# --------------------

    require 'restangular'

# Conditionally require environment variables

    require 'config'

# Require all the dependent packages needed.

    require 'angular'
    require 'angular-route'
    require 'restangular'

# Angular material package
    require 'angular-material'
    require 'angular-animate'
    require 'angular-aria'
    require '../../node_modules/angular-material/angular-material.css'

# Datatables stuff. Ugh, I don't like this but I don't see a better solution for now.

    jQuery.fn.dataTableExt = require 'datatables.net'

# Import Tooltips
    require '../../node_modules/angular-tooltips/dist/angular-tooltips.min.css'
    require '../../node_modules/angular-tooltips/dist/angular-tooltips.min.js'

# Require all of the controllers

    require 'controllers/cellebellum'

# The directives

    require 'directives/charts'

# The services

    require 'services/genomics'

# Import chart.js
    require '../../node_modules/chart.js/dist/Chart.min.js'
    require '../../node_modules/angular-chart.js/dist/angular-chart.min.js'

# Then all of the partials

    CellebellumPartial = require 'cellebellum.html'
    ErrorPartial = require '404.html'

# Define the main app

    angular
      .module 'cellebellum', [
        'ng'
        'ngRoute'
        'restangular'
        'cellebellum.controllers.cellebellum'
        'cellebellum.directives.charts'
        'cellebellum.services.genomics'
        '720kb.tooltips'
        'chart.js'
        'ngMaterial'
        'ngAnimate'
        'ngAria'
      ]


# Configure the page URLs using `$routeProvider`.

      .config Array '$routeProvider', ($routeProvider) ->
        ifExists = {
          getResults: (type, param, route) ->
            ($q, $timeout, $route, Restangular) ->
              p = $q.defer()
              $timeout () ->
                Restangular.all(route).all(type).get($route['current']['params'][param])
                  .then (results) ->
                    p.resolve results
                  .catch (err) ->
                    p.reject err
              return p.promise
        }

        $routeProvider.when "/",                               {template: CellebellumPartial, controller: "CellebellumController"}
        $routeProvider.when "/404",                            {template: ErrorPartial}
        $routeProvider.otherwise {redirectTo: "/404"}


# Set to use HTML5 mode for the URLs, i.e., no need for a visible fragment in the URLs. This should be matched
# in the proxying to make sure these (not API) pages, are mapped to the same `index.html` page. This lets Angular
# take care of the rest.

      .config Array '$locationProvider', ($locationProvider) ->
        $locationProvider.html5Mode(true)
        $locationProvider.hashPrefix = "!"


# Adds restangular, which is used to make restful API calls

      .config Array 'RestangularProvider', (RestangularProvider) ->
        RestangularProvider.setBaseUrl window.__env.apiUrl
        RestangularProvider.setFullResponse true
        RestangularProvider.setDefaultHttpFields withCredentials: false
