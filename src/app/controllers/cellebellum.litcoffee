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
      ]

# The controller for the vcf submission, which handles the vcf submission page

      .controller 'CellebellumController', Array '$scope', '$http', '$timeout', 'Restangular', '$sce', ($scope, $http, $timeout, Restangular, $sce) ->

        $scope.methods =  [
          { type:"All Cell Types, Different Timepoints", value:"0" }
          { type:"Single Cell Type, Expression over Time", value:"1" }
        ]
        $scope.timepoints = [
          { name:'p0', selected: false }
          { name:'p7', selected: false }
        ]
        $scope.celltypes = [
          { name:'NSCs', selected: false }
          { name:'GABAergic Neurons', selected: false }
          { name:'DCN Precursors', selected: false }
          { name:'UBCs', selected: false }
          { name:'Meninges', selected: false }
          { name:'OPCs', selected: false }
          { name:'Endothelial Cells', selected: false }
          { name:'Pericytes', selected: false }
          { name:'Microglia', selected: false }
        ]

        $scope.selectCelltype = (value) ->
          $scope.celltype = value

        $scope.submitAllCells = () ->

          timepoints = []
          for time in $scope.timepoints
            if time.selected == true
              timepoints.push(time.name)

          Restangular.all('submissions').all('submit').customPOST(gene: $scope.gene, timepoints: timepoints)
          .then (expressions) ->
            $scope.getp0 = () ->
              if ($scope.timepoints[0].selected == true)
                for data in expressions.data.data
                  if data.timePoint == 'p0'
                    $scope.expression = data
                return true

            $scope.getp7 = () ->
              if ($scope.timepoints[1].selected == true)
                for data in expressions.data.data
                  if data.timePoint == 'p7'
                    $scope.expression = data
                return true


        $scope.submitCellTimes = () ->

          timepoints = ['p0','p7']

          Restangular.all('submissions').all('submit').customPOST(gene: $scope.gene, timepoints: timepoints)
          .then (expressions) ->

            cellExpressions = {}
            cellExpressions['data'] = []
            for data in expressions.data.data
              cellExpressions['gene'] = data.gene
              cellExpressions['cellType'] = $scope.celltype
              cell_count = 0
              for cell in data.cellTypes
                if cell == $scope.celltype
                  cellType = {}
                  cellType['y'] = Number(data.data[cell_count])
                  # cellType['time'] = data.timePoint
                  cellExpressions.data.push(cellType)
                cell_count++

            $scope.getCells = () ->
              $scope.cellExpressions = cellExpressions
              return true
