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

        $scope.submitGene = () ->

          timepoints = []
          for time in $scope.timepoints
            if time.selected == true
              timepoints.push(time.name)

          # cell = []
          # for celltype in $scope.celltypes
          #   console.log celltype
            # if celltype.selected == true
            #   console.log celltype.name

          Restangular.all('submissions').all('submit').customPOST(gene: $scope.gene, timepoints: timepoints)
          .then (expressions) ->
            $scope.expression = expressions
