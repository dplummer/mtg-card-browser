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
          if (data.cards.length > 1) {
            $scope.cards = data.cards;
          } else {
            var card = data.cards[0];
            $state.go('mtg.sets.show.card', {
              code: card.set.code,
              lang: 'en',
              number: card.number
            })
          }
        });
    }
  ]);
