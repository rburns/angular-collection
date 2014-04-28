describe 'collection', () ->

	collection = null
	stuff = null
	things = null
	widgets = null

	api = ['get', 'put', 'exc', 'inc', 'int', 'not']
	isCollection = (obj) ->
		result = true
		result = result && angular.isFunction(obj[fn]) for fn in api
		result

	beforeEach module 'collection'

	beforeEach inject ($injector) ->
		collection = $injector.get('collection')
		stuff = collection([
			{key: 1, content: 'foo', other: 'that'}
			{key: 2, content: 'bar', other: 'it'}
			{key: 3, content: 'baz'}
		])
		things = collection([
			{key: 2, content: 'bar'}
			{key: 5, content: 'cherry'}
			{key: 6, content: 'bar'}
		])
		widgets = collection([
			{key: 1, content: 'apple'}
			{key: 2, content: 'berry'}
			{key: 3, content: 'melon'}
		])
		return

	it 'is an array', () ->
		expect(angular.isArray stuff).to.equal(true)

	describe '#set', () ->

		it 'sets the content of the collection to the content of the provided collection', () ->
			stuff.set(things)
			expect(stuff[0]).to.deep.equal(things[0])
			expect(stuff[1]).to.deep.equal(things[1])
			expect(stuff[2]).to.deep.equal(things[2])

		it 'returns the collection', () ->
			result = stuff.set(things)
			expect(result).to.deep.equal(stuff)

	describe '#get', () ->

		it 'retrieves an object by key', () ->
			expect(stuff.get(1).content).to.equal('foo')

		it 'returns undefined if object with key doesn\'t exist', () ->
			expect(stuff.get('notthere')).to.equal(undefined)

		it 'returns a collection of objects, for an array of keys', () ->
			result = stuff.get([1,2])
			expect(isCollection result).to.equal(true)
			expect(result.length).to.equal(2)
			expect(result[0].content).to.equal('foo')
			expect(result[1].content).to.equal('bar')

	describe '#put', () ->

		it 'adds an object to the collection', () ->
			stuff.put {key: 4, content: 'boo'}
			expect(stuff.length).to.equal(4)
			expect(stuff[3].content).to.equal('boo')

		it 'replaces an object if it exists in the collection', () ->
			stuff.put {key: 3, content: 'boo'}
			expect(stuff.length).to.equal(3)
			expect(stuff[2].content).to.equal('boo')

		it 'accepts arrays of objects', () ->
			stuff.put [{key: 4, content: 'boo'}, {key: 5, content: 'bay'}]
			expect(stuff.length).to.equal(5)

		it 'returns the collection', () ->
			result = stuff.put {key: 4, content: 'boo'}
			expect(result).to.deep.equal(stuff)

	describe '#exc', () ->

		it 'removes objects from the collection that match by property and value', () ->
			stuff.exc 'content', 'bar'
			expect(stuff.length).to.equal(2)
			expect(stuff[0].content).to.equal('foo')
			expect(stuff[1].content).to.equal('baz')

		it 'accepts mutiple properties and values as an array of pairs', () ->
			stuff.exc [['content', 'bar'], ['content', 'foo']]
			expect(stuff.length).to.equal(1)
			expect(stuff[0].content).to.equal('baz')

		it 'returns the collection', () ->
			result = stuff.exc 'content', 'bar'
			expect(result).to.deep.equal(stuff)

		describe 'with context', () ->

			it 'filters relative to the context', () ->
				things.exc 'other', 'it', stuff
				expect(things.length).to.equal(2)
				expect(things[0].content).to.equal('cherry')
				expect(things[1].content).to.equal('bar')

			it 'accepts multiple properties and values as an array of pairs', () ->
				widgets.exc [['other', 'it'], ['other', 'that']], stuff
				expect(widgets.length).to.equal(1)
				expect(widgets[0].content).to.equal('melon')

			it 'does not modify the context', () ->
				things.exc 'other', 'it', stuff
				expect(stuff.length).to.equal(3)

			it 'returns the collection', () ->
				result = things.exc 'other', 'it', stuff
				expect(result).to.equal(things)

	describe '#inc', () ->

		it 'removes objects from the collection which do not match by property and value', () ->
			stuff.inc 'content', 'bar'
			expect(stuff.length).to.equal(1)

		it 'accepts mutiple properties and values as an array of pairs', () ->
			stuff.inc [['content', 'bar'], ['content', 'foo']]
			expect(stuff.length).to.equal(2)
			expect(stuff[0].content).to.equal('foo')
			expect(stuff[1].content).to.equal('bar')

		it 'accepts a single property as an array of a single pair', () ->
			things.inc([['key', 2]])
			expect(things.length).to.equal(1)
			expect(things[0].content).to.equal('bar')

		it 'returns the collection', () ->
			result = stuff.inc 'content', 'bar'
			expect(result).to.equal(stuff)

		describe 'with context', () ->

			it 'filters relative to the context', () ->
				things.inc 'other', 'it', stuff
				expect(things.length).to.equal(1)
				expect(things[0].content).to.equal('bar')

			it 'accepts multiple properties and values as an array of pairs', () ->
				widgets.inc [['other', 'it'], ['other', 'that']], stuff
				expect(widgets.length).to.equal(2)
				expect(widgets[0].content).to.equal('apple')
				expect(widgets[1].content).to.equal('berry')

			it 'does not modify the context', () ->
				things.inc 'other', 'it', stuff
				expect(stuff.length).to.equal(3)

			it 'returns the collection', () ->
				result = things.inc 'other', 'it', stuff
				expect(result).to.equal(things)

		describe 'when provided a property with an array value', () ->

			stuff = null

			beforeEach () ->
				stuff = collection([
					{key: 'foo', c: [1,3,4]}
					{key: 'bar', c: [8,2,1]}
					{key: 'baz', c: [9,5,4]}
				])

			it 'filters based on presence of the provided value in the array', () ->
				result = stuff.inc('c', 1)
				expect(stuff.length).to.equal(2)
				expect(stuff[0].key).to.equal('foo')
				expect(stuff[1].key).to.equal('bar')

	describe '#int', () ->

		it 'limits the collection by the intersection with the provided collection', () ->
			stuff.int(things)
			expect(stuff.length).to.equal(1);
			expect(stuff[0].content).to.equal('bar');

		it 'returns the collection', () ->
			result = stuff.int(things)
			expect(result).to.deep.equal(stuff)

	describe '#not', () ->

		it 'limits the collection by the exclusion of the provided collection', () ->
			stuff.not(things)
			expect(stuff.length).to.equal(2)
			expect(stuff[0].content).to.equal('foo')
			expect(stuff[1].content).to.equal('baz')

		it 'returns the collection', () ->
			result = stuff.not(things)
			expect(result).to.deep.equal(stuff)
