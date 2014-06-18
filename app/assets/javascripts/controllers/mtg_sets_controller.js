angular.module('mtgApp.controllers').
  controller('MtgSetsController', [
      '$scope',
      '$http',
    function($scope, $http) {
      $http.get('/sets.json').success(function(data) {
        $scope.mtg_sets = data.mtg_sets;
      });
    }
  ]);
