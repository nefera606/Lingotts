var myApp = angular.module('lingotts');

myApp.controller('ProposalsController', ['$scope', '$http', '$location', '$routeParams', function($scope, $http, $location, $routeParams){
	console.log('ProposalsController loaded...');
	
	$scope.getProposals = function(){
		$http.get('/api/proposals').success(function(response){
			$scope.proposals = response;
		});
	}
		$scope.getProposal = function(){
			var id = $routeParams.id;
		$http.get('/api/proposals/'+id).success(function(response){
			$scope.proposals = response;
		});
	}
			$scope.addProposal = function(){
				console.log($scope.proposal);
		$http.post('/api/proposals/',$scope.proposal).success(function(response){
			window.location.href='#/proposals/'
			});
	}
}]);
