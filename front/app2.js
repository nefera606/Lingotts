/* particlesJS.load(@dom-id, @path-json, @callback (optional)); */
particlesJS.load('particles-js', 'assets/particlesjs-config.json', function() {
  console.log('callback - particles.js config loaded');
});
var myApp = angular.module('lingotts',['ngRoute']);

myApp.config(function($routeProvider) {
	$routeProvider.when('/',{
		controller:'BalanceController',
		templateUrl:'main.html'
	})
	.when('/main',{
		controller:'BalanceController',
		templateUrl'main.html'
	})
	.when('/main/proposals', {
		controller:'ProposalsController',
		templateUrl:'views/proposals.html'
	})
	.when('/main/proposals/details:id', {
		controller:'ProposalsController',
		templateUrl:'views/proposalDetails.html'
	})
	.when('/main/proposals/vote:id', {
		controller:'ProposalsController',
		templateUrl:'views/proposalVote.html'
	})
	.when('/main/proposals/add', {
		controller:'ProposalsController',
		templateUrl:'views/proposalCreation.html'
	})
	.when('/main/transfer', {
		controller:'TransferController',
		templateUrl:'views/transfer.html'
	})
	.when('/main/market', {
		controller:'MarketController',
		templateUrl:'views/market.html'
	})
	.otherwise({
		redirectTo'/'
	});
});