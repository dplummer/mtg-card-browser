angular.module('mtgApp.controllers').
  controller('SearchResultsController', [
      '$state',
      '$scope',
      '$http',
      '$stateParams',

    function($state, $scope, $http, $stateParams) {
      $scope.searchTerm = $stateParams.q;
      $http.get('/search.json?q='+$stateParams.q).
        success(function(data) {
          $scope.cards = data.cards;
        });
    }
  ]);
