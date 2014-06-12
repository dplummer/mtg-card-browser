angular.module('mtgApp.controllers').
  controller('MtgSetShowController', [
      '$scope',
      '$http',
      '$stateParams',

    function($scope, $http, $stateParams) {
      $http.get('/'+$stateParams.code+'/'+$stateParams.lang+'.json').success(function(data) {
        $scope.mtg_set = data.mtg_set;
      });
    }]
  );
