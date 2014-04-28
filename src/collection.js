'use strict';

angular.module('collection', [])

.factory('collection', ['indexOfObj', 'clone', '$parse', function(indexOfObj, _clone, $parse){

	function clone() {
		return collection(_clone(this));
	}

	function set(coll) {
		this.length = 0;
		return this.put(coll);
	}

	function exc(prop, value, context) {
		var idx;

		if( angular.isArray(prop) ) { context = value; }

		if( context ) { return this.not(context.clone().inc(prop, value)); }
		if( angular.isArray(prop) ) { return arrayExc(this, prop, context); }

		idx = this.length;
		while(idx--) { if( this[idx][prop] === value ) { this.splice(idx, 1); } }
		return this;
	}

	function arrayExc(from, filter, context) {
		filter.forEach(function(f) {
			from.exc(f[0], f[1], context);
		});
		return from;
	}

	function inc(filter, value, context) {
		if( !angular.isArray(filter) ) { filter = [[filter, value]]; }
		else { context = value; }

		if( context ) { return this.int(context.clone().inc(filter)); }

		var idx = this.length;
		while(idx--) { if( and(this[idx], filter) ) { this.splice(idx, 1); } }
		return this;
	}

	function and(obj, filter) {
		return filter.reduce(function(memo, f){
			if( angular.isArray(obj[f[0]]) ) {
				memo = memo && obj[f[0]].indexOf(f[1]) === -1;
			} else {
				memo = memo && obj[f[0]] !== f[1];
			}
			return memo;
		}, true);
	}

	function get(key) {
		if( angular.isArray(key) ) { return arrayGet(this, key); }

		var idx = indexOfObj(this, 'key', key);
		if( idx === -1 ) { return undefined; }
		else { return this[idx]; }
	}

	function arrayGet(from, keys) {
		var result = collection(), obj;
		keys.forEach(function(key) {
			if( obj = from.get(key) ) { result.push(obj); }
		});
		return result;
	}

	function put(data) {
		if( angular.isArray(data) ) { return arrayPut(this, data); }

		var idx = indexOfObj(this, 'key', data.key);
		if( idx === -1 ) { this.push(data); }
		else { this.splice(idx, 1, data); }
		return this;
	}

	function arrayPut(to, dataArr) {
		dataArr.forEach(to.put);
		return to;
	}

	function int(coll) {
		return this.inc(coll.map(function(obj){ return ['key', obj.key]; }));
	}

	function not(coll) {
		return this.exc(coll.map(function(obj){ return ['key', obj.key]; }));
	}

	function collection(data) {
		var store = data || [];

		store.clone = clone.bind(store);

		store.get = get.bind(store);
		store.put = put.bind(store);
		store.set = set.bind(store);

		store.inc = inc.bind(store);
		store.exc = exc.bind(store);

		store.int = int.bind(store);
		store.not = not.bind(store);

		return store;
	}

	return collection;
}])

.factory('indexOfObj', [function(){
	return function indexOfObj(arr, attr, value){
		var i = arr.length;
		while(i--){
			if( arr[i] && arr[i][attr] === value ) {
				return i;
			}
		}
		return -1;
	};
}])

.factory('clone', [function(){
	return function(arr) {
		return arr.reduce(function(memo, obj) {
			memo.push(obj);
			return memo;
		}, []);
	};
}]);


