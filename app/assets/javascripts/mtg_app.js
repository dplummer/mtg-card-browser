var mtgApp = angular.module('mtgApp', [
    'ui.router',
    'mtgApp.controllers',
    'mtgApp.services'
    ]);

angular.module('mtgApp.controllers', []);
angular.module('mtgApp.services', ['ngResource']);

mtgApp.config(['$stateProvider',
               '$urlRouterProvider',
               '$locationProvider',

  function($stateProvider, $urlRouterProvider, $locationProvider) {
    $locationProvider.html5Mode(true);

    $urlRouterProvider.otherwise("/");

    $stateProvider
      .state('sets', {
        url: '/',
        views: {
          '@': {
            templateUrl: '/templates/sets/index.html',
            controller: 'MtgSetsController'
          }
        }
      })
      .state('sets.show', {
        url: ':code/:lang',
        views: {
          '@': {
            templateUrl: '/templates/sets/show.html',
            controller: 'MtgSetShowController'
          }
        }
      })
      .state('sets.show.card', {
        url: '^/:code/:lang/:number',
        views: {
          '@': {
            templateUrl: '/templates/sets/card.html',
            controller: 'MtgSetShowCardController'
          }
        }
      })
  }
]);

