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

          var opts = {
            customBars: true,
            labels: ['Date', 'Sell Price', 'Volume'],
            series: {
              'Sell Price': {
                axis: 'y'
              },
              'Volume': {
                axis: 'y2'
              }
            },
            showRangeSelector: true,
            rollPeriod: 14,
            connectSeparatedPoints: true
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
