angular.module('mtgApp.controllers').
  controller('SearchController', [
      '$state',
      '$scope',
    function($state, $scope) {
      $scope.search = function() {
        $state.go('mtg.search', {q: $scope.searchTerm})
      }
    }
  ]);
