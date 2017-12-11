var myApp = angular.module('myApp');

myApp.controller('BalanceController',['$scope','$http','$location','$routeParams', function($scope, $http, $location, $routeParams){
	$scope.getBalance = function(){
		$http.get('/api/books').success(function(response){
			$scope.books = response;
		});
	}
}]);
