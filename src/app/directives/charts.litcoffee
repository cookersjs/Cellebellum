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


    .directive 'cellebellumExpressionChart', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<svg width="1250" height="500">'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'expression.data', (expressions) ->
            if expressions
              for expression in expressions.data
                names = expression['cellTypes']
                values = expression['data']
                gene = expression['gene']
                timepoint = expression['timePoint']

                display = jQuery(iElement)
                element = display.get()[0]

                # colour = d3.scaleOrdinal(d3.schemeCategory20)

                svg = d3.select(element)
                margin = 200
                width = svg.attr("width") - margin
                height = svg.attr("height") - margin

                svg.append('text')
                  .attr('transform', 'translate(100, 0)')
                  .attr('x', 350)
                  .attr('y', 50)
                  .attr('font-size', '24px')
                  .attr('font-weight', 'bold')
                  # .text(gene + ' Expression: ' + timepoint)

                xScale = d3.scaleBand()
                  .range([0, width - 180])
                  .padding(0.4)

                yScale = d3.scaleLinear()
                  .range([height, 0])

                g = svg.append('g')
                  .attr('transform', 'translate(' + 100 + ',' + 100 + ')')

                xScale.domain names.map((d) -> d)
                yScale.domain [ 0, d3.max(values, (d) -> d + 6)]

                g.append('g')
                  .attr('transform', 'translate(0,' + height + ')')
                  .call(d3.axisBottom(xScale))


                g.append('g')
                  .call d3.axisLeft(yScale).tickFormat((d) ->
                   d
                  ).ticks(10)
                  .append('text')
                  .attr('y', 6)
                  .attr('dy', '0.71em')
                  .attr('text-anchor', 'end')
                  .text('value')

                g.selectAll("rect")
                  .data(values)
                  .enter().append("rect")
                    .attr("class", "bar")
                    .attr("height", (d, i) -> height - yScale(d))
                    .attr("width", "30")
                    .attr("x", (d, i) -> i * 60 + 30)
                    .attr("y", (d) -> yScale(d))
