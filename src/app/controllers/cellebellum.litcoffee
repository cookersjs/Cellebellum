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


# Submission controllers
# ---------------------

# This module provides the controllers for submissions.

    angular
      .module 'cellebellum.controllers.cellebellum', [
        'restangular'
        'chart.js'
      ]

# The controller for the vcf submission, which handles the vcf submission page

      .controller 'CellebellumController', Array '$scope', '$http', '$timeout', 'Restangular', '$sce', ($scope, $http, $timeout, Restangular, $sce) ->

        $scope.methods =  [
          { type:"All Cell Types, Different Timepoints", value:"0", chart:"bar" }
          { type:"Single Cell Type, Expression over Time", value:"1", chart:"line" }
        ]
        $scope.timepoints = [
          { name:'e12', selected: false }
          { name:'e14', selected: false }
          { name:'e16', selected: false }
          { name:'e18', selected: false }
          { name:'p0', selected: false }
          { name:'p7', selected: false }
        ]

        $scope.celltypes = [
          { name:'Astrocytes', selected: false }
          { name:'DCN precursors', selected: false }
          { name:'GABAergic precursors', selected: false }
          { name:'GPCs', selected: false }
          { name:'Immature GCs', selected: false }
          { name:'Immature Neurons', selected: false }
          { name:'Microglia', selected: false }
          { name:'NSCs', selected: false }
          { name:'Neuroblasts', selected: false }
          { name:'Neuronal Progenitors', selected: false }
          { name:'OPCs', selected: false }
          { name:'Oligodendrocytes', selected: false }
          { name:'Purkinje precursors', selected: false }
          { name:'Radial Glia', selected: false }
          { name:'Stem Cells', selected: false }
          { name:'UBCs', selected: false }
        ]

        $scope.timepointsData = {}

        if !$scope.removal
          $scope.removal = 0

        $scope.resetItems = () ->
          newTimes = []
          newCells = []
          if $scope.removal == 1
            for time in $scope.timepoints
              $('#bar' + time.name).hide()
              time.selected = false
              newTimes.push(time)
            $('#lineChart').hide()

            $scope.showDetails = false
            $scope.showElements = false
            $scope.timepoints = []
            $scope.timepoints = newTimes
            # $scope.allSelected = 0;



        $scope.barChartColors = [ "#cc0000","#3cb44b","#ffe119","#0082c8","#f58231","#911eb4","#008080","#aa6e28","#e6beff","#808080","#46f0f0","#800000","#000000","#f032e6","#808000", "#20B2AA"]

        $scope.selectCelltype = (value) ->
          underlineValue = value.replace(" ", "_")
          $scope.celltype = underlineValue

        $scope.resetDropdown = (chartType) ->
          if angular.isDefined($scope.selectedMethod)
            $scope.selectedMethod = null
            $scope.removal = 1
            if chartType == 'bar'
              for time in $scope.timepoints
                if time.selected == true
                  $('#bar' + time.name).show()
            if chartType == 'line'
              $('#lineChart').show()

        # Retrieve the expression results for the selected cell lines
        $scope.submitAllCells = () ->
          timepoints = ['e12','e14','e16','e18','p0','p7']

          Restangular.all('submissions').all('submit').customGET("", gene: $scope.gene, timepoints: timepoints)
          .then (expressions) ->

            $scope.getExpr= (type, data) ->
              updatedCells = []
              for cell in data.cellTypes
                cell = cell.replace("_", " ")
                updatedCells.push(cell)
              data.cellTypes = updatedCells
              $scope.timepointsData[type] = data

            for data in expressions.data.data
                $scope.getExpr(data.timePoint, data)

          .catch (err) ->
            console.log(err)

        $scope.submitCellTimes = () ->

          timepoints = ['e12','e14','e16','e18','p0','p7']

          Restangular.all('submissions').all('submit').customGET("", gene: $scope.gene, timepoints: timepoints)
          .then (expressions) ->

            cellExpressions = {}
            cellExpressions['timepoints'] = []
            cellExpressions['data'] = []
            for data in expressions.data.data
              cellExpressions.gene = data.gene
              cellExpressions.celltype = $scope.celltype
              cellExpressions.timepoints.push(data.timePoint)
              cell_count = 0
              for cell in data.cellTypes
                if cell == $scope.celltype
                  cellExpressions.data.push(Number(data.data[cell_count]))
                cell_count++

            $scope.getCells = () ->
              $scope.cellExpressions = cellExpressions
              return true
