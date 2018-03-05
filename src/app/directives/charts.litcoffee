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

    .directive 'cellebellumCelltypeChart', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<svg width="1250" height="400">'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'cellExpressions', (cellExpressions) ->
            if cellExpressions
              dataset = []
              for element in cellExpressions.data
                dataset.push(element)
              # dataset.push( { 'y': 0.00 })

              # console.log data
                # expressions.push(element.expression)
                # times.push(element.time)

              display = jQuery(iElement)
              element = display.get()[0]

              # svg = d3.select(element)
              # margin = 200
              # width = svg.attr("width") - margin
              # height = svg.attr("height") - margin


              # svg.append('text')
              #   .attr('transform', 'translate(100, 0)')
              #   .attr('x', 350)
              #   .attr('y', 80)
              #   .attr('font-size', '24px')
              #   .attr('font-weight', 'bold')
              #   .text(gene + ' Expression: ' + timepoint)


              margin =
                top: 250
                right: 250
                bottom: 250
                left: 250
              width = window.innerWidth - (margin.left) - (margin.right)
              height = window.innerHeight - (margin.top) - (margin.bottom)
              # Use the window's height
              # The number of datapoints
              n = 2
              # 5. X scale will use the index of our data
              xScale = d3.scaleLinear().domain([
                0
                n - 1
              ]).range([
                0
                width
              ])
              # output
              # 6. Y scale will use the randomly generate number
              yScale = d3.scaleLinear().domain([
                0
                1
              ]).range([
                height
                0
              ])
              # output
              # 7. d3's line generator
              line = d3.line().x((d, i) ->
                xScale i
              ).y((d) ->
                yScale d.y
              ).curve(d3.curveMonotoneX)
              # apply smoothing to the line
              # 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number

              # 1. Add the SVG to the page and employ #2
              svg = d3.select('body').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
              # # 3. Call the x axis in a group tag
              # svg.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call d3.axisBottom(xScale)
              # # Create an axis component with d3.axisBottom
              # # 4. Call the y axis in a group tag
              svg.append('g').attr('class', 'y axis').call d3.axisLeft(yScale)
              # # Create an axis component with d3.axisLeft
              # # 9. Append the path, bind the data, and call the line generator
              svg.append('path').datum(dataset).attr('class', 'line').attr 'd', line
              # # 11. Calls the line generator
              # # 12. Appends a circle for each datapoint
              svg.selectAll('.dot').data(dataset).enter().append('circle').attr('class', 'dot').attr('cx', (d, i) ->
                xScale i
              ).attr 'cy', (d) ->
                yScale d.y




              # x = d3.scaleLinear().range([0, width])
              # y = d3.scaleLinear().range([height, 0])
              #
              # valueline = d3.line().x((d) ->
              #   console.log d
              #   x d.time
              # ).y((d) ->
              #   y d.expression
              # )
              #
              # svg.append("path")
              #   .data([cellExpressions.data])
              #   .attr("class", "line")
              #   .attr("d", valueline)




              # svg.append("g")
              #   .attr("transform", "translate(0," + height + ")")
              #   .call(d3.axisBottom(x))
              #
              # svg.append("g")
              #   .call(d3.axisLeft(y))


              # xScale = d3.scaleBand()
              #   .range([0, width - 180])
              #   .padding(0.4)
              #
              # yScale = d3.scaleLinear()
              #   .range([height, 0])
              #
              # g = svg.append('g')
              #   .attr('transform', 'translate(' + 100 + ',' + 100 + ')')
              #
              # xScale.domain times.map((d) -> d)
              # yScale.domain [ 0, d3.max(expressions, (d) -> d + 6)]
              #
              # g.append('g')
              #   .attr('transform', 'translate(0,' + height + ')')
              #   .call(d3.axisBottom(xScale))
              #
              #
              # g.append('g')
              #   .call d3.axisLeft(yScale).tickFormat((d) ->
              #    d
              #   ).ticks(10)
              #   .append('text')
              #   .attr('y', 6)
              #   .attr('dy', '0.71em')
              #   .attr('text-anchor', 'end')
              #   .text('value')

              # lineFunc = d3.svg.line()
              #   .x((d) ->
              #   xRange d.x
              # ).y((d) ->
              #   yRange d.y
              # ).interpolate('linear')

              # g.selectAll("rect")
              #   .data(expressions)
              #   .enter().append("rect")
              #     .attr("class", "line")
              #     .attr("height", (d, i) -> height - yScale(d))
              #     .attr("width", "30")
              #     .attr("x", (d, i) -> i * 60 + 30)
              #     .attr("y", (d) -> yScale(d))

    .directive 'cellebellumExpressionChart', () ->
      result =
        restrict: "A"
        replace: true
        transclude: true
        scope: false
        template: '<svg width="1250" height="400">'
        link: (scope, iElement, iAttrs) ->
          scope.$watch 'expression', (expression) ->
            if expression
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
                .attr('y', 80)
                .attr('font-size', '24px')
                .attr('font-weight', 'bold')
                .text(gene + ' Expression: ' + timepoint)

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
