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

    .directive 'celleBarChart', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: { expr: "=" }
        template: '<div><canvas class="chart chart-bar" chart-data="points" chart-labels="labels" chart-options="options" chart-colors="barColors"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'expr', (expr) ->
            if expr
              scope.labels = expr.cellTypes
              scope.points = expr.data
              title = expr.gene + " Expression: " + expr.timePoint
              scope.options = {
                responsive: true,
                maintainAspectRatio: true,
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
                  }],
                  yAxes: [{
                    scaleLabel: {
                      display:true,
                      labelString: 'Normalized  Expression'
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
        template: '<div><canvas id="line" class="chart chart-line" chart-data="expressCelltypes" chart-labels="celltypesLabels" chart-options="celltypesOptions" chart-hover="lineHover"></canvas></div>'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'cellExpressions', (cellExpressions) ->
            if cellExpressions && cellExpressions.data != undefined
              scope.expressCelltypes = cellExpressions.data
              scope.celltypesLabels = cellExpressions.timepoints
              updatedCell = cellExpressions.celltype.replace("_", " ")
              title = cellExpressions.gene + " expression in " + updatedCell
              scope.celltypesOptions = {
                responsive: true,
                maintainAspectRatio: true,
                elements: {line: { fill: false }},
                title: {
                  display: true,
                  position: 'top',
                  text: title,
                  fontSize: 18
                }
                scales: {
                  yAxes: [{
                    scaleLabel: {
                      display:true,
                      labelString: 'Normalized  Expression',
                      fontSize: 18
                    }
                  }],
                  xAxes: [{
                    scaleLabel: {
                      display:true,
                      labelString: 'Timepoints',
                      fontSize: 18
                    }
                  }]
                },
                tooltips: {
                  callbacks: {
                    # title: (tooltipItem, data) ->
                    #   value = data.datasets[tooltipItem[0].datasetIndex].data[tooltipItem[0].index];
                    #   console.log value
                    #   return "Timepoint: " + value
                    # ,
                    label: (tooltipItem, data) ->
                      value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                      if value == 0
                        value = "0.00"
                      return value
                    # ,
                    # afterLabel: (tooltipItem, data) ->
                    #   value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                    #   return "Segment "
                  }
                },
                hover: {
                  mode: 'nearest'
                }
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
            #   # }
