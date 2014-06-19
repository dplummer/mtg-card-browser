var mtgApp = angular.module('mtgApp', [
    'ui.router',
    'mtgApp.controllers',
    'mtgApp.services',
    'angulartics.google.analytics'
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
      .state('mtg', {
        url: '',
        abstract: true,
        views: {
          'search': {
            templateUrl: '/templates/search/form.html',
            controller: 'SearchController'
          }
        }
      })
      .state('mtg.search', {
        url: '/search?q',
        views: {
          '@': {
            templateUrl: '/templates/search/index.html',
            controller: 'SearchResultsController'
          }
        }
      })
      .state('mtg.sets', {
        url: '/',
        views: {
          '@': {
            templateUrl: '/templates/sets/index.html',
            controller: 'MtgSetsController'
          }
        }
      })
      .state('mtg.sets.show', {
        url: ':code/:lang',
        views: {
          '@': {
            templateUrl: '/templates/sets/show.html',
            controller: 'MtgSetShowController'
          }
        }
      })
      .state('mtg.sets.show.card', {
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

