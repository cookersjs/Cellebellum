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
        'ngMaterial'
        'ngAnimate'
        'ngAria'
      ]

# The controller for the vcf submission, which handles the vcf submission page

      .controller 'CellebellumController', Array '$scope', '$http', '$timeout', 'Restangular', '$sce', ($scope, $http, $timeout, Restangular, $sce) ->

        $scope.timepointsArray = ['e12','e14','e16','e18','p0','p7']
        $scope.methods =  [
          { type:"All Cell Types, Different Timepoints", value:"0", chart:"bar" }
          { type:"Single Cell Type, Expression over Time", value:"1", chart:"line" }
        ]

        # Set default selected method
        $scope.selectedMethod = $scope.methods[0]

        $scope.timepoints = [
          { name:'e12', selected: true }
          { name:'e14', selected: true }
          { name:'e16', selected: true }
          { name:'e18', selected: true }
          { name:'p0', selected: true }
          { name:'p7', selected: true }
        ]

        # Select and deselect all timepoints
        $scope.updateAllTimepoints = (selected) ->
          for timepoint in $scope.timepoints
            timepoint.selected = selected

        $scope.celltypes = [
          { name:'Astrocytes', selected: true }
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

        # Holds the results for timepoint data
        $scope.timepointsData = {}

        # Holds the results for expression data
        $scope.expressionData = {}

        if !$scope.removal
          $scope.removal = 0

        $scope.barChartColors = [ "#cc0000","#3cb44b","#ffe119","#0082c8","#f58231","#911eb4","#008080","#aa6e28","#e6beff","#808080","#46f0f0","#800000","#000000","#f032e6","#808000", "#20B2AA"]

        # Change selected cell type, update the graph
        $scope.selectCelltype = (value) ->
          $scope.celltype = value
          $scope.cellExpressions = $scope.expressionData[$scope.celltype]

        # Set default selected cell type
        $scope.selectedCellType = $scope.celltypes[0]
        $scope.selectCelltype($scope.selectedCellType.name)

        $scope.getAllCells = (expressions) ->
          $scope.getExpr = (type, data) ->
            updatedCells = []
            for cell in data.cellTypes
              cell = cell.replace("_", " ")
              updatedCells.push(cell)
            data.cellTypes = updatedCells
            $scope.timepointsData[type] = data

          for data in expressions.data.data
              $scope.getExpr(data.timePoint, data)

        $scope.getCellTimes = (expressions) ->
          $scope.expressionData = {}
          for cellType in $scope.celltypes
            expression = {}
            expression.gene = $scope.gene
            expression.timepoints = []
            expression.data = []
            expression.celltype = cellType.name
            $scope.expressionData[cellType.name] = expression
          for data in expressions.data.data
            index = 0
            for cellType in data.cellTypes
              if $scope.expressionData[cellType] != undefined
                $scope.expressionData[cellType].data.push data.data[index]
                $scope.expressionData[cellType].timepoints.push data.timePoint
              index++

          # Seems like there is an issue with cell type naming

          $scope.cellExpressions = $scope.expressionData[$scope.celltypes[0].name]

        # Retrieve the expression results
        $scope.submit = () ->
          if $scope.gene != null && $scope.gene != undefined
            Restangular.all('submissions').all('submit').customGET("", gene: $scope.gene, timepoints: $scope.timepointsArray)
            .then (expressions) ->
              $scope.getAllCells(expressions)
              $scope.getCellTimes(expressions)
            .catch (err) ->
              console.log(err)
