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


# Charting directives
# -------------------

    require 'services/genomics'

# This module provides the directives which implement charts in the application. Charting is done
# by d3 at the low level.

    angular
      .module 'cellebellum.directives.charts', [ 'cellebellum.services.genomics' ]


# Directive pertaining to chart generation for Cellebellum

    .directive 'celleBarChart12', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="e12Points" chart-labels="e12Labels" chart-options="e12Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'e12', (e12) ->
            if e12
              scope.e12Labels = e12.cellTypes
              scope.e12Points = e12.data
              title = e12.gene + " Expression: " + e12.timePoint
              scope.e12Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope


    .directive 'celleBarChart14', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="e14Points" chart-labels="e14Labels" chart-options="e14Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'e14', (e14) ->
            if e14
              scope.e14Labels = e14.cellTypes
              scope.e14Points = e14.data
              title = e14.gene + " Expression: " + e14.timePoint
              scope.e14Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope

    .directive 'celleBarChart16', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="e16Points" chart-labels="e16Labels" chart-options="e16Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'e16', (e16) ->
            if e16
              scope.e16Labels = e16.cellTypes
              scope.e16Points = e16.data
              title = e16.gene + " Expression: " + e16.timePoint
              scope.e16Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope

    .directive 'celleBarChart18', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="e18Points" chart-labels="e18Labels" chart-options="e18Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'e18', (e18) ->
            if e18
              scope.e18Labels = e18.cellTypes
              scope.e18Points = e18.data
              title = e18.gene + " Expression: " + e18.timePoint
              scope.e18Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope

    .directive 'celleBarChart0', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="p0Points" chart-labels="p0Labels" chart-options="p0Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'p0', (p0) ->
            if p0
              scope.p0Labels = p0.cellTypes
              scope.p0Points = p0.data
              title = p0.gene + " Expression: " + p0.timePoint
              scope.p0Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope

    .directive 'celleBarChart7', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas class="chart chart-bar" chart-data="p7Points" chart-labels="p7Labels" chart-options="p7Options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'p7', (p7) ->
            if p7
              scope.p7Labels = p7.cellTypes
              scope.p7Points = p7.data
              title = p7.gene + " Expression: " + p7.timePoint
              scope.p7Options = {
                title: {
                  display: true,
                  position: 'top',
                  text: title
                },
                scales: {
                  xAxes: [{
                    ticks: {
                      autoSkip: false
                    }
                    }]
                }
              }
              scope.barColors = scope.barChartColors
              return scope


    .directive 'celleLineChart', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<div><canvas id="line" style="height:500px;width:500px;" class="chart chart-line" chart-data="expressCelltypes" chart-labels="celltypesLabels" chart-options="celltypesOptions"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'cellExpressions', (cellExpressions) ->
            if cellExpressions
              scope.expressCelltypes = cellExpressions.data
              scope.celltypesLabels = cellExpressions.timepoints
              scope.celltypesOptions = {
                elements: {line: { fill: false }}
              }
            #   scope.colors = [{
            #     backgroundColor : '#0062ff',
            #     pointBackgroundColor: '#0062ff',
            #     pointHoverBackgroundColor: '#0062ff',
            #     borderColor: '#0062ff',
            #     pointBorderColor: '#0062ff',
            #     pointHoverBorderColor: '#0062ff',
            #     fill: false
            # }, '#00ADF9', '#FDB45C', '#46BFBD'];
              # scope.celltypesColors = {
              #   backgroundColor: 'transparent',
              #   borderColor: '#F78511',
              # }
