angular.module('mtgApp.controllers').
  controller('MtgSetShowCardController', [
      '$scope',
      '$http',
      '$stateParams',

    function($scope, $http, $stateParams) {
      $http.get('/'+$stateParams.code+'/'+$stateParams.lang+'/'+$stateParams.number+'.json').
        success(function(data) {
          $scope.card = data.mtg_card;
        });

      $http.get('/'+$stateParams.code+'/'+$stateParams.lang+'/'+$stateParams.number+'/price_data.json').
        success(function(data) {
          var graphRows = [];

          data.forEach(function(row, index) {
            graphRows[index] = [
              new Date(row[0]),
              [row[1], row[2], row[3]],
              [row[4], row[4], row[4]]
            ]
          });

          var barChartPlotter = function(e) {
            var ctx = e.drawingContext;
            var points = e.points;
            var y_bottom = e.dygraph.toDomYCoord(0);

            // The RGBColorParser class is provided by rgbcolor.js, which is
            // packed in with dygraphs.
            var color = new RGBColorParser(e.color);
            color.r = Math.floor((255 + color.r) / 2);
            color.g = Math.floor((255 + color.g) / 2);
            color.b = Math.floor((255 + color.b) / 2);
            ctx.fillStyle = color.toRGB();

            // Find the minimum separation between x-values.
            // This determines the bar width.
            var min_sep = Infinity;
            for (var i = 1; i < points.length; i++) {
              var sep = points[i].canvasx - points[i - 1].canvasx;
              if (sep < min_sep) min_sep = sep;
            }
            var bar_width = Math.floor(2.0 / 3 * min_sep);

            // Do the actual plotting.
            for (var i = 0; i < points.length; i++) {
              var p = points[i];
              var center_x = p.canvasx;

              ctx.fillRect(center_x - bar_width / 2, p.canvasy,
                  bar_width, y_bottom - p.canvasy);

              ctx.strokeRect(center_x - bar_width / 2, p.canvasy,
                  bar_width, y_bottom - p.canvasy);
            }
          }

          var opts = {
            customBars: true,
            labels: ['Date', 'Sell Price', 'Volume'],
            series: {
              'Volume': {
                axis: 'y2',
                plotter: barChartPlotter,
                includeZero: true
              },
              'Sell Price': {
                axis: 'y',
                strokeWidth: 2,
                rollPeriod: 14,
                connectSeparatedPoints: true
              }
            },
            showRangeSelector: true
          };

          new Dygraph(document.getElementById("price-data"), graphRows, opts);
        });
    }]
  );

angular.module('mtgApp.controllers').
  directive('graph', function() {
    return {
      restrict: 'E', // Use as element
      scope: { // Isolate scope
        data: '=', // Two-way bind data to local scope
        opts: '=?' // '?' means optional
      },
      template: "<div></div>", // We need a div to attach graph to
      link: function(scope, elem, attrs) {
        debugger;
        var graph = new Dygraph(elem.children()[0], scope.data, scope.opts );
      }
    };
  });
