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

# Genomics services
# -----------------

    require 'd3'

# A module for genomics services.

    angular
      .module 'cellebellum.services.genomics', []


# The `transformDomains` service is used to organize domains for display within the protein displays.
# That primarily involves sorting the domains and handling overlaps, filtering out small domains when
# they are enclosed by a bigger domain. This is something of a heuristic to handle the way Pfam tags
# small parts of domains, which we don't eally want to display in a large view.

      .factory 'd3Service', () ->
        console.log "Hello"
        return true
