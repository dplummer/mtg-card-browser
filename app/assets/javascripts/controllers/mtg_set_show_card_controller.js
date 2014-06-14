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
    }]
  );
