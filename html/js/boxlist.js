(function() {
	var controller = function($location, $scope, client, utils) {
		console.log('controller');
		var u = utils,store = client.store, sa = function(f) { return utils.safe_apply($scope,f); };

		$scope.els_by_box = {};
		$scope.latest_obj = {};

		var update_box_stats = function(b) {
			$scope.els_by_box[b.id] = b.get_obj_ids().length;
		};
		var set_latest_obj = function(b,obj) {
			$scope.latest_obj[b.id] = obj;
		};
		var subscribe_changes = function(b) {
			b.on('obj-add', function(obj) {
				u.safe_apply($scope, update_box_stats);  
				set_latest_object(b,obj);
			});
			b.on('obj-removed', function(obj) {
				u.safe_apply($scope, update_box_stats);  
				set_latest_object(b,obj);
			});
			b.on('obj-add', function(obj) {
				u.safe_apply($scope, update_box_stats);  
				set_latest_object(b,obj);
			});
		};

		var get_boxes_list = function() {
			store.get_box_list().then(function (boxids) {
				u.when(boxids.map(function(b) { return store.get_box(b); })).then(function(boxes) {
					sa(function() {
						$scope.boxes = boxes;
						boxes.map(function(box) { update_box_stats(box); subscribe_changes(box); });
					});
				});
			}).fail(function() {
				sa(function() { delete $scope.boxes; });
				u.error('oops can\'t get boxes - not ready i guess');
			});
		};
		store.on('login', get_boxes_list);
		get_boxes_list();
		$scope.create_new_box = false;
	};
	angular.module('launcher')
		.controller('BoxesListController', controller)
		.directive('boxlist', function() {
			return {
				restrict:'E',
				replace:true,
				controller:controller
			};
		});
})();